//
//  MenuExtension.swift
//  Mesa
//
//  Created by Vibes on 6/4/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[currentCategory].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.backgroundColor = UIColor.white.withAlphaComponent(0)
        cell.update(name: sections[currentCategory].items[indexPath.row].name, details: sections[currentCategory].items[indexPath.row].details)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTable.alpha = 0
        itemViews[currentCategory].currentItemCount = indexPath.row + 1
        itemViews[currentCategory].collapseMenu()
        itemViews[currentCategory].displayItem()

    }
    
    
}
