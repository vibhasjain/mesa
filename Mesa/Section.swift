//
//  Category.swift
//  Mesa
//
//  Created by Vibes on 4/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation

class Section {
    
    var name : String
    var items : [Item]
    var identifier : String
    
    init(name : String , items : [Item], identifier : String) {
        
        self.name = name
        self.items = items
        self.identifier = identifier
    }
}
