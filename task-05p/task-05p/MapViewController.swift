//
//  MapViewController.swift
//  task-07
//
//  Created by Lamphai Intathep on 28/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var testTextField: UITextField!
    
    let regionRadius: CLLocationDistance = 1000
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var name: String = ""
    var address: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // MARK: - Center map
        let coordinate = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(location: coordinate)
        
        // MARK: - Add pin
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let cafePin = MKPointAnnotation()

        cafePin.coordinate = location
        cafePin.title = name
        cafePin.subtitle = address
        mapView.addAnnotation(cafePin)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - Add the callout buble
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

