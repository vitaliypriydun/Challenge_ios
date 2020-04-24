//
//  ServicesFactory.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

class ServicesFactory: NSObject {

    func makeMediaPlayerService() -> MediaPlayerService {
        return DefaultMediaPlayerService()
    }
}
