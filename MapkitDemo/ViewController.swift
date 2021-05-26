//
//  ViewController.swift
//  MapkitDemo
//
//  Created by Anu Agrawal on 5/26/21.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
   var locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        showLocationSearchTable()
    }
    
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func showLocationSearchTable(){
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        setupSearchBar()
    }
    
    func setupSearchBar(){
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
       // resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    
    
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//                locationManager.requestLocation()
//            }
//        if status == .restricted{
//            let alert = UIAlertController(title: "", message: "Please allow app to access your location ", preferredStyle: .alert)
//            alert.present(self, animated: true, completion: nil)
//        }
//
//        }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            if let location = locations.first {
//                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                let region = MKCoordinateRegion(center: location.coordinate, span: span)
//                mapView.setRegion(region, animated: true)
//            }
//        }
//
//    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//            print("error:: (error)")
//        }

}

extension ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}


extension ViewController{

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }

    }
}
