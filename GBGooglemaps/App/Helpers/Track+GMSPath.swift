//
//  Track+build.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 15.04.2023.
//

import Foundation
import CoreData
import GoogleMaps

extension Track {
    static func buildFrom(gmsPath: GMSPath) -> Track {
        let track = Track()
        let coords = gmsPath.coordinates
        for index in 0..<coords.count {
            let coord = coords[index]
            let trackCoord = TrackCoord(index: index, latitude: coord.latitude, longitude: coord.longitude)
            track.coords.append(trackCoord)
        }
        return track
    }

    static func toRoutePath(_ track: Track) -> GMSMutablePath {
        let path = GMSMutablePath()
        track.coords.forEach({
            let coordinate = CLLocationCoordinate2D(
                latitude: $0.latitude,
                longitude: $0.longitude
            )
            path.add(coordinate)
        })
        return path;
    }
}
