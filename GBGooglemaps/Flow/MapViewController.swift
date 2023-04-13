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

    @IBAction func goToMoskow(_ sender: Any) {
        let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
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
        }

    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
//        let marker = GMSMarker(position: coordinate)
//        marker.map = mapView
        routePath?.add(coordinate)
        route?.path = routePath

        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}

