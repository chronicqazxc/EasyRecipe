//
//  Profile.swift
//  ProfileCore
//
//  Created by Hsiao, Wayne on 2019/10/5.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

public struct Profile {
    public let firstName: String
    public let lastName: String
    public let email: String
    
    static public var current: Profile?
    static public var isLoggedIn: Bool {
        return current != nil
    }
    
    public init(firstName: String,
                lastName: String,
                email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
