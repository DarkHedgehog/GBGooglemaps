//
//  LoginViewModel.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import Foundation

final class LoginViewModel {
    weak var coordinator: AppCoordinator?

    func signIn(login: String, password: String) -> Bool {
        if let user = RealmService.instance.loginUser(login: login, password: password) {
            ProfileService.instance.isSignedUp = true

            coordinator?.goToMap()
            return true
        }
        return false
    }

    func register(login: String, password: String) {
        if let user = RealmService.instance.getUser(login: login) {
            RealmService.instance.changePassword(user, password: password)
        } else {
            let user = User(login: login, password: password)
            RealmService.instance.saveUser(user)
        }
    }
}
