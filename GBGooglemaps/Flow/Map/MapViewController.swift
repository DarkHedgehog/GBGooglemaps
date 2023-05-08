//
//  ViewController.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 28.03.2023.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var trackActivityButton: UIButton!

    var viewModel: MapViewModel?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var iconMarker: GMSMarker?
    var locationManager = LocationManager.instance
    var isTrackingActive = false

    private let userAsk = UserConfirmation.instance
    private var disposeBag = DisposeBag()

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
        configureAvatarMarker()
    }

    private func configureAvatarMarker() {
        if let markerImage = SelfiePickerController.readAvatar() {
            self.iconMarker?.map = nil
            let marker = GMSMarker()
            let markerView = UIImageView(image: markerImage)
//            marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
            marker.iconView = markerView
//            marker.title = "New Delhi"
//            marker.snippet = "India"
            marker.map = mapView
            mapView.selectedMarker = marker
            iconMarker = marker
        }
    }

    private func configureLocationManager() {
        locationManager.location.subscribe { location in
            guard let coordinate = location?.coordinate else {
                return
            }
            self.routePath?.add(coordinate)
            self.route?.path = self.routePath

            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
            self.mapView.animate(to: camera)
            self.iconMarker?.position = coordinate
        }
        .disposed(by: disposeBag)
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

    @IBAction func didTapSelfie(_ sender: Any) {
        viewModel?.takePicture(for: self) { image in
            if let image = image {
                SelfiePickerController.saveAvatar(image)
            }
            self.configureAvatarMarker()
        }
    }

    func stopTracking(storeCurrent: Bool) {
        isTrackingActive = false
        locationManager.stopUpdatingLocation()
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
        locationManager.startUpdatingLocation()
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
