//
//  RealmService.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 13.04.2023.
//

import UIKit
import RealmSwift

final class RealmService {
    private let realm: Realm?

    static let instance = RealmService()
    private init () {
        do {
            var configuration = Realm.Configuration.defaultConfiguration
            configuration.deleteRealmIfMigrationNeeded = true
            realm = try Realm(configuration: configuration)
        } catch {
            realm = nil
            debugPrint(error)
            return
        }
        print(realm?.configuration.fileURL ?? "fileURL is empty")
    }

    func storeRoute(_ track: Track) {
        guard let realm = realm else {
            return
        }

        do {
            try realm.write {
                realm.add(track, update: .all)
            }
        } catch {
            print(error)
        }
    }

    func getLastRoute() -> Track? {
        guard let realm = realm else {
            return nil
        }

        let track = realm.object(ofType: Track.self, forPrimaryKey: Track().id)
        return track
    }

    func loginUser(login: String, password: String) -> User? {
        guard let realm = realm else {
            return nil
        }

        let user = realm.objects(User.self).where{ $0.password == password && $0.login == login }.first
        return user
    }

    func getUser(login: String) -> User? {
        guard let realm = realm else {
            return nil
        }

        let user = realm.object(ofType: User.self, forPrimaryKey: login)
        return user
    }

    func saveUser(_ user: User) {
        guard let realm = realm else {
            return
        }

        do {
            try realm.write {
                realm.add(user, update: .all)
            }
        } catch {
            print(error)
        }
    }

    func changePassword(_ user: User, password: String) {
        guard let realm = realm else {
            return
        }

        do {
            try realm.write {
                user.password = password
                realm.add(user, update: .all)
            }
        } catch {
            print(error)
        }
    }
}
