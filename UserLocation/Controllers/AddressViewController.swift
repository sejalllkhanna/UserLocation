//
//  AddressViewController.swift
//  UserLocation
//
//  Created by Apple on 29/10/21.
//

import UIKit
import GoogleMaps
import CoreLocation

class AddressViewController: UIViewController {
    
    @IBOutlet weak var StreetLabel: UITextField!
    @IBOutlet weak var CityLabel: UITextField!
    @IBOutlet weak var CountryLabel: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var geoCodingButton: UIButton!
    @IBAction func geocode(_ sender: Any) {
        guard let country = CountryLabel.text else { return }
        guard let street = StreetLabel.text else { return }
        guard let city = CityLabel.text else { return }
        
        let address = "\(country), \(city), \(street)"
        lazy var geocoder = CLGeocoder()
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
        // Update View
        geoCodingButton.isHidden = true
        activityIndicatorView.startAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        geoCodingButton.isHidden = false
        activityIndicatorView.stopAnimating()
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            locationLabel.text = "Unable to Find Location for Address"
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                locationLabel.text = "\(coordinate.latitude), \(coordinate.longitude)"
            } else {
                locationLabel.text = "No Matching Location Found"
            }
        }
    }
}
