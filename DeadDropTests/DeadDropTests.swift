//
//  DeadDropTests.swift
//  DeadDropTests
//
//  Created by Kero on 2017/10/1.
//  Copyright © 2017年 Kei. All rights reserved.
//

import XCTest
import UIKit
import Foundation
@testable import DeadDrop

class DeadDropTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DropManager.clearAll()
        if(DropManager.drops.count != 3){
            DropManager.init()
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        DropManager.clearAll()
        DropManager.drops = []
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddDrop(){
        
        let testDrop = Drop.init(lat: 23.02, long: 33.22222, message: "Hello")
        
        DropManager.add(drop: testDrop)
        
        XCTAssertEqual(DropManager.drops.count, 4)
    }
    
    func testAddDropVerifyDetails(){
        let testDrop = Drop.init(lat: 1.11, long: 2.22, message: "Test")
        
        DropManager.add(drop: testDrop)
        
        let lastDrop = DropManager.drops[DropManager.drops.count-1] // get the last drop
        
        XCTAssertEqual(lastDrop.latitude, 1.11)
        XCTAssertEqual(lastDrop.longtitude, 2.22)
        XCTAssertEqual(lastDrop.message, "Test")
    }
    
    func testDeleteDrop(){
        DropManager.delete(index: DropManager.drops.count-1)
        
        XCTAssertEqual(DropManager.drops.count, 2)
    }
    
    func testCellForRowAt(){
        DropManager.init()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! MainViewController
        XCTAssertNotNil(vc.view, "Problems initializing view")
        let cell = vc.tableView(vc.tableView, cellForRowAt:IndexPath(row:0,section:0)) as! MainTableViewCell
        XCTAssertEqual(cell.textLabel?.text, nil)
    }
    
    func testGetData(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! MainViewController
//        getData(latitude: 1.1, longitude: 2.2)
    
        XCTAssertEqual(DropManager.drops.count, 3)
    }
    
    
    
    
    
    
}
