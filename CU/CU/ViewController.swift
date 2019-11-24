//
//  ViewController.swift
//  CU
//
//  Created by 2020-1 on 11/20/19.
//  Copyright © 2019 Enrique García. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var selector: UISegmentedControl!
    
    var currentPlacemark: CLPlacemark?
    let center = CLLocation(latitude: 19.323712, longitude: -99.184343)
    
    override func viewDidLoad() {        super.viewDidLoad()
        // Do any additional setup after loading the view.
        map.delegate = self
        zoom(location: center)
        checkLocationServiceAuthenticationStatus()
        map.showsUserLocation = true
        for location in locations{
            let anotacion = MKPointAnnotation()
            anotacion.title = location.name
            anotacion.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            map.addAnnotation(anotacion)
            }
    }

    var locationManager = CLLocationManager()
    func checkLocationServiceAuthenticationStatus()
    {
        locationManager.delegate = self as? CLLocationManagerDelegate
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func changeType(_ sender: Any) {
        switch selector.selectedSegmentIndex {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .hybrid
        default:
            break
        }
    }
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let location = view.annotation as? MKPointAnnotation{
            self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
        }
    }
    
    
    @IBAction func drawRoute(_ sender: Any) {
        let destinationPlaceMark = currentPlacemark
        
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark as! MKPlacemark)
        
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let directionResponse = response else{
                return
            }
            
            let route = directionResponse.routes.first
            self.map.removeOverlays(self.map.overlays)
            self.map.addOverlay(route!.polyline)
            
            let rect = route?.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rect!), animated: true)
        }
    }
    
    
    @IBAction func clear(_ sender: Any) {
        self.map.removeOverlays(self.map.overlays)
            zoom(location: center)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let line = MKPolylineRenderer(overlay: overlay)
        line.strokeColor = .blue
        line.lineWidth = 4.0
        return line
    }
    
    let region: CLLocationDistance = 1500
    func zoom(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion (center: location.coordinate,latitudinalMeters: region * 2.0, longitudinalMeters: region * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    
}

