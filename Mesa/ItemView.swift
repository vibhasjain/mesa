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
    func removeCircle()
    func tooltipHasAppeared() -> Bool
    
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
    @IBOutlet weak var tapForNext: UILabel!
    @IBOutlet weak var blackRightArrow: UIImageView!
    
    @IBOutlet weak var rightHandView: UIView!
    @IBOutlet weak var addButtonText: UIButton!
    
    @IBAction func tapRightCircle(_ sender: Any) {
        
    }
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
        
        nextDishTooltip()

        
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
        
        self.rightHandView.alpha = 0
        self.rightCircle.alpha = 0
        self.blackRightArrow.alpha = 0
        
        
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
        
//        glowCurrent()
        
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
    
    func generateBars(screenWidth : CGFloat, screenHeight : CGFloat) {
        
        let count : CGFloat = CGFloat(items.count)
        let space : CGFloat = 3
        let barHeight : CGFloat = 10
        let visibleHeight : CGFloat = 2
        let yPosition : CGFloat = screenHeight - visibleHeight
        let sideSpace : CGFloat = 20
        let width = (screenWidth - (2*sideSpace) - ((count-1) * space ))/count

        
        for itemNum in 0..<items.count {
            
            let bar = UIView(frame: CGRect(x: sideSpace + (CGFloat(itemNum) * (space + width)), y: yPosition, width: width, height: barHeight))
            bar.backgroundColor = UIColor.white
            bar.alpha = deGlowAlpha
            bar.cornerRadius = 1
            barViews.append(bar)
            self.addSubview(barViews[itemNum])
            self.bringSubview(toFront: barViews[itemNum])
            
        }
    }
    
    func glowCurrent() {
        
        deGlowAll()
        UIView.animate(withDuration: 0.3) {
            self.barViews[self.currentItemCount-1].alpha = self.glowAlpha
            self.barViews[self.currentItemCount-1].transform = CGAffineTransform(translationX: 0, y: -3)
            self.barViews[self.currentItemCount-1].cornerRadius = 1.5
        }
    }
    
    func deGlowCurrent() {
        
        UIView.animate(withDuration: 0.3) {
            self.barViews[self.currentItemCount].alpha = self.deGlowAlpha
        }
    }
    
    func deGlowAll() {
        
        UIView.animate(withDuration: 0.3) {
            for view in 0..<self.barViews.count {
                self.barViews[view].alpha = self.deGlowAlpha
                self.barViews[view].transform = CGAffineTransform(translationX: 0, y: 0)
                self.barViews[view].cornerRadius = 1
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
    
    func nextDishTooltip() {
        
        let tooltipHasAppeared : Bool = (delegate?.tooltipHasAppeared())!
        if !tooltipHasAppeared {
            
            self.rightCircle.alpha = 1
            self.blackRightArrow.alpha = 1
            delegate?.removeCircle()
            
            UIView.animate(withDuration: 0.35, animations: {
                self.rightCircle.frame = CGRect(x: -500, y: -350, width: 1200, height: 1200)
                self.rightCircle.alpha = 0.9
                self.rightHandView.alpha = 1
                self.blackRightArrow.alpha = 0
                self.blackRightArrow.frame.origin.x += 20
            }) { (true) in
                
                
                UIView.animate(withDuration: 0.5, delay: 2, options: [], animations: {
                    self.rightCircle.alpha = 0
                    self.rightHandView.alpha = 0
                }, completion: { (true) in
                    self.rightHandView.isHidden = true
                    self.rightCircle.isHidden = true
                    self.blackRightArrow.isHidden = true
                })
                
            }
            
        }
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
