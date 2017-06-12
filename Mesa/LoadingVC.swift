//
//  LoadingVC.swift
//  Mesa
//
//  Created by Vibes on 6/11/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
    
    var number = 0
    var sections : [Section] = []
    
    @IBOutlet weak var loading: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.autoreverse, .repeat], animations: { 
            self.loading.alpha = 0.5
        }, completion: nil)
        
        getCategories(number: number) { (sections) in
        
            self.sections = sections
            self.performSegue(withIdentifier: "showMenu", sender: self)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
                destination.sections = sections
            
        }
    }
    
    


   

}
