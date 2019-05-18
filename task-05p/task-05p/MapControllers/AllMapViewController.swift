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
    var selectedAnnotation: MKPointAnnotation?
   // var cafeToSend = Cafe

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
//            let cafePin = Annotation(coordinate: CLLocationCoordinate2D(latitude: cafeDict[i]["latitude"] as! CLLocationDegrees, longitude: cafeDict[i]["longitude"] as! CLLocationDegrees))
            let latitude = cafeDict[i]["latitude"]
            let longitude = cafeDict[i]["longitude"]
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude as! CLLocationDegrees, longitude as! CLLocationDegrees)
            cafePin.coordinate = location
            cafePin.title = cafeDict[i]["name"] as? String
            cafePin.subtitle = cafeDict[i]["location"] as? String
            //cafePin.phone = cafeDict[i]["phone"] as? String
            allPins.append(cafePin)
            i += 1
        }
        mapView.addAnnotations(allPins)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let name = view.annotation?.title as Any
            let location = view.annotation?.subtitle as Any
            let latitude = view.annotation?.coordinate.latitude
            let longitude = view.annotation?.coordinate.longitude
            let cafeToSend = Cafe(name: name as! String, rating: 0.0, location: location as! String, suburb: "", phone: "n/a", latitude: latitude!, longitude: longitude!, isFavourite: false)
            let vc = storyboard?.instantiateViewController(withIdentifier: "showSelectedCafe") as? CafeDetailsViewController
            vc!.selectedCafe = cafeToSend
            navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
//    func configureCalloutView(view: MKAnnotationView) {
//        //let width = 300
//        //let height = 200
//        let snapshotView = UIView()
//        let views = ["snapshoView": snapshotView]
//        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(300)]", options: [], metrics: nil, views: views))
//        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(200)]", options: [], metrics: nil, views: views))
//        view.detailCalloutAccessoryView = snapshotView
//    }
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
            let image = UIButton(type: .detailDisclosure)
            image.setImage(UIImage(named: "coffeecup"), for: .normal)
            image.tintColor = UIColor.black
            view.rightCalloutAccessoryView = image
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
