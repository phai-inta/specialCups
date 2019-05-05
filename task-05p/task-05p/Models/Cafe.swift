//
//  Cafe.swift
//  task-05p
//
//  Created by Lamphai Intathep on 12/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import Foundation
//import Foundation

class Cafe : NSObject, Codable {
    let name : String
    let rating : Double
    let location : String
    let suburb : String
    let phone : String
    let special : String
    let coordinate : Coordinate
    
    init(name:String, rating:Double, location:String, suburb:String, phone:String, special:String, coordinate: Coordinate) {
        self.name = name
        self.rating = rating
        self.location = location
        self.suburb = suburb
        self.phone = phone
        self.special = special
        self.coordinate = coordinate
        super.init()
    }
}

class Coordinate: NSObject, Codable {
    let longitude: Double
    let latitude: Double

    init( longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        super.init()
        
    }
}
