//
//  Environment.swift
//  AlliedTask
//
//  Created by Adel Aref on 12/11/2021.
//

import Foundation

public enum Environment {
    // MARK: - Keys
        enum PlistKeys {
            static let baseURL = "Base_URL"
            static let registrationURL = "Registration_URL"
            static let accountURL = "Account_URL"
            static let organizationID = "OrganizationID"
            static let appID = "AppID"
        }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let baseURL: String = {
        guard let baseURLstring = Environment.infoDictionary[PlistKeys.baseURL] as? String else {
            fatalError("base URL not set in plist for this environment")
        }
        guard let url = URL(string: baseURLstring) else {
            fatalError("Base URL is invalid")
        }
        return baseURLstring
    }()

    static let registrationURL: String = {
        guard let registrationURLstring = Environment.infoDictionary[PlistKeys.registrationURL] as? String else {
            fatalError("registration URL not set in plist for this environment")
        }
        guard let url = URL(string: registrationURLstring) else {
            fatalError("Registration URL is invalid")
        }
        return registrationURLstring
    }()

    static let accountURL: String = {
        guard let accountURLstring = Environment.infoDictionary[PlistKeys.accountURL] as? String else {
            fatalError("account URL not set in plist for this environment")
        }
        guard let url = URL(string: accountURLstring) else {
            fatalError("Account URL is invalid")
        }
        return accountURLstring
    }()

    static let organizationID: String = {
        guard let organizationID = Environment.infoDictionary[PlistKeys.organizationID] as? String else {
            fatalError("organization ID not set in plist for this environment")
        }
        return organizationID
    }()

    static let appID: String = {
        guard let appID = Environment.infoDictionary[PlistKeys.appID] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return appID
    }()
}
