//
//  ViewController.swift
//  UserLocation
//
//  Created by Apple on 27/10/21.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController{
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    
    @IBOutlet weak var mapView: GMSMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
//        if CLLocationManager.locationServicesEnabled(){
//            locationManager.requestLocation()
//        }else{
//            locationManager.requestWhenInUseAuthorization()
//        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
       print("\(locationManager.location?.coordinate.latitude)")
        print("\(locationManager.location?.coordinate.longitude)")
    }

}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
       
       
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0, zoom: 1.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude:  locationManager.location?.coordinate.longitude ?? 0.0)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager .authorizationStatus{
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func mapView(
        _ mapView: GMSMapView,
        didTapPOIWithPlaceID placeID: String,
        name: String,
        location: CLLocationCoordinate2D
    ) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    }
    
    
}

