//
//  SumARTests.swift
//  SumARTests
//
//  Created by OliverPérez on 1/4/19.
//  Copyright © 2019 OliverPérez. All rights reserved.
//

import XCTest
@testable import SumAR

class SumARTests: XCTestCase {

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadDataInLevels() {
    
     let level = LevelManager.shared.randomSum(0)

     XCTAssertEqual(LevelManager.shared.levels.count, 10)
     XCTAssertLessThan(level.maxNum, 10)
     XCTAssertGreaterThan(level.minNum, 0)
     XCTAssertEqual(level.goal, 10)
        
    }
    
    func testRandomNumbersForRingsValues() {
        let randomNumber = LevelManager.shared.getRandomNumbers(minRange: 1, maxRange: 10)
        XCTAssertLessThan(randomNumber, 11)
        XCTAssertGreaterThan(randomNumber, 0)
    }
    
    
    func testRandomNumbersForRingsGoal() {
        let randomNumber = LevelManager.shared.getRandomNumbers(minRange: 0, maxRange: 2)
        XCTAssertLessThan(randomNumber, 3)
        XCTAssertGreaterThan(randomNumber, -1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    


}
