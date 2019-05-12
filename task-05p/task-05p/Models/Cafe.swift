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
    let latitude: Double
    let longitude: Double
    var isFavourite : Bool
    
    init(name:String, rating:Double, location:String, suburb:String, phone:String, special:String, latitude: Double, longitude: Double, isFavourite:Bool) {
        self.name = name
        self.rating = rating
        self.location = location
        self.suburb = suburb
        self.phone = phone
        self.special = special
        self.latitude = latitude
        self.longitude = longitude
        self.isFavourite = isFavourite
        super.init()
    }
}

//class Coordinate: NSObject, Codable {
//    let longitude: Double
//    let latitude: Double
//
//    init( longitude: Double, latitude: Double) {
//        self.longitude = longitude
//        self.latitude = latitude
//        super.init()
//        
//    }
//}
