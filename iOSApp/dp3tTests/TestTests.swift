//
//  TestTests.swift
//  TestTests
//
//  Created by Ishaan Mathur on 8/15/20.
//  Copyright © 2020 Mathur. All rights reserved.
//

import XCTest
@testable import Test

class TestTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        DP3T.resetDefaults()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEphID() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var date = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: Date())!
        var dp3t = DP3T(date: date)
        
        // Test if ephID is the same at 1:00 AM UTC and 1:14 AM UTC
        let id1 = dp3t.getCurrentEphID()
        date = date.addingTimeInterval(60 * 14)
        dp3t = DP3T(date: date)
        let id2 = dp3t.getCurrentEphID()
        
        XCTAssertEqual(id1, id2)
        
        // Test if ephID is different at 1:14 AM UTC and 1:16 AM UTC
        date = date.addingTimeInterval(60 * 2)
        dp3t = DP3T(date: date)
        let id3 = dp3t.getCurrentEphID()
        
        XCTAssertNotEqual(id2, id3)
    }
    
    func testAllEphIDs() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        var dp3t = DP3T(date: date)
        var ephIDs: Set<String> = []
        
        // Test if all ephIDs are unique throughout the day
        for _ in 0..<96 {
            ephIDs.insert(dp3t.getCurrentEphID())
            date = date.addingTimeInterval(60 * 15)
            dp3t = DP3T(date: date)
        }
        
        XCTAssertEqual(ephIDs.count, 96)
    }
    
    func testSKt() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var date = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: Date())!
        var dp3t = DP3T(date: date)
        
        // Test if SKt is the same at 1:00 AM UTC and 11:00 PM UTC
        let SKt1 = dp3t.getCurrentSKt()
        date = date.addingTimeInterval(60 * 60 * 22)
        dp3t = DP3T(date: date)
        let SKt2 = dp3t.getCurrentSKt()

        XCTAssertEqual(SKt1, SKt2)
        
        // Test if SKt is different at 11:00 PM UTC and 1:00 AM UTC the next day
        date = date.addingTimeInterval(60 * 60 * 2)
        dp3t = DP3T(date: date)
        let SKt3 = dp3t.getCurrentSKt()

        XCTAssertNotEqual(SKt2, SKt3)
    }
    
    func testAllSKts() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        var date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        var dp3t = DP3T(date: date)
        var SKts: Set<String> = []
        
        // Test if all SKts through 100 days are unique
        for _ in 0..<100 {
            SKts.insert(dp3t.getCurrentSKt())
            date = date.addingTimeInterval(60 * 60 * 24)
            dp3t = DP3T(date: date)
        }
        
        XCTAssertEqual(SKts.count, 100)
        
        // Test if last 14 Skts are stored
        XCTAssertEqual(dp3t.getStoredSKts().count, 14)
    }
    
    func testGetStartOfNextDay() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
                
        // Test if the next day is calculated correctly
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        var date = formatter.date(from: "2020-08-16 12:31")!
        var dp3t = DP3T(date: date)
        
        var nextDay = dp3t.getStartOfNextDay()
        var days = calendar.component(.day, from: nextDay)
        var hours = calendar.component(.hour, from: nextDay)
        var minutes = calendar.component(.minute, from: nextDay)
        
        XCTAssertEqual(days, 17)
        XCTAssertEqual(hours, 0)
        XCTAssertEqual(minutes, 0)
        
        date = date.addingTimeInterval(60 * 60 * 24)
        dp3t = DP3T(date: date)
        
        nextDay = dp3t.getStartOfNextDay()
        days = calendar.component(.day, from: nextDay)
        hours = calendar.component(.hour, from: nextDay)
        minutes = calendar.component(.minute, from: nextDay)
        
        XCTAssertEqual(days, 18)
        XCTAssertEqual(hours, 0)
        XCTAssertEqual(minutes, 0)
    }
    
    func testGetNextEpoch() throws {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        // Test if the next epoch is calculated correctly
        var date = calendar.date(bySettingHour: 2, minute: 14, second: 0, of: Date())!
        var dp3t = DP3T(date: date)
        
        var nextEpochDate = dp3t.getNextEpoch()
        var hours = calendar.component(.hour, from: nextEpochDate)
        var minutes = calendar.component(.minute, from: nextEpochDate)
        
        XCTAssertEqual(hours, 2)
        XCTAssertEqual(minutes, 15)
        
        date = calendar.date(bySettingHour: 3, minute: 58, second: 22, of: Date())!
        dp3t = DP3T(date: date)
        
        nextEpochDate = dp3t.getNextEpoch()
        hours = calendar.component(.hour, from: nextEpochDate)
        minutes = calendar.component(.minute, from: nextEpochDate)
        
        XCTAssertEqual(hours, 4)
        XCTAssertEqual(minutes, 0)
        
        date = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: Date())!
        dp3t = DP3T(date: date)
        
        nextEpochDate = dp3t.getNextEpoch()
        hours = calendar.component(.hour, from: nextEpochDate)
        minutes = calendar.component(.minute, from: nextEpochDate)
        
        XCTAssertEqual(hours, 5)
        XCTAssertEqual(minutes, 15)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
