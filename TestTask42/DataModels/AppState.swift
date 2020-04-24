//
//  AppState.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

enum AppState {

    case idle
    case playing
    case recording
    indirect case paused(from: AppState)
}

// MARK: - Flow

extension AppState {
    
    var next: AppState {
        switch self {
        case .idle: return .playing
        case .playing: return .paused(from: .playing)
        case .recording: return .paused(from: .recording)
        case .paused(let state): return state
        }
    }
    
    var autoNext: AppState? {
        switch self {
        case .idle: return nil
        case .playing: return .recording
        case .recording: return .idle
        case .paused(let state): return state.autoNext
        }
    }
}

// MARK: - Literals

extension AppState {
    
    var title: String {
        switch self {
        case .idle: return Localization.State.idle
        case .playing: return Localization.State.playing
        case .recording: return Localization.State.recording
        case .paused: return Localization.State.paused
        }
    }
    
    var button: String {
        switch self {
        case .idle: return Localization.Buttons.play
        case .paused(.playing): return Localization.Buttons.play
        case .paused(.recording): return Localization.Buttons.record
        case .playing, .recording: return Localization.Buttons.pause
        case .paused: return Localization.Buttons.play
        }
    }
}

// MARK: - Delegate

protocol AppStateDelegate: class {
    
    func appStateDidChange(to state: AppState)
}
