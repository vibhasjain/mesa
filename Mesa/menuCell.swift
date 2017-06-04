//
//  menuCell.swift
//  Mesa
//
//  Created by Vibes on 6/4/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

class MenuCell : UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDetails: UILabel!
    
    func update(name : String, details : String){
        
        self.itemName.text = name
        self.itemDetails.text = details
    }
    
}
