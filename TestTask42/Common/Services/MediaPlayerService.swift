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
    func set(delegate: MediaPlayerDelegate)
    
    func playSound(sleepTimer: SleepTime)
    func pause()
    func unpause()
}

protocol AlarmPlayerService {
    
    func playAlarm()
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
    
    private weak var delegate: MediaPlayerDelegate?
    
    private var audioPlayer = AVAudioPlayer()
    
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
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ in
        guard let self = self else { return .commandFailed }
            self.audioPlayer.pause()
            self.delegate?.appStateDidChange(to: .paused(at: Date(), from: .playing))
            return .success
        }
    }
    
    private func setupSleepTimer(_ sleepTimer: SleepTime) {
        guard sleepTimer != .off else { return }
        let fireDate = Date.dateByAdding(sleepTime: sleepTimer)
        let timer = Timer(fireAt: fireDate, interval: 0, target: self, selector: #selector(sleepTimerAction), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc private func sleepTimerAction() {
        audioPlayer.stop()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        delegate?.appStateDidChange(to: .recording)
    }
}

// MARK: - MediaPlayerService

extension DefaultMediaPlayerService: MediaPlayerService {
    
    func startRecording() {
        
    }
    
    func pauseRecording() {
        
    }
    
    func stopAlarm() {
        
    }
   
    func playAlarm() {
        guard let url = URL.natureSoundUrl else { return }
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
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
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
    
    func unpause() {
        audioPlayer.play()
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
        return Date().addingTimeInterval(TimeInterval(60 * sleepTime.rawValue))
    }
}
