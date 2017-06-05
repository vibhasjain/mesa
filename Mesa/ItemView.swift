//
//  ItemView.swift
//  Mesa
//
//  Created by Vibes on 4/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

protocol ItemViewDelegate: class {
    
    func updateItemCount()
    func showMenu()
    func showOrderButton()
    func hideOrderButton()
    func shrinkClose()
    func growClose()
    
}

class ItemView: UIView {
    
    @IBOutlet weak var rightCircle: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var priceButton: UIView!
    @IBOutlet weak var addLine: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rightTap: UIImageView!
    @IBOutlet weak var leftTap: UIImageView!
    @IBOutlet weak var addButtonText: UIButton!
    @IBOutlet weak var menuView: UIVisualEffectView!
    
    @IBOutlet weak var menuBottomBottom: NSLayoutConstraint!
    @IBOutlet weak var menuBottom: NSLayoutConstraint!
    @IBOutlet weak var menuWidth: NSLayoutConstraint!
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    
    let burger = UIImageView(image: #imageLiteral(resourceName: "burgerWhite"))
    
    weak var delegate : ItemViewDelegate?
    
    var ids : [String] = []
    var names : [String] = []
    var imageURLs : [URL] = []
    var details : [String] = []
    var prices : [Double] = []
    var availables : [Bool] = []
    var items : [Item] = []
    var barViews : [UIView] = []
    var menuIsExpanded = false
    
    @IBAction func menuTap(_ sender: Any) {
        if !menuIsExpanded {
            expandMenu()
        }
    }
    
    
    var currentItemCount = 1
    
    @IBAction func addButton(_ sender: UIButton) {
        
        addItemToCart()
        
    }

    func collapseMenu() {
        
        delegate?.showOrderButton()
        
        self.menuWidth.constant = 45
        self.menuHeight.constant =  45
        self.menuBottom.constant = 15
        self.menuBottomBottom.priority = 1
        self.menuBottom.priority = 999
        self.menuView.cornerRadius = 22.5
//        delegate?.growClose()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.burger.alpha = 1
            self.layoutIfNeeded()
        }) { (true) in
            self.menuIsExpanded = false
        }
    }
    
    func expandMenu() {
        
        self.menuIsExpanded = true
        self.delegate?.showMenu()
        self.delegate?.hideOrderButton()
        self.showMenu()
//        delegate?.shrinkClose()
        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
            self.burger.alpha = 0
        }) { (true) in
            
            
        }
    }
    
    func showMenu() {
        
        self.menuWidth.constant = self.itemDescription.frame.size.width + 3
        self.menuHeight.constant =  self.priceButton.frame.origin.y + 20
        self.menuBottomBottom.constant = -10
        self.menuBottomBottom.priority = 999
        self.menuBottom.priority = 1
        self.menuView.cornerRadius = 4
    }
    
    @IBAction func priceTAP(_ sender: Any) {
        
        addItemToCart()
    }
    
    @IBAction func addTap(_ sender: Any) {
        
        addItemToCart()
    }
    
    
    @IBAction func topTouch(_ sender: Any) {
        
        
        if currentItemCount < ids.count {
            
            currentItemCount += 1
            
        } else {
            
            currentItemCount = 1
            
        }
        
        flashTap(rightTap)
        
        displayItem()
        
    }
    
    @IBAction func bottomTouch(_ sender: Any) {
        
        
        if currentItemCount > 1 {
            
            currentItemCount -= 1
            
            
        } else {
            
            currentItemCount = names.count
            
        }
        
        flashTap(leftTap)
        displayItem()
        
    }
    
    
    override func awakeFromNib() {
        
        addBurger()
        
    }
    
    func addBurger() {
        self.menuView.addSubview(burger)
        burger.frame = CGRect(x: 12.8, y: 15, width: 19, height: 14)
        burger.alpha = 1
    }
    
    
    func addItemToCart() {
        
        if availables[currentItemCount-1] == true {
            
            Cart.shared.addToCart(item: items[currentItemCount-1])
            
            UIView.transition(with: addButtonText, duration: 0.05, options: .transitionCrossDissolve, animations: {
                
                self.addButtonText.setTitle("Added!", for: .normal)
                self.priceButton.backgroundColor = UIColor.white
                self.addLine.backgroundColor = UIColor.black
                self.priceLabel.textColor = UIColor.black
                self.addButtonText.setTitleColor(UIColor.black, for: .normal)
                self.layoutIfNeeded()
                
            }, completion: { (finished: Bool) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    UIView.transition(with: self.addButtonText, duration: 0.05, options: .transitionCrossDissolve, animations: {
                        self.addButtonText.setTitle("Add", for: .normal)
                        self.priceButton.backgroundColor = UIColor.black.withAlphaComponent(0)
                        self.addLine.backgroundColor = UIColor.white
                        self.priceLabel.textColor = UIColor.white
                        self.addButtonText.setTitleColor(UIColor.white, for: .normal)
                        self.layoutIfNeeded()
                    }, completion: nil)
                })
            })
        }
        
        delegate?.updateItemCount()
    }
    
    func displayItem()  {
        
        
        itemName.text = names[currentItemCount-1]
        itemDescription.text = details[currentItemCount-1]
        itemPrice.text = "$ \(prices[currentItemCount-1])"
        itemCount.text = "\(currentItemCount) / \(names.count)"
        
        if availables[currentItemCount-1] == false {
            
            addButtonText.setTitle("Sold Out", for: UIControlState.normal)
            addButtonText.alpha = 0.5
            
            
        } else {
            
            addButtonText.setTitle("Add", for: UIControlState.normal)
            addButtonText.alpha = 1
        }
        
        
        let refresher = UIActivityIndicatorView(frame: itemImage.frame)
        refresher.color = .white
        
        refresher.layer.masksToBounds = false
        refresher.layer.shadowColor = UIColor.black.cgColor
        refresher.layer.shadowOpacity = 0.3
        refresher.layer.shadowOffset = CGSize(width: 0, height: 1)
        refresher.layer.shadowRadius = 0
        
        refresher.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        refresher.layer.shouldRasterize = true
        
        refresher.startAnimating()
        
        itemImage.addSubview(refresher)
        loadImage(atURL: imageURLs[currentItemCount-1], completion: { (fetchedImage) in
            DispatchQueue.main.async {
                self.itemImage.image = fetchedImage
                refresher.removeFromSuperview()
                self.popItemCount()
            }
        })
    }
    
    
    func popItemCount() {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [], animations: {
            self.itemCount.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { (true) in
            
            UIView.animate(withDuration: 0.05, animations: {
                self.itemCount.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
        }
        )
    }
    
    func flashTap(_ side : UIImageView) {
        
        UIView.animate(withDuration: 0.1, animations: {
            side.alpha = 0.75
        }) { (true) in
            UIView.animate(withDuration: 0.25, animations: {
                side.alpha = 0
            })
            
        }
        
    }
    
    
}
