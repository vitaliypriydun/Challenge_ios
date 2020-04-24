//
//  MediaPlayerService.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

protocol MediaPlayerService {
    
    func playSound()
}

class DefaultMediaPlayerService {
    
    init() {
        
    }
}

// MARK: - MediaPlayerService

extension DefaultMediaPlayerService: MediaPlayerService {
    
    func playSound() {
        // TODO
    }
}
