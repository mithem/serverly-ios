//
//  checkEndpointPathTest.swift
//  serverlyTests
//
//  Created by Miguel Themann on 13.07.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import XCTest
@testable import serverly

class checkEndpointPathTest: XCTestCase {
    func testPositives() throws {
        XCTAssert(checkEndpointPath("/hello"))
        XCTAssert(checkEndpointPath("^/hello$"))
        
        XCTAssert(checkEndpointPath("/whats/upp"))
        XCTAssert(checkEndpointPath("/hey/lets/see/if/this/keeps/goin"))
        
        XCTAssert(checkEndpointPath("/another/page?weather=good&trump=not%20good"))
        XCTAssert(checkEndpointPath("/and/once/again/?slightly=yes&different=no"))
        
        
        XCTAssert(checkEndpointPath("////"))
        XCTAssert(checkEndpointPath(#"/sdkj2qpa-oi#1C20*N842!4#$.40QO%V&=s?r)b8q8/0("#))
    }
    
    func testNegatives() throws {
        XCTAssert(!checkEndpointPath("hello"))
        
        XCTAssert(!checkEndpointPath("/ä"))
        XCTAssert(!checkEndpointPath("/ö"))
        XCTAssert(!checkEndpointPath("/ü"))
        XCTAssert(!checkEndpointPath("/ß"))
        
        XCTAssert(!checkEndpointPath("/🎉"))
    }
}
