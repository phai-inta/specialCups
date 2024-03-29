//
//  OnlineCafe.swift
//  task-05p
//
//  Created by Lamphai Intathep on 10/5/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import Foundation

class OnlineCafe: NSObject {
    let name: String
    let rating: Double
    let latitude: Double
    let longitude: Double
    let location: String
    let suburb: String
    var phone : String
    var isFavourite : Bool
    let image: String
    
    init(name: String, rating: Double, latitude: Double, longitude: Double, location: String, suburb: String, phone: String, isFavourite: Bool, image: String) {
        self.name = name
        self.rating = rating
        self.latitude = latitude
        self.longitude = longitude
        self.suburb = suburb
        self.location = location
        self.phone = phone
        self.isFavourite = isFavourite
        self.image = image
    }
}
