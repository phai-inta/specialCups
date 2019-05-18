//
//  Annotation.swift
//  task-05p
//
//  Created by Lamphai Intathep on 17/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import MapKit

class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var phone: String?
    
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        super.init()
    }
}
