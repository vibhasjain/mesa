//
//  ItemView.swift
//  Mesa
//
//  Created by Vibes on 4/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

protocol ItemViewDelegate: class {
    
    func removeTooltip ()
    func updateItemCount ()
    
}

class ItemView: UIView {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemCount: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var priceButton: UIView!
    @IBOutlet weak var addLine: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addButtonText: UIButton!
    
    weak var delegate : ItemViewDelegate?
    
    var ids : [String] = []
    var names : [String] = []
    var imageURLs : [URL] = []
    var details : [String] = []
    var prices : [Double] = []
    var availables : [Bool] = []
    var items : [Item] = []
    var barViews : [UIView] = []
    let glowAlpha : CGFloat = 0.75
    let deGlowAlpha : CGFloat = 0.3
    
    var currentItemCount = 1
    
    @IBAction func addButton(_ sender: UIButton) {
        
        addItemToCart()
        
    }
    
    @IBAction func priceTAP(_ sender: Any) {
        
        addItemToCart()
    }
    
    @IBAction func addTap(_ sender: Any) {
        addItemToCart()
    }
    
    
    @IBAction func topTouch(_ sender: Any) {
        
        delegate?.removeTooltip()
        
        if currentItemCount < ids.count {
            
            currentItemCount += 1
            
        } else {
            
            currentItemCount = 1
            deGlowAll()
            
        }
        
        displayItem()
        
    }
    
    @IBAction func bottomTouch(_ sender: Any) {
        
        delegate?.removeTooltip()
        
        if currentItemCount > 1 {
            
            currentItemCount -= 1
            deGlowCurrent()
            
        } else {
            
            currentItemCount = names.count
            glowAll()
            
        }
        
        displayItem()
        
    }
    
    override func awakeFromNib() {
        
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
        
        glowCurrent()
        
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
            }
        })
    }
    
    func generateBars(screenWidth : CGFloat, screenHeight : CGFloat) {
        
        let count : CGFloat = CGFloat(items.count)
        let space : CGFloat = 3
        let width = (screenWidth - ((count-1) * space ))/count
        let barHeight : CGFloat = 2
        let yPosition : CGFloat = screenHeight - barHeight
        
        for itemNum in 0..<items.count {
            
            let bar = UIView(frame: CGRect(x: 0 + (CGFloat(itemNum) * (space + width)), y: yPosition, width: width, height: barHeight))
            bar.backgroundColor = UIColor.white
            bar.alpha = deGlowAlpha
//            bar.cornerRadius = 1.5
            barViews.append(bar)
            self.addSubview(barViews[itemNum])
            self.bringSubview(toFront: barViews[itemNum])
            
        }
    }
    
    func glowCurrent() {
        
        UIView.animate(withDuration: 0.3) {
            self.barViews[self.currentItemCount-1].alpha = self.glowAlpha
        }
    }
    
    func deGlowCurrent() {
        
        UIView.animate(withDuration: 0.3) {
            self.barViews[self.currentItemCount].alpha = self.deGlowAlpha
        }
    }
    
    func deGlowAll() {
        
        UIView.animate(withDuration: 0.3) {
            for view in 1..<self.barViews.count {
                self.barViews[view].alpha = self.deGlowAlpha
            }
        }
    }
    
    func glowAll() {
        
        UIView.animate(withDuration: 0.3) {
            self.barViews.forEach { (view) in
                view.alpha = self.glowAlpha
            }
        }
    }
    
    
}
