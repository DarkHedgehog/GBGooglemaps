//
//  User.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 18.04.2023.
//

import Foundation
import UIKit
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var login: String
    @Persisted var password: String

    override init() {
    }

    required init(login: String, password: String) {
        super.init()
        self.login = login
        self.password = password
    }
}
