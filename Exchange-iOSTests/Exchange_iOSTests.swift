//
//  Exchange_iOSTests.swift
//  Exchange-iOSTests
//
//  Created by Kristopher Jackson on 4/18/22.
//

import XCTest
@testable import Exchange_iOS

class Exchange_iOSTests: XCTestCase {

    func testUsernameValid() throws {
        let notValid1 = "not"
        let notValid2 = "KrisRJack&)("
        let notValid3 = "asjkhfkhsdfhadsljhfalsdjhfalsdhflajhsdjflhasdjhfajklshdfhasjldkfha"
        let valid = "KrisRJack"
        
        let service1 = UsernameService(username: notValid1)
        XCTAssertFalse(service1.isValid)
        
        let service2 = UsernameService(username: notValid2)
        XCTAssertFalse(service2.isValid)
        
        let service3 = UsernameService(username: notValid3)
        XCTAssertFalse(service3.isValid)
        
        let service4 = UsernameService(username: valid)
        XCTAssertTrue(service4.isValid)
    }

}
