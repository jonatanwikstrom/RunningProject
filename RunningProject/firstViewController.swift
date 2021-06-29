//
//  ViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-24.
//

import UIKit

class firstViewController: UIViewController {

    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "second_vc") as! secondViewController
        present(vc, animated: true)
    }
    


}

