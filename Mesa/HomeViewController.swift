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
    
    @IBAction func account(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height*0.45
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
            cell.restaurantAddress.text = "2733 Madison Avenue NYC"
        case 1:
            cell.restaurantName.text = "Coming Soon"
            cell.restaurantAddress.text = "More Restaurants"
            cell.seeMenu.alpha = 0
        default: break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showMenu", sender: self)
        
    }
    
    
}
