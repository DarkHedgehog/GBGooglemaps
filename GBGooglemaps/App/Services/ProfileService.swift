//
//  ProfileService.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import Foundation

final class ProfileService {
    static let instance = ProfileService()

    var isSignedUp: Bool {
        get {
            return _isSignedUp
        }
        set (newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "isSignedUp")
        }
    }

    private var _isSignedUp: Bool

    private init () {
        _isSignedUp = UserDefaults.standard.bool(forKey: "isSignedUp")
    }
}
