//
//  HomeViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit
import MapKit
import CoreLocation

final class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    private let sqliteService = SQLiteService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLocation()
        saveUserLocation()
    }
    
    private func configLocation() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func saveUserLocation() {
        sqliteService.dropTables()
        sqliteService.initTables()
        guard let lat = locationManager.location?.coordinate.latitude,
              let long = locationManager.location?.coordinate.longitude,
              let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        let userLocation = UserLocation(uid: uid, latitude: String(lat), longitude: String(long))
        _ = sqliteService.createUserLocation(userLocation: userLocation)
    }

    
    // MARK: - Location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }

        if currentLocation == nil {
            
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }

}
