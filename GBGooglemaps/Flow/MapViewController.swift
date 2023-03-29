//
//  ViewController.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 28.03.2023.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!

    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        configureLocationManager()
    }


    private func configureMap() {
        mapView.isMyLocationEnabled = true
    }

    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }

    @IBAction func goToMoskow(_ sender: Any) {
        let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
    }

    @IBAction func makeMarker(_ sender: Any) {
        locationManager?.requestLocation()
        locationManager?.startUpdatingLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.animate(to: camera)
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView

        print(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}

