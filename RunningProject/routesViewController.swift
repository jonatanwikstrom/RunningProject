//
//  routesViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-29.
//

import UIKit

class routesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var startRouteButton: UIButton!
    
    var routesArray = ["Karlstad stadslopp", "Gubbholmen", "Karlstad runt"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return routesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return routesArray[row]
    }
    
    
    @IBAction func startRouteTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "leaderboard_vc") as! leaderboardViewController
        present(vc, animated: true)
        
        
    }
    
}



