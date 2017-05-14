//
//  Keychain.swift
//  Mesa
//
//  Created by Vibes on 5/8/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import KeychainSwift

let cardKey = "CardNumber"
let cvvKey = "CVV"
let mmKey = "MM"
let yyKey = "YY"
let typeKey = "CardType"

func saveCCToKeychain() {
    
    let keychain = KeychainSwift()
    keychain.set(CreditCard.shared.cardNumber!, forKey: cardKey)
    keychain.set(CreditCard.shared.cvv!, forKey: cvvKey)
    keychain.set(CreditCard.shared.expiryMonth!, forKey: mmKey)
    keychain.set(CreditCard.shared.expiryYear!, forKey: yyKey)
    keychain.set(CreditCard.shared.type!, forKey: typeKey)
    
}

func readCCFromKeychain() {
    
    let keychain = KeychainSwift()
    
    guard let cardNum = keychain.get(cardKey) else { return }
    
    CreditCard.shared.cardNumber = cardNum
    CreditCard.shared.cvv = keychain.get(cvvKey)
    CreditCard.shared.expiryYear = keychain.get(yyKey)
    CreditCard.shared.expiryMonth = keychain.get(mmKey)
    CreditCard.shared.type = keychain.get(typeKey)
}
