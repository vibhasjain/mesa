//
//  HomeViewController.swift
//  Mesa
//
//  Created by Vibes on 5/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func search(_ sender: Any) {
    }
    
    @IBAction func mesaButton(_ sender: Any) {
    }
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var topNav: UIView!
    
    var user_name : String = ""
    
    @IBAction func account(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileButton.setTitle(user_name, for: .normal)
        self.view.disappear()
        
        UserDefaults.standard.set(true, forKey: "onboardingHasAppeared")
        
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.fadeIn()
        self.searchButton.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if AppDelegate.isIPhone5() {
            
            return self.view.frame.height*0.57
        }
        return self.view.frame.height*0.47
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
        switch indexPath.row {
        case 0:
            cell.restaurantPhoto.image = UIImage(named: "fattybao")
            cell.restaurantName.text = "The Fatty Bao"
            cell.restaurantAddress.text = "2733 Madison Ave NYC"
        case 1:
            cell.restaurantPhoto.image = UIImage(named: "districtM")
            cell.restaurantName.text = "District M"
            cell.restaurantAddress.text = "700 8th Ave NYC"
        case 2:
            cell.restaurantName.text = "Coming Soon"
            cell.restaurantAddress.text = "More Restaurants"
        default: break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row != 2 {
            self.performSegue(withIdentifier: "loadMenu", sender: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LoadingVC {
            if let number = sender as? Int {
                destination.number = number
            }
        }
    }
    
}
