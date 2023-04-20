//
//  Track.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 15.04.2023.
//

import Foundation
import UIKit
import RealmSwift

class TrackCoord: Object {
    @Persisted var index: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double

    override init() {
        super.init()
    }

    required init(index: Int, latitude: Double, longitude: Double) {
        super.init()
        self.index = index
        self.latitude = latitude
        self.longitude = longitude
    }
}

class Track: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var createdAt: Date
    @Persisted var coords: List<TrackCoord>

    override init() {
        super.init()
        createdAt = Date()
        coords = List<TrackCoord>()
    }
}
