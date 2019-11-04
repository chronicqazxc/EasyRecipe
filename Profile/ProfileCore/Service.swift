//
//  Service.swift
//  ProfileCore
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import WHCoreServices

/// Any services which injected into AuthenticationService should be adopt the ProfileService protocol.
public protocol ProfileService {
    
    /// Login user.
    /// - Parameter email: User email
    /// - Parameter password: User password
    /// - Parameter completeHandler: Will called once tha request complete, you can determine the request result by either data is not nil or Profile.current is not nil.
    func guestLogin(email: String, password: String, completeHandler: NetworkCompletionHandler)
    
    /// Logout a user with specific identifier.
    /// - Parameter email: User email
    func guestLogout(email: String)
}

extension Service: ProfileService {
    public func guestLogin(email: String, password: String, completeHandler: NetworkCompletionHandler) {
        // TODO: Real service
        fatalError("To be implemented with real service.")
    }
    
    public func guestLogout(email: String) {
        // TODO: Real service
        fatalError("To be implemented with real service.")
    }
}
