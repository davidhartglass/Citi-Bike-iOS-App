//
//  Citi_Bike_LocatorTests.swift
//  Citi Bike LocatorTests
//
//  Created by David Hartglass on 4/20/18.
//  Copyright © 2018 David Hartglass. All rights reserved.
//

import XCTest
@testable import Citi_Bike_Locator_Final

class Citi_Bike_LocatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        var myModel = CitiBikeCollection()
        let theURL = myModel.createURL()
        myModel.bikeFromURL(myURL: theURL!)
        
        let recentBikes = myModel.getRecent()
        
        XCTAssert(myModel.currentBikes.count == 0, "test failed on line " + String(#line))
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

