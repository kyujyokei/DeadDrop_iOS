//
//  MainTableViewController.swift
//  DeadDrop
//
//  Created by Kero on 2017/10/10.
//  Copyright © 2017年 Kei. All rights reserved.
//

import XCTest
@testable import DeadDrop //copy this manually

class MainTableViewController: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTableViewCellForRowAtReturnsTableCell() {

    }
    
    func testPerformanceExample() { // If you want to measure performance (time)
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        
//        //        if indexPath.row == 1 {
//        //            cell.textLabel?.text = "1"
//        //        } else if indexPath.row == 2 {
//        //            cell.textLabel?.text = "2"
//        //        } else {
//        //            cell.textLabel?.text = "3"
//        //        }
//        cell.textLabel?.text = "3"
//        
//        return cell
//    }

    
}
