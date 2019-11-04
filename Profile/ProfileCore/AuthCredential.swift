//
//  AuthCredential.swift
//  ProfileCore
//
//  Created by Hsiao, Wayne on 2019/10/4.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import WHCoreServices

public class AuthCredential: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case email
        case accessToken
        case refreshToken
    }
    
    public init(firstName: String,
                lastName: String,
                email: String,
                accessToken: String,
                refreshToken: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(firstName, forKey: .firstName)
//        try container.encode(lastName, forKey: .lastName)
//        try container.encode(email, forKey: .email)
//        try container.encode(accessToken, forKey: .accessToken)
//        try container.encode(refreshToken, forKey: .refreshToken)
//    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }
}
