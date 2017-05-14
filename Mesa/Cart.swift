//
//  Cart.swift
//  Mesa
//
//  Created by Vibes on 5/2/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation

class Cart {
    
    var items : [Item] = []
    var totalWithoutTaxes : Double = 0
    var total : Double = 0
    var taxPercentage : Double = 0.08
    
    static let shared = Cart()
    
    func addToCart ( item : Item ) {
        
        self.items.append(item)
        self.totalWithoutTaxes += item.price
        updateTotal()
    }
    
    func removeFromCart ( itemNumber : Int ) {
        
        self.totalWithoutTaxes -= items[itemNumber].price
        updateTotal()
        self.items.remove(at: itemNumber)
        
    }
    
    func updateTotal () {
        
        self.total = (1 + taxPercentage)*totalWithoutTaxes

    }
    
    func reset() {
        self.items = []
        self.total = 0
        self.totalWithoutTaxes = 0
    }
}
