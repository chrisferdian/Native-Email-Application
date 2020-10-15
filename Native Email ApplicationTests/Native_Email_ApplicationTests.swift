//
//  Native_Email_ApplicationTests.swift
//  Native Email ApplicationTests
//
//  Created by TMLI IT DEV on 13/10/20.
//

import XCTest
@testable import Native_Email_Application

class Native_Email_ApplicationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testDate() {
        let dateStr = "09 - 04 - 2018 06: 21: 10"
        XCTAssertNotNil(dateStr.toDate())
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
