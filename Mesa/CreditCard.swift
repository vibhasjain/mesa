//
//  CreditCard.swift
//  Mesa
//
//  Created by Vibes on 5/4/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation

class CreditCard {
    
    var cardNumber : String?
    var expiryMonth : String?
    var expiryYear : String?
    var cvv : String?
    var type : String?
    
    static let shared = CreditCard()
    
}
