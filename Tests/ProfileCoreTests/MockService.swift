//
//  MockService.swift
//  ProfileCore
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import ProfileCore

class MockService: ProfileService {
    
    static let shared = MockService()
    
    func guestLogin(email: String, password: String, completeHandler: (Data?, URLResponse?, Error?) -> Void) {
        let bundle = Bundle(identifier: "com.wayne.hsiao.ProfileCoreTests")
        
        guard let path = bundle?.path(forResource: "MockProfile", ofType: "json") else {
                completeHandler(nil, nil, nil)
                return
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            completeHandler(data, nil, nil)
        } catch {
            print(error)
            fatalError("Get mock data failed.")
        }
    }
    
    func guestLogout(email: String) {
        
    }
}
