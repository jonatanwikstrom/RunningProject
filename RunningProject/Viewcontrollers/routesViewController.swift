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
    
    var routesArray = ["Karlstad stadslopp", "Gubbholmen"]
    var valueSelected = "Karlstad stadslopp"
    
    var latitudes = [Double]()
    var longitudes = [Double]()
    
    //var context = NSPersistentContainer()
    
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
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func setLatLong(){
        
        if valueSelected == "Karlstad stadslopp"{
            latitudes = [59.390588, 59.390202, 59.390005, 59.389666, 59.388770, 59.388465, 59.387110, 59.386764, 59.383216, 59.383099, 59.382983, 59.381048, 59.380906, 59.379617, 59.379377, 59.378021, 59.378426, 59.377856, 59.377254, 59.376609, 59.375419, 59.375375, 59.376326, 59.374166, 59.371498, 59.370777, 59.370283, 59.369726, 59.368930, 59.365355, 59.365530, 59.365956, 59.366481, 59.367203, 59.368007, 59.369166, 59.369418, 59.371823, 59.372848, 59.374783, 59.375266, 59.374826, 59.374447, 59.375365, 59.377037, 59.377004, 59.377660, 59.379361, 59.379852, 59.380443, 59.380546, 59.380280, 59.380528, 59.380536, 59.379246, 59.379246, 59.381037, 59.381168, 59.382197, 59.385056, 59.385428, 59.386819, 59.387595, 59.387573, 59.386852, 59.385425, 59.385261, 59.386080, 59.385341, 59.385122, 59.385286, 59.385308, 59.385969, 59.386330, 59.387411, 59.387692, 59.388287, 59.388746, 59.389194, 59.390637]
            
            
            longitudes = [13.507566, 13.507360, 13.507489, 13.507231, 13.506973, 13.506817, 13.507525, 13.507375, 13.504590, 13.504932, 13.509005, 13.511088, 13.510379, 13.511984, 13.512134, 13.511576, 13.508784, 13.506359, 13.505323, 13.505344, 13.507652, 13.507373, 13.505183, 13.503337, 13.500207, 13.503114, 13.502913, 13.502462, 13.501095, 13.497995, 13.496234, 13.495461, 13.494065, 13.494044, 13.494775, 13.495333, 13.496108, 13.497294, 13.497435, 13.496856, 13.491384, 13.490795, 13.487492, 13.487621, 13.489597, 13.489962, 13.490113, 13.490734, 13.490454, 13.490497, 13.491388, 13.494870, 13.499337, 13.501768, 13.501725, 13.504238, 13.504307, 13.499927, 13.500413, 13.499454, 13.498918, 13.498612, 13.498805, 13.499256, 13.499707, 13.502032, 13.502375, 13.503878, 13.505813, 13.506908, 13.508089, 13.509721, 13.509828, 13.510580, 13.510881, 13.512118, 13.512207, 13.511799, 13.511734, 13.512155]
            
        }
        
        if valueSelected == "Gubbholmen"{
            latitudes = [59.385358, 59.385529, 59.385704, 59.385835, 59.385889, 59.385911, 59.385923, 59.385900, 59.385900, 59.385824, 59.385704, 59.385529, 59.385398, 59.385201, 59.385081, 59.384950, 59.384829, 59.384687, 59.384578, 59.384578, 59.384622]
            
            longitudes = [13.516556, 13.517200, 13.517909, 13.518617, 13.519390, 13.520421, 13.521315, 13.522352, 13.523167, 13.523876, 13.524155, 13.523898, 13.523232, 13.522437, 13.521428, 13.520591, 13.519732, 13.518723, 13.517993, 13.517220, 13.516382]
        }

    }
    
    
}
