//
//  Item.swift
//  Mesa
//
//  Created by Vibes on 4/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation

class Item {
    
    var id : String
    var name : String
    var imageURL : URL
    var details : String
    var price : Double
    var available : Bool
    var thumbURL : URL
    
    init(id: String, name : String, imageURL : URL, details : String, price: Double, available : Bool, thumbURL : URL) {
        
        self.name = name
        self.imageURL = imageURL
        self.details = details
        self.price = price
        self.available = available
        self.id = id
        self.thumbURL = thumbURL
    }
    
}
