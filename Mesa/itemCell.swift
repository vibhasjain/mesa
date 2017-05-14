//
//  itemCell.swift
//  Mesa
//
//  Created by Vibes on 5/2/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

class itemCell: UITableViewCell {
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.price.alpha = 1
    }
    
    
    
}
