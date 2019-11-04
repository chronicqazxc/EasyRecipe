//
//  AuthenticationServiceTests.swift
//  ProfileCoreTests
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import XCTest
@testable import ProfileCore

class AuthenticationServiceTests: XCTestCase {
    
    enum Constant {
        static let username = "iostest@wayne.com"
        static let password = "waynehsiao"
    }
    
    var expectation: XCTestExpectation!
    let authenticationService = AuthenticationService(service: MockService.shared)

    override func setUp() {
        expectation = expectation(description: "SomeService does stuff and runs the callback closure")
    }

    override func tearDown() {
        authenticationService.guestLogout {_,_ in
            
        }
    }

    func testGuestLogin() {
        authenticationService.guestLogin(email: Constant.username,
                                         password: Constant.password) { (_, _) in
                                            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { error in
            
            let profile = self.authenticationService.currentProfile
            
            XCTAssertNotNil(profile)
            XCTAssertEqual(Constant.username, profile?.email)
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGuestLogout() {
        authenticationService.guestLogin(email: Constant.username,
                                         password: Constant.password) { [unowned self] (_, _) in
                                            
                                            let profile = self.authenticationService.currentProfile
                                            XCTAssertNotNil(profile)
                                            
                                            self.authenticationService.guestLogout { [unowned self] _,_ in
                                                self.expectation.fulfill()
                                            }
        }
        
        waitForExpectations(timeout: 5.0) { error in
            
            let profile = self.authenticationService.currentProfile
            XCTAssertNil(profile)
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
