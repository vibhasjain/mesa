//
//  temp.swift
//  Mesa
//
//  Created by Vibes on 5/3/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit
import CreditCardValidator

protocol PaymentViewDelegate: class {
    
    func paymentToCart()
    
}

class PaymentView : UIView, UITextFieldDelegate {
    
    let ccValidator = CreditCardValidator()
    
    weak var delegate : PaymentViewDelegate?
    
    @IBOutlet weak var saveButtonLayer: UIButton!
    
    @IBOutlet weak var mm: CustomSearchTextField!
    
    @IBOutlet weak var yy: CustomSearchTextField!
    
    @IBOutlet weak var cardNumber: UITextField!
    
    @IBOutlet weak var cvv: UITextField!
    
    var selectedCardType: String? {
        
        didSet{
            
            reformatAsCardNumber(textField: cardNumber)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        delegate?.paymentToCart()
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let cardValidation = validateCardNumber()
        let mmValidation = validateMM()
        let yyValidation = validateYY()
        let cvvValidation = validateCVV()
        
        if cardValidation && mmValidation && yyValidation && cvvValidation {
            saveCreditCard()
            saveCCToKeychain()
            delegate?.paymentToCart()
        }
        
    }
    
    class func instanceFromNib() -> UIView {
        
        return UINib(nibName: "PaymentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func awakeFromNib() {
        
        [mm,cvv,yy,cardNumber].forEach{$0.delegate = self}
        
        resetCard()
        displaySavedCard()
        cosmetics()
        
        cardNumber.addTarget(self, action: #selector(self.reformatAsCardNumber(textField:)), for: UIControlEvents.editingChanged)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.mm || textField == self.yy) {
            
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 2
            
        } else if (textField == self.cvv) {
            
            guard let text = textField.text else { return true }
            
            let newLength = text.characters.count + string.characters.count - range.length
            
            return newLength <= 5
            
        }
            
        else { return true }
    }
    
    
    func validateCardNumber() -> Bool {
        
        if ccValidator.validate(string: cardNumber.text!) {
            
            cardNumber.borderColor = gray3
            return true
            
        } else {
            
            cardNumber.borderColor = UIColor.red
            return false
        }
    }
    
    func validateMM() -> Bool {
        
        if mm.text == nil {
            
            mm.borderColor = UIColor.red
            return false
            
        }
        
        guard let mmInt = Int(mm.text!) else {
            
            mm.borderColor = UIColor.red
            return false
        }
        
        if mmInt > 12 || mmInt <= 0 {
            
            mm.borderColor = UIColor.red
            return false
            
        }
        
        mm.borderColor = gray3
        return true
        
    }
    
    func validateYY() -> Bool {
        
        if yy.text == nil {
            
            yy.borderColor = UIColor.red
            return false
            
        }
        
        guard let yyInt = Int(yy.text!) else {
            
            yy.borderColor = UIColor.red
            return false
        }
        
        if yyInt < 17 {
            
            yy.borderColor = UIColor.red
            return false
            
        }
        
        yy.borderColor = gray3
        return true
        
    }
    
    func validateCVV() -> Bool {
        
        if cvv.text == nil {
            
            cvv.borderColor = UIColor.red
            return false
            
        }
        
        guard let cvvInt = Int(cvv.text!) else {
            
            cvv.borderColor = UIColor.red
            return false
        }
        
        cvv.borderColor = gray3
        return true
    }
    
    
    func reformatAsCardNumber(textField:UITextField){
        let formatter = CreditCardFormatter()
        var isAmex = false
        if selectedCardType == "AMEX" {
            isAmex = true
        }
        formatter.formatToCreditCardNumber(isAmex: isAmex, textField: textField, withPreviousTextContent: textField.text, andPreviousCursorPosition: textField.selectedTextRange)
    }
    
    func whiteOut (string : String) -> String {
        
        return String(string.characters.filter { !" \n\t\r".characters.contains($0) })
        
    }
    
    func displaySavedCard() {
        
        guard let cardNumber = CreditCard.shared.cardNumber else { return }
        guard let mm = CreditCard.shared.expiryMonth else { return  }
        guard let yy = CreditCard.shared.expiryYear else { return  }
        guard let cvv = CreditCard.shared.cvv else { return  }
        
        self.cardNumber.text = cardNumber
        self.mm.text = mm
        self.yy.text = yy
        self.cvv.text = cvv
        
    }
    
    func resetCard() {
        
        cardNumber.text = nil
        cvv.text = nil
        mm.text = nil
        yy.text = nil
    }
    
    func setBorders() {
        
        self.cardNumber.borderColor = gray3
        self.cardNumber.borderWidth = 1
        self.cardNumber.cornerRadius = 4
        
        self.mm.borderColor = gray3
        self.mm.borderWidth = 1
        self.mm.cornerRadius = 4
        
        self.yy.borderColor = gray3
        self.yy.borderWidth = 1
        self.yy.cornerRadius = 4
        
        self.cvv.borderColor = gray3
        self.cvv.borderWidth = 1
        self.cvv.cornerRadius = 4
        
        
    }
    
    func saveCreditCard() {
        
        CreditCard.shared.cardNumber = cardNumber.text
        CreditCard.shared.cvv = cvv.text
        CreditCard.shared.expiryMonth = mm.text
        CreditCard.shared.expiryYear = yy.text
        
        if let ccType = ccValidator.type(from: CreditCard.shared.cardNumber!) {
            CreditCard.shared.type = ccType.name
        } else {
            CreditCard.shared.type = "Saved Card"
        }
        
    }
    
    func cosmetics() {
        
        self.saveButtonLayer.greenShadow()
        setBorders()
    }
}
