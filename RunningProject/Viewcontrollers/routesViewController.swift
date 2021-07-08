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
    var valueSelected = "Karlstad stadslopp"
    
    var latitudes = [Double]()
    var longitudes = [Double]()
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        valueSelected = routesArray[row]
    }
    
    
    @IBAction func startRouteTapped(_ sender: Any) {
        
        setLatLong()
        let vc = storyboard?.instantiateViewController(identifier: "leaderboard_vc") as! leaderboardViewController
        vc.routeName = valueSelected
        vc.latitudes = latitudes
        vc.longitudes = longitudes
        present(vc, animated: true)
        
        
    }
    
    func setLatLong(){
        
        if valueSelected == "Karlstad stadslopp"{
            
            
        }
        
        if valueSelected == "Gubbholmen"{
            latitudes = [59.385358, 59.385529, 59.385704, 59.385835, 59.385889, 59.385911, 59.385923, 59.385900, 59.385900, 59.385824, 59.385704, 59.385529, 59.385398, 59.385201, 59.385081, 59.384950, 59.384829, 59.384687, 59.384578, 59.384578, 59.384622]
            
            longitudes = [13.516556, 13.517200, 13.517909, 13.518617, 13.519390, 13.520421, 13.521315, 13.522352, 13.523167, 13.523876, 13.524155, 13.523898, 13.523232, 13.522437, 13.521428, 13.520591, 13.519732, 13.518723, 13.517993, 13.517220, 13.516382]
        }
        
        if valueSelected == "Karlstad runt"{
        }
        
    }
    
    
}
