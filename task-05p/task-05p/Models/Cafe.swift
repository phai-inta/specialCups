//
//  Cafe.swift
//  task-05p
//
//  Created by Lamphai Intathep on 12/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import Foundation

class Cafe : NSObject, Codable {
    var name : String
    var rating : Double
    var location : String
    var suburb : String
    var phone : String
    var special : String
    
    init (name:String, rating:Double, location:String, suburb:String, phone:String, special:String) {
        self.name = name
        self.rating = rating
        self.location = location
        self.suburb = suburb
        self.phone = phone
        self.special = special
        super.init()
    }
}
