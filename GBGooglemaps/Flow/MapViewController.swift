//
//  ViewController.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 28.03.2023.
//

import UIKit
import CoreData
import GoogleMaps

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var trackActivityButton: UIButton!

    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager: CLLocationManager?
    var isTrackingActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureMap()
        configureLocationManager()
    }

    private func configureUI() {
        updateTrackActivityButton()
    }

    private func updateTrackActivityButton() {
        let title = isTrackingActive ? "Stop tracking" : "Start tracking"
        trackActivityButton.setTitle(title, for: .normal)
    }

    private func configureMap() {
        mapView.isMyLocationEnabled = true
    }

    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
    }

    @IBAction func showLastTrack(_ sender: Any) {
        if let lastTrack = RealmService.instance.getLastRoute() {
            let lastRoutePath = Track.toRoutePath(lastTrack)
            let newRoute = GMSPolyline()
            route?.map = nil
            newRoute.map = mapView
            newRoute.path = lastRoutePath

            let bounds = GMSCoordinateBounds(path: lastRoutePath)
            if let camera = mapView.camera(for: bounds, insets: .zero) {
                mapView.animate(to: camera)
            }

            routePath = lastRoutePath
            route = newRoute
        }
    }

    @IBAction func toggleTracking(_ sender: Any) {
        isTrackingActive.toggle()
        updateTrackActivityButton()

        if isTrackingActive {
            route?.map = nil
            route = GMSPolyline()
            routePath = GMSMutablePath()
            route?.map = mapView
            locationManager?.startUpdatingLocation()
        } else {
            locationManager?.stopUpdatingLocation()
            if let path = routePath {
                let trackToStore = Track.buildFrom(gmsPath: path)
                RealmService.instance.storeRoute(trackToStore)
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        routePath?.add(coordinate)
        route?.path = routePath

        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
