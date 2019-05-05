//
//  Actor.swift
//  task-05p
//
//  Created by Lamphai Intathep on 7/4/19.
//  Copyright © 2019 Lamphai Intathep. All rights reserved.
//

import Foundation

class Actor : NSObject, Codable {
    var firstName : String
    var lastName: String
    var yob: Int


init (firstName:String, lastName:String, yob:Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.yob = yob
    super.init()
    }
}

