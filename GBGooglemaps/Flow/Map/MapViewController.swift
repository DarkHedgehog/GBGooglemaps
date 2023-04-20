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

    var viewModel: MapViewModel?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager: CLLocationManager?
    var isTrackingActive = false

    private let userAsk = UserConfirmation.instance

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
        if isTrackingActive {
            userAsk.basicConfirm(presenter: self, title: "Warning", message: "Stop active tracking?") { confirm in
                if confirm == .okay {
                    self.stopTracking(storeCurrent: false)
                    self.showStoredTrack()
                }
            }
        } else {
            showStoredTrack()
        }
    }

    @IBAction func toggleTracking(_ sender: Any) {
        if !isTrackingActive {
            startTracking()
        } else {
            stopTracking(storeCurrent: true)
        }
        updateTrackActivityButton()
    }

    @IBAction func didTapLogout(_ sender: Any) {
        if isTrackingActive {
            userAsk.basicConfirm(presenter: self, title: "Warning", message: "Stop active tracking?") { confirm in
                if confirm == .okay {
                    self.stopTracking(storeCurrent: false)
                    self.viewModel?.logout()
                }
            }
        } else {
            viewModel?.logout()
        }
    }

    func stopTracking(storeCurrent: Bool) {
        isTrackingActive = false
        locationManager?.stopUpdatingLocation()
        if storeCurrent, let path = routePath {
            let trackToStore = Track.buildFrom(gmsPath: path)
            RealmService.instance.storeRoute(trackToStore)
        }
    }

    func startTracking() {
        isTrackingActive = true
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }

    func showStoredTrack() {
        if let lastTrack = RealmService.instance.getLastRoute() {
            let lastRoutePath = Track.toRoutePath(lastTrack)
            let newRoute = GMSPolyline()
            route?.map = nil
            newRoute.map = mapView
            newRoute.path = lastRoutePath

            let bounds = GMSCoordinateBounds(path: lastRoutePath)
            let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            if let camera = mapView.camera(for: bounds, insets: insets) {
                mapView.animate(to: camera)
            }

            routePath = lastRoutePath
            route = newRoute
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
