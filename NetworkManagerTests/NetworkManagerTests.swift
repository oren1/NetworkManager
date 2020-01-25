//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by oren shalev on 21/01/2020.
//  Copyright © 2020 oren shalev. All rights reserved.
//

import XCTest
@testable import NetworkManager

class NetworkManagerTests: XCTestCase {

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRedirectsForURL(urlString: String, maxAmountOfRedirects: Int)  {
       
        let promise = expectation(description: "Amount of redirects are fine")
        var responseError: Error?
        
        
        NetworkManager.options.maxAmountOfRedirects = maxAmountOfRedirects
        NetworkManager.getRequest(urlString: urlString, success: { (responseString) in
            
            promise.fulfill()
        }, failure: { (error) in
            
            responseError = error
            promise.fulfill()

        }) { (number) in
            
        }
        
        wait(for: [promise], timeout: 5)

        
        XCTAssertNil(responseError)
    }
        
    
    
    func testNetworkManager() {
        
        let urlString = "http://www.mocky.io/v2/5e0af46b3300007e1120a7ef"
        testRedirectsForURL(urlString: urlString, maxAmountOfRedirects: 4)
        
        
    }
    

}
