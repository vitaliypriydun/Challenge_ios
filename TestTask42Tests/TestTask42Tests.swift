//
//  TestTask42Tests.swift
//  TestTask42Tests
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import XCTest

class TestTask42Tests: XCTestCase {

    override func setUp() { }

    override func tearDown() { }

    func testSoundAvailability() {
        let natureUrl = Bundle.main.url(forResource: "nature", withExtension: "m4a")
        let alarmUrl = Bundle.main.url(forResource: "alarm", withExtension: "m4a")
        XCTAssertNotNil(natureUrl, "Missing nature media file")
        XCTAssertNotNil(alarmUrl, "Missing alarm media file")
    }
}
