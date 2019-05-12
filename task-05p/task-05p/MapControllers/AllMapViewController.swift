//
//  AllMapViewController.swift
//  D task
//
//  Created by Lamphai Intathep on 4/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//
import UIKit
import MapKit

class AllMapViewController: UIViewController {
    
    var cafeDict: [[String: Any]] = []

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMap()
    }
    
    func loadMap() {
        var allPins = [MKPointAnnotation]()
        
        var i = 0
        while i <= cafeDict.count - 1 {
            let cafePin = MKPointAnnotation()
            let latitude = cafeDict[i]["latitude"]
            let longitude = cafeDict[i]["longitude"]
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! CLLocationDegrees, longitude as! CLLocationDegrees)
            cafePin.coordinate = location
            cafePin.title = cafeDict[i]["name"] as? String
            allPins.append(cafePin)
            i += 1
        }
        mapView.addAnnotations(allPins)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}

// MARK: - Add the callout buble
extension AllMapViewController: MKMapViewDelegate {
    
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
