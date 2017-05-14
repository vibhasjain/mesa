//
//  Category.swift
//  Mesa
//
//  Created by Vibes on 4/28/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var name : String
    var count : Int
    var width : CGFloat
    var centerX : CGFloat
    var startX : Int
    var endX : Int
    
    init(name : String, count : Int, width : CGFloat, centerX : CGFloat, startX : Int, endX : Int) {
        
        self.name = name
        self.count = count
        self.width = width
        self.centerX = centerX
        self.startX = startX
        self.endX = endX
        
    }
    
}
