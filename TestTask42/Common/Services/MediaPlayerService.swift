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

class DefaultMediaPlayerService {
    
    var isPlaying: Bool { return audioPlayer.isPlaying }
    
    private weak var delegate: MediaPlayerDelegate?
    private var audioPlayer = AVAudioPlayer()
    private var timer: Timer?
    private var remainingTime: TimeInterval?
    
    init() {
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
    }
    
    /// Trigger the alarm sound
    private func startAlarm() {
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
}

// MARK: - MediaPlayerService

extension DefaultMediaPlayerService: MediaPlayerService {
    
    func startRecording() {
        
    }
    
    func pauseRecording() {
        
    }
    
    // MARK: - Alarm
    
    func stopAlarm() {
        
    }
   
    func scheduleAlarm(at date: Date) {
        
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

    // MARK: - Delegate
    
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
        // TODO: Fix seconds per minute for release
        return Date().addingTimeInterval(TimeInterval(5 * sleepTime.rawValue))
    }
}
