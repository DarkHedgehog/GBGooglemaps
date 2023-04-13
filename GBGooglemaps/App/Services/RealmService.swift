//
//  RealmService.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 13.04.2023.
//

import UIKit
import RealmSwift

class RealmService {

    static let instance = RealmService()
    private init(){}

    static var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

    func saveItems<Element: Object>(items: [Element], needMigrate: Bool = false, needUpdate: Bool = true) -> Realm? {

        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: needMigrate)
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.add(items, update: needUpdate)
            }
            return realm
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func getItems<T: Object>(_ type: T.Type, in realm: Realm? = try? Realm(configuration: RealmService.configuration)) -> Results<T>? {
        return realm?.objects(type)
    }


    func removeItem<T: Object>(_ item: T, in realm: Realm? = try? Realm(configuration: RealmService.configuration)) {
        if let realm = realm {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
