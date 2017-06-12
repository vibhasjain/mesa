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
    
    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        getCategories(number: number) { (sections) in
        
            DispatchQueue.main.async {
                self.sections = sections
                self.performSegue(withIdentifier: "showMenu", sender: self)
            }
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.loading.alpha = 0.7
        }, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
                destination.sections = sections
            
        }
    }
    
    


   

}
