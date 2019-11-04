//
//  MockService.swift
//  EasyRecipeDemo
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import ProfileCore
import EasyRecipeCore

enum MockServiceError: Error {
    case loginFaild
    case mockResourceNotFound
}

public class MockService: ProfileService & RecipeService {

    public static let shared = MockService()
    
    let bundle = Bundle(identifier: "com.wayne.hsiao.EasyRecipeDemo")
    
    public func guestLogin(email: String, password: String, completeHandler: (Data?, URLResponse?, Error?) -> Void) {
        
        guard let path = bundle?.path(forResource: "MockProfile", ofType: "json") else {
            completeHandler(nil, nil, MockServiceError.mockResourceNotFound)
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
    
    public func guestLogout(email: String) {
        
    }
    
    public func getRecipes(completeHandler: (Data?, URLResponse?, Error?) -> Void) {
        guard let path = bundle?.path(forResource: "recipes", ofType: "json") else {
            completeHandler(nil, nil, MockServiceError.mockResourceNotFound)
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
}
