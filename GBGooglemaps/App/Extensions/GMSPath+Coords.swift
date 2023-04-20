//
//  GMSPath+Coords.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 15.04.2023.
//

import Foundation
import CoreData
import GoogleMaps

extension GMSPath {
    var coordinates: [CLLocationCoordinate2D] {
        var coords: [CLLocationCoordinate2D] = []
        for idx in 0..<self.count() {
            coords.append(self.coordinate(at: idx))
        }
        return coords
    }
}
