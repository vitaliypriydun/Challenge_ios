//
//  MediaPlayerService.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

typealias MediaPlayerService = SleepPlayerService & AlarmPlayerService & RecordingService

protocol SleepPlayerService {
    
    var isPlaying: Bool { get }
    
    func playSound(sleepTimer: SleepTime)
    func update(sleepTimer: SleepTime)
    func pause()
    func unpause()
    func set(delegate: MediaPlayerDelegate)
}

protocol AlarmPlayerService {
    
    func scheduleAlarm(at date: Date)
    func stopAlarm()
}

protocol RecordingService {
    
    func startRecording()
    func pauseRecording()
}

protocol MediaPlayerDelegate: AppStateDelegate {
    
    func mediaPlayerErrorOccured(_ error: String)
}

// MARK: - Implementation

class DefaultMediaPlayerService: NSObject {
    
    var isPlaying: Bool { return audioPlayer.isPlaying }
    
    private weak var delegate: MediaPlayerDelegate?
    private var audioPlayer = AVAudioPlayer()
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var alarmTimer: Timer?
    private var remainingTime: TimeInterval?
    
    override init() {
        super.init()
        setupRemoteTransportControls()
    }
    
    // MARK: - Private
    
    /// Adding interaction with ios media player (play and pause buttons)
    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] _ in
            guard let self = self else { return .commandFailed }
            self.audioPlayer.play()
            self.delegate?.appStateDidChange(to: .playing)
            self.unpauseTimer()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
        guard let self = self else { return .commandFailed }
            self.pauseTimer()
            self.audioPlayer.pause()
            self.delegate?.appStateDidChange(to: .paused(from: .playing))
            return .success
        }
    }
    
    private func pauseTimer() {
        remainingTime = timer?.fireDate.timeIntervalSinceNow
        timer?.invalidate()
        timer = nil
    }
    
    private func unpauseTimer() {
        guard let remainingTime = remainingTime else { return }
        let timer = Timer(fireAt: Date().addingTimeInterval(remainingTime), interval: 0, target: self,
                          selector: #selector(sleepTimerAction), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    /// Setting sleep timer to stop nature sound
    private func setupSleepTimer(_ sleepTimer: SleepTime) {
        guard sleepTimer != .off else { return }
        let fireDate = Date.dateByAdding(sleepTime: sleepTimer)
        let timer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(sleepTimerAction), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    @objc private func sleepTimerAction() {
        timer?.invalidate()
        timer = nil
        audioPlayer.stop()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        delegate?.appStateDidChange(to: .recording)
        setRecordingState()
    }
    
    /// Trigger the alarm sound
    @objc private func playAlarm() {
        dropAllAudio()
        guard let url = URL.alarmSoundUrl else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = -1
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer.play()
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        } catch {
            delegate?.mediaPlayerErrorOccured(Localization.Error.failedToOpenFile)
        }
        delegate?.appStateDidChange(to: .idle)
    }
    
    private func dropAllAudio() {
        audioPlayer.stop()
        audioRecorder?.stop()
        audioRecorder = nil
        timer?.invalidate()
        remainingTime = nil
        timer = nil
    }
    
    /// Updating remaining time of timer when user changes sleep timer during plaing
    private func updateRemainingTime(with sleepTime: SleepTime) {
         guard sleepTime != .off else { 
            remainingTime = nil
            timer?.invalidate()
            timer = nil
            return
        }
        let interval = Date.dateByAdding(sleepTime: sleepTime).timeIntervalSinceNow
        guard let remainingTime = remainingTime else {
            self.remainingTime = interval
            return
        }
        if interval > remainingTime {
            self.remainingTime = interval - remainingTime
        } else {
            self.remainingTime = interval
        }
    }
    
    /// Record audio and save it to file
    private func createRecordingSession() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let audioFilename = paths[0].appendingPathComponent("recording_\(Date().toString).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
        } catch {
            delegate?.mediaPlayerErrorOccured(Localization.Error.failedToStartRecording)
        }
    }
    
    private func setRecordingState() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { allowed in
                DispatchQueue.main.async { [weak self] in
                    if allowed {
                        self?.createRecordingSession()
                    } else {
                        self?.delegate?.appStateDidChange(to: .paused(from: .recording))
                        self?.delegate?.mediaPlayerErrorOccured(Localization.Error.audioPermissionRequired)
                    }
                }
            }
        } catch {
            delegate?.mediaPlayerErrorOccured(Localization.Error.failedToStartRecording)
        }
    }
    
    private func finishRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
}

// MARK: - MediaPlayerService

extension DefaultMediaPlayerService: MediaPlayerService {
    
    func startRecording() {
        guard let audioRecorder = audioRecorder else {
            setRecordingState()
            return
        }
        audioRecorder.record()
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
    }
    
    // MARK: - Alarm
    
    func stopAlarm() {
        audioPlayer.stop()
    }
   
    func scheduleAlarm(at date: Date) {
        alarmTimer?.invalidate()
        alarmTimer = nil
        guard date > Date() else { return }
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(playAlarm), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
        alarmTimer = timer
    }
    
    // MARK: - Player
    
    func playSound(sleepTimer: SleepTime) {
        guard let url = URL.natureSoundUrl else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.numberOfLoops = -1
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer.play()
            var nowPlayingInfo = [String: Any]()
            nowPlayingInfo[MPMediaItemPropertyTitle] = "Nature.m4a"
            let playerItem = AVPlayerItem(asset: AVAsset(url: url))
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.duration.seconds
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        } catch {
            delegate?.mediaPlayerErrorOccured(Localization.Error.failedToOpenFile)
        }
        setupSleepTimer(sleepTimer)
    }
    
    func pause() {
        audioPlayer.pause()
        pauseTimer()
    }
    
    func unpause() {
        audioPlayer.play()
        unpauseTimer()
    }
    
    func update(sleepTimer: SleepTime) {
        if timer != nil {
            pauseTimer()
            updateRemainingTime(with: sleepTimer)
            unpauseTimer()
        } else {
            updateRemainingTime(with: sleepTimer)
            if audioPlayer.isPlaying {
                unpauseTimer()
            }
        }
    }
    
    func set(delegate: MediaPlayerDelegate) {
        self.delegate = delegate
    }
}

// MARK: - Constants

private extension URL {
    
    static var natureSoundUrl: URL? { return Bundle.main.url(forResource: "nature", withExtension: "m4a") }
    static var alarmSoundUrl: URL? { return Bundle.main.url(forResource: "alarm", withExtension: "m4a") }
}

private extension Date {
    
    static func dateByAdding(sleepTime: SleepTime) -> Date {
        return Date().addingTimeInterval(TimeInterval(1 * sleepTime.rawValue)) // TODO:
    }
}
