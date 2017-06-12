//
//  CartViewController.swift
//  Mesa
//
//  Created by Vibes on 5/2/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import KeychainSwift

protocol CartViewDelegate: class {
    
    func updateItemCount ()
    
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PaymentViewDelegate, SeatedViewDelegate {
    
    @IBOutlet weak var dunzo: UIImageView!
    @IBOutlet weak var ccView: UIView!
    
    @IBOutlet weak var ccType: UILabel!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var ccSubtitle: UILabel!
    @IBOutlet weak var itemTable: UITableView!
    @IBOutlet weak var cartSubtitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var nextButtonStyle: UIButton!
    
    let keychain = KeychainSwift()
    
    var animationDuration = 0.2
    
    weak var delegate : CartViewDelegate?
    
    var cardType : String?
    
    var taxesTotal = ["Taxes", "Total"]
    
    let paymentView:PaymentView = Bundle.main.loadNibNamed("PaymentView", owner: self, options: nil)?.first as! PaymentView
    
    let seatedView:SeatedView = Bundle.main.loadNibNamed("SeatedView", owner: self, options: nil)?.first as! SeatedView
    
    @IBAction func dismissTap(_ sender: Any) {
        
        dismissCart()
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        
        dismissCart()
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        
        dismissCart()
        
    }
    
    func paymentToCart() {
        
        displayCCType()
        UIView.animate(withDuration: animationDuration) {
            
            self.cartView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.paymentView.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }
        
        paymentView.cardNumber.resignFirstResponder()
        paymentView.cvv.resignFirstResponder()
        paymentView.mm.resignFirstResponder()
        paymentView.yy.resignFirstResponder()
        
        
    }
    
    func seatedToCart() {
        
        UIView.animate(withDuration: animationDuration) {
            
            self.cartView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.seatedView.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }
        
        seatedView.tableNumber.resignFirstResponder()
        
    }
    
    @IBAction func ccButton(_ sender: Any) {
        
//        self.paymentView.resetCard()
//        self.paymentView.setBorders()
//        self.paymentView.displaySavedCard()
//        
//        UIView.animate(withDuration: animationDuration) {
//            
//            self.cartView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
//            self.paymentView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
//            
//        }
//        
//        paymentView.cardNumber.becomeFirstResponder()
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
//        var cartEmpty = false
//        var noCC = false
//        
//        if Cart.shared.items.count == 0 {
//            
//            cartEmpty = true
//            cartSubtitle.shake()
//            
//        }
//        
//        if CreditCard.shared.cardNumber == nil {
//            
//            noCC = true
//            ccView.shake()
//            
//        }
//        
//        if !cartEmpty && !noCC {
//            
//            UIView.animate(withDuration: animationDuration) {
//                
//                self.cartView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
//                self.seatedView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
//                
//            }
//            
//            seatedView.tableNumber.becomeFirstResponder()
//            
//        }
        
    }
    
    
    override func viewDidLoad() {
        
        paymentView.delegate = self
        seatedView.delegate = self
        
        
        super.viewDidLoad()
        
        readCCFromKeychain()
        displayCCType()
        
        paymentView.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.cartView.frame.width, height: self.cartView.frame.height)
        
        seatedView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.cartView.frame.width, height: self.cartView.frame.height)
        
        self.containerView.addSubview(paymentView)
        self.containerView.addSubview(seatedView)
        
        itemTable.register(UINib(nibName: "itemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        
        itemTable.tableFooterView = UIView(frame: CGRect.zero)
        
        cartSubtitle.text = "\(Cart.shared.items.count) Items  -  $ \(Cart.shared.total) "
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Cart.shared.items.count
        case 1:
            return taxesTotal.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! itemCell
        
        switch indexPath.section {
        case 0:
            cell.itemName.text = Cart.shared.items[indexPath.row].name
            cell.price.text = "$ \(Cart.shared.items[indexPath.row].price)"
        case 1:
            cell.itemName.text = taxesTotal[indexPath.row]
            if indexPath.row == 0 {
                cell.price.text = "$ \(Cart.shared.totalWithoutTaxes*Cart.shared.taxPercentage)"
                cell.price.alpha = 0.5
            } else {
                cell.price.text = "$ \(Cart.shared.total)"
            }
        default: break
        }
        
        return cell
        
    }
    
    // GENERATING A BLANK WHITE SECTION IN BETWEEN DISHES AND TAXES
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
            view.backgroundColor = .white
            
            return view
        }
        
        return nil
    }
    
    // HEIGHT OF BLANK SECTION BETWEEN DISHES AND TAXES
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 0:    return .delete
        default:   return .none
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard indexPath.section == 0 else { return nil }
        
        
        let remove = UITableViewRowAction(style: .normal, title: "Remove") { (action, indexPath) in
            Cart.shared.removeFromCart(itemNumber: indexPath.row)
            self.itemTable.reloadData()
            self.cartSubtitle.text = "\(Cart.shared.items.count) Items  -  $ \(Cart.shared.total) "
            //self.itemTable.reloadSections(IndexSet(1), with: .none)
            self.delegate?.updateItemCount()
        }
        
        remove.backgroundColor = UIColor.red
        
        return [remove]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.15) {
            self.blackView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissCart() {
        
        self.blackView.alpha = 0
        dismiss(animated: true, completion: nil)
        self.delegate?.updateItemCount()
        paymentView.cardNumber.resignFirstResponder()
        paymentView.cvv.resignFirstResponder()
        paymentView.mm.resignFirstResponder()
        paymentView.yy.resignFirstResponder()
        seatedView.tableNumber.resignFirstResponder()
        
    }
    
    func placeOrder() {
        
            UIView.animate(withDuration: 0.5) {
                self.seatedView.tableNumber.resignFirstResponder()
                self.seatedView.alpha = 0
                self.containerView.backgroundColor = greenColorUI
                self.dunzo.alpha = 1
            }
            
            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.25, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.dunzo.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                Cart.shared.reset()
                self.dismissCart()
            })
            
    }
    
    func displayCCType() {
        
        guard let savedCCType = CreditCard.shared.type else { return }
        ccType.text = savedCCType
        let cc = CreditCard.shared.cardNumber!
        let last4 = cc.substring(from:cc.index(cc.endIndex, offsetBy: -4))
        ccSubtitle.text = last4
    }
    
    
}
