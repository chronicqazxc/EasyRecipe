//
//  AuthenticationService.swift
//  ProfileCore
//
//  Created by Hsiao, Wayne on 2019/10/4.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation
import MyService

enum AuthenticationError: Error {
    case loginFailed
    case dataParseError
    case notLoggedIn
    
    var localizedDescription: String {
        switch self {
        case .loginFailed:
            return "loginFailed"
        case .dataParseError:
            return "dataParseError"
        case .notLoggedIn:
            return "notLoggedIn"
        }
    }
}

extension AuthenticationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .loginFailed:
            return NSLocalizedString("LoginFailed", comment: "")
        case .dataParseError:
            return NSLocalizedString("DataParseError", comment: "")
        case .notLoggedIn:
            return NSLocalizedString("NotLoggedIn", comment: "")
        }
    }
}

public typealias GuestLoginCompleteHandler = (Profile?, Error?) -> Void
public typealias GuestLogoutCompleteHandler = (Profile?, Error?) -> Void

extension Notification.Name {
    static let didLoggedIn = Notification.Name("didLoggedIn")
    static let didLoggedOut = Notification.Name("didLoggedOut")
}

public class AuthenticationService {
    
    static public private(set) var shared = AuthenticationService(service: Service.shared)
    
    private(set) var currentProfile: Profile?
    let service: ProfileService
    
    public init(service: ProfileService) {
        self.service = service
    }
    
    /// Login an user, the Profile.current will contained user information after login successed.
    /// The AuthCredential which contained refreshToken as well as accesstoken will be stored in the Keychain with user identifier.
    public func guestLogin(email: String, password: String, completeHandler: GuestLoginCompleteHandler) {
        service.guestLogin(email: email, password: password) { (data, response, error) in
            guard let someData = data else {
                completeHandler(nil, AuthenticationError.loginFailed)
                return
            }
            
            do {
                let credential = try JSONDecoder().decode(AuthCredential.self, from: someData)
                do {
                    try AuthenticationService.store(credential: credential, identifier: credential.email)
                    currentProfile = AuthenticationService.profileFrom(credential)
                    completeHandler(currentProfile, error)
                    NotificationCenter.default.post(name: Notification.Name.didLoggedIn,
                                                    object: ["Profile": currentProfile])
                    Profile.current = currentProfile
                } catch {
                    completeHandler(nil, error)
                }
                
            } catch {
                completeHandler(nil, AuthenticationError.dataParseError)
            }
        }
    }
    
    
    /// Logout an user, the Profile.current will be nil after logout successed and the credential will be removed from the keychain.
    /// - Parameter completeHandler: Callback to inform the caller the task was completed with the completion status.
    public func guestLogout(completeHandler: GuestLogoutCompleteHandler? = nil) {

        guard let profile = currentProfile else {
            completeHandler?(nil, AuthenticationError.notLoggedIn)
            return
        }
        service.guestLogout(email: profile.email)
        do {
            try AuthenticationService.delete(for: profile.email)
            currentProfile = nil
            completeHandler?(profile, nil)
            NotificationCenter.default.post(name: Notification.Name.didLoggedOut,
                                            object: ["Profile": profile])
            Profile.current = nil
        } catch {
            completeHandler?(nil, error)
        }
    }
    
    static func profileFrom(_ credential: AuthCredential) -> Profile {
        let profile = Profile(firstName: credential.firstName,
                              lastName: credential.lastName,
                              email: credential.email)
        return profile
    }
}

extension AuthenticationService {
    static fileprivate var keychainWrapper: KeychainWrapper = {
        let archive = ArchiveQueryable(service: "com.wayne.hsiao.ProfileCore")
        return KeychainWrapper(queryable: archive)
    }()
    
    static func store(credential: AuthCredential, identifier: String) throws {
        do {
            let encode = try PropertyListEncoder().encode(credential)
            let data = try NSKeyedArchiver.archivedData(withRootObject: encode, requiringSecureCoding: false)
            try keychainWrapper.setData(data, forAccount: identifier)
        } catch {
            throw(error)
        }
    }
    
    static func retrieve(for identifier: String) throws -> AuthCredential? {
        do {
            guard let data = try keychainWrapper.getData(for: identifier),
            let archived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data else {
                return nil
            }
            let credential = try PropertyListDecoder().decode(AuthCredential.self, from: archived)
            return credential
        } catch {
            throw(error)
        }
    }
    
    static func delete(for identifier: String) throws {
        do {
            try keychainWrapper.removeValue(for: identifier)
        } catch {
            throw(error)
        }
    }
}
