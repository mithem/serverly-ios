//
//  CustomizationSettingsTests.swift
//  serverlyTests
//
//  Created by Miguel Themann on 21.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import XCTest
@testable import serverly

class CustomizationSettingsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetKeyName() {
        serverly.CustomizationSettingsViewController.getKeyName(CustomizationSettingsViewController())
    }

}
