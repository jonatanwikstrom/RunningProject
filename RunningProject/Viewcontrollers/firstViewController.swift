//
//  ViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-24.
//

import UIKit

class firstViewController: UIViewController {

    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var routesButton: UIButton!
    
    @IBOutlet weak var statsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let vc1 = storyboard?.instantiateViewController(identifier: "second_vc") as! secondViewController
        present(vc1, animated: true)
    }
    
    @IBAction func routesTapped(_ sender: Any) {
        let vc2 = storyboard?.instantiateViewController(identifier: "routes_vc") as! routesViewController
        present(vc2, animated: true)
        
    }
    
    
    @IBAction func statsTapped(_ sender: Any) {
        let vc3 = storyboard?.instantiateViewController(identifier: "personal_vc") as! personalPageViewController
        present(vc3, animated: true)
        
    }
    

}

