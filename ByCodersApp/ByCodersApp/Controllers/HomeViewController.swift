//
//  HomeViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit
import MapKit
//import CoreLocation

final class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, Storyboarded {
    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    private var viewModel: HomeViewModelProtocol?
    
    init(viewModel: HomeViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLocation()
        viewModel?.saveUserLocation(
            latitude: locationManager.location?.coordinate.latitude,
            longitude: locationManager.location?.coordinate.longitude)
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
