//
//  SleepTime.swift
//  TestTask42
//
//  Created by Vitalii on 24.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

enum SleepTime: Int, CaseIterable {

    case off = 0
    case minute = 1
    case fiveMinutes = 5
    case tenMinutes = 10
    case fifteenMinutes = 15
    case twentyMinutes = 20
}

// MARK: - Literals

extension SleepTime {
    
    var text: String {
        switch self {
        case .off: return Localization.SleepTime.off
        case .minute, .fiveMinutes, .tenMinutes, .fifteenMinutes, .twentyMinutes: return "\(rawValue) " + Localization.SleepTime.min
        }
    }
}
