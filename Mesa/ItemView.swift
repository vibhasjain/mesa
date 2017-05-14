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
    
    var currentItemCount = 1
    
    @IBAction func addButton(_ sender: UIButton) {
        
        addItemToCart()
        
    }
    
    @IBAction func priceTAP(_ sender: Any) {
        
        addItemToCart()
    }
    
    @IBAction func topTouch(_ sender: Any) {
        
        delegate?.removeTooltip()
        
        if currentItemCount < ids.count {
            
            currentItemCount += 1
            
        } else {
            
            currentItemCount = 1
            
        }
        
        displayItem()
        
    }
    
    @IBAction func bottomTouch(_ sender: Any) {
        
        delegate?.removeTooltip()

        if currentItemCount > 1 {
            
            currentItemCount -= 1
            
        } else {
            
            currentItemCount = names.count
            
        }
        
        displayItem()
        
    }
    
    override func awakeFromNib() {
              
//        let bar = UIView(frame: CGRect(x: 20, y: self.frame.height - 10, width: self.frame.width/10, height: 3))
//        bar.backgroundColor = UIColor.white.withAlphaComponent(1)
//        bar.cornerRadius = 1.5
//        self.addSubview(bar)
//        self.bringSubview(toFront: bar)
//        
//        let bar2 = UIView(frame: CGRect(x: 20 + 2 + (self.frame.width/10), y: self.frame.height - 10, width: self.frame.width/10, height: 3))
//        bar2.backgroundColor = UIColor.white.withAlphaComponent(1)
//        bar2.cornerRadius = 1.5
//        self.addSubview(bar2)
//        self.bringSubview(toFront: bar2)
        
        
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
        barViews[currentItemCount-1].alpha = 1
        
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
        let width = (screenWidth - 40 - ((count-1) * space ))/count
        let yPosition : CGFloat = screenHeight - 10
        let alpha: CGFloat = 0.3
        
        for itemNum in 0..<items.count {
            
            let bar = UIView(frame: CGRect(x: 20 + (CGFloat(itemNum) * (space + width)), y: yPosition, width: width, height: 3))
            bar.backgroundColor = UIColor.white.withAlphaComponent(alpha)
            bar.cornerRadius = 1.5
            barViews.append(bar)
            self.addSubview(barViews[itemNum])
            self.bringSubview(toFront: barViews[itemNum])
            
        }
    }
    
    
}
