//
//  File.swift
//  Mesa
//
//  Created by Vibes on 5/3/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import UIKit

protocol SeatedViewDelegate: class {
    
    func seatedToCart()
    func placeOrder()
    
}

class SeatedView : UIView {
    
    weak var delegate : SeatedViewDelegate?
    
    @IBOutlet weak var waiterPicker: AKPickerView!
    
    let waiterNames = ["Waiter Name 👉","John Lennon","Paul McCartney","George Harrison","Ringo Starr"]
    
    var selectedWaiter = 0
    
    @IBOutlet weak var tableNumber: UITextField!
    
    @IBAction func backButton(_ sender: Any) {
        
        delegate?.seatedToCart()
        
    }
    
    @IBAction func placeOrder(_ sender: Any) {
        
        let tableValidation = validateTable()
        let waiterValidation = validateWaiter()
        
        if tableValidation && waiterValidation {
            
            delegate?.placeOrder()
        }
        
        
    }
    
    @IBOutlet weak var placeOrderLayer: UIButton!
    
    func cosmetics() {
        
        self.placeOrderLayer.greenShadow()
    }
    
    override func awakeFromNib() {
        
        cosmetics()
        tableNumber.setGrayBorder()
        configurePickerView()
    }
    
    func orderSpinner() {
        
        let refresher = UIActivityIndicatorView(frame: placeOrderLayer.frame)
        
        refresher.color = .white
        
        refresher.layer.masksToBounds = false
        
        refresher.layer.shouldRasterize = true
        
        refresher.startAnimating()
        
        placeOrderLayer.setTitleColor(greenColorUI, for: .normal)
        placeOrderLayer.addSubview(refresher)
        placeOrderLayer.bringSubview(toFront: refresher)
        
    }
    
    func validateTable() -> Bool {
        
        if tableNumber.text == nil {
            
            tableNumber.borderColor = UIColor.red
            return false
            
        }
        
        guard let tableNo = Int(tableNumber.text!) else {
            
            tableNumber.borderColor = UIColor.red
            return false
        }
        
        if tableNo < 0 {
            
            tableNumber.borderColor = UIColor.red
            return false
            
        }
        
        tableNumber.borderColor = gray3
        return true
    }
    
    func validateWaiter() -> Bool {
        
        if selectedWaiter == 0 {
            
            waiterPicker.borderColor = UIColor.red
            return false
            
        }
        
        waiterPicker.borderColor = gray3
        return true
    }
    
}

extension SeatedView : AKPickerViewDataSource, AKPickerViewDelegate  {
    
    func configurePickerView() {
        self.waiterPicker.delegate = self
        self.waiterPicker.dataSource = self
        
        self.waiterPicker.font = UIFont.systemFont(ofSize: 17)
        self.waiterPicker.highlightedFont = UIFont.systemFont(ofSize: 17)
        self.waiterPicker.pickerViewStyle = .wheel
        self.waiterPicker.maskDisabled = false
        self.waiterPicker.reloadData()
    }
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return self.waiterNames.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.waiterNames[item]
    }
    
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        selectedWaiter = item
    }
    
    func pickerView(_ pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor.lightGray
        if item != 0 {
            label.highlightedTextColor = UIColor.black
        } else {
            label.highlightedTextColor = UIColor.lightGray
        }
        
        //        label.backgroundColor = UIColor(
        //            hue: CGFloat(item) / CGFloat(self.waiterNames.count),
        //            saturation: 1.0,
        //            brightness: 0.5,
        //            alpha: 1.0)
    }
    
    func pickerView(_ pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSize(width: 15, height: 20)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }
    
}
