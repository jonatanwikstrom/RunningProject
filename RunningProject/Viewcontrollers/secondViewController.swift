//
//  secondViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-24.
//

import UIKit
import MapKit
import CoreLocation

class secondViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    var run: Run!
    var preLoadRun: PreLoadRun!
    let manager = CLLocationManager()
    var timer:Timer?
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var seconds = 0
    var distance = Measurement(value: 0, unit: UnitLength.kilometers)
    var locationList: [CLLocation] = []
    var competitionList: [CLLocation] = []
    
    var latitudes = [Double]()
    var longitudes = [Double]()
    var importedPolyline = MKPolyline()
    var challengeBool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.removeOverlays(mapView.overlays)
        checkForChallenge()
        updateDesign()
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      manager.stopUpdatingLocation()
    }

    
    @IBAction func startTapped(_ sender: Any) {
        if challengeBool == false{
        startButton.isHidden = true
        stopButton.isHidden = false
        }
        else {
            startButton.isHidden = true
            stopButton.isHidden = true
            
        }
        startTraining()
        
    }
    
    
    @IBAction func stopTapped(_ sender: Any) {
        stopTraining()
        let vc = storyboard?.instantiateViewController(identifier: "third_vc") as! thirdViewController
        vc.run = run
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.isNavigationBarHidden = true
        resetRunPage()
        
        
        
    }
    
    func updateDesign(){
        
        startButton.setUpLayer(sampleButton: startButton)
        stopButton.setUpLayer(sampleButton: stopButton)
        
    }
    
    func startTraining(){
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.kilometers) / 1000
        locationList.removeAll()
        updateStats()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.everySec()
        }
        startLocationUpdates()

    }
    
    func everySec(){
        seconds += 1
        updateStats()
    }
    
    private func updateStats() {
        //let currentDistance = FormatDisplay.dist2(distance)
        let currentDistance = FormatDisplay.preciseRound(distance.value, precision: .hundredths)
        let currentTime = FormatDisplay.time(seconds)
        
        distanceLabel.text = "\(currentDistance)"
        timeLabel.text = "\(currentTime)"
    }
    
    func startLocationUpdates() {
      manager.activityType = .fitness
      manager.distanceFilter = 10
      manager.startUpdatingLocation()
    }
    
    func resetRunPage(){
        timer?.invalidate()
        stopButton.isHidden = true
        startButton.isHidden = false
     
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.kilometers) / 1000
        updateStats()
    }
    
    
    func stopTraining(){
        saveProgress()
        manager.stopUpdatingLocation()
    }
    
    func saveProgress(){
        let newStat = Run(context: CoreDataStack.context)
        if challengeBool == false{
        newStat.distance = FormatDisplay.preciseRound(distance.value, precision: .hundredths)
        newStat.duration = Int16(seconds)
        
        for location in locationList {
          let locStat = Location(context: CoreDataStack.context)
          locStat.latitude = location.coordinate.latitude
          locStat.longitude = location.coordinate.longitude
          newStat.addToLocations(locStat)
        }
        }
        else if challengeBool == true{
            newStat.gubbholmen = Int16(seconds)
        }
        CoreDataStack.saveContext()
        
        run = newStat
        

    }
    
    func currentLocUpdate(_ location: CLLocation){
        
        let MyCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: MyCoordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
    func checkForChallenge(){
        
        if latitudes.isEmpty{
            return
        }else{
            mapView.addOverlay(importedPolyline)
            challengeBool = true
            let startPin = MKPointAnnotation()
            let finishPin = MKPointAnnotation()
              startPin.coordinate.latitude = latitudes.first!
              startPin.coordinate.longitude = longitudes.first!
              startPin.title = "Starting line"
              startPin.title = "Finish line"
              finishPin.coordinate.latitude = latitudes.last!
              finishPin.coordinate.longitude = longitudes.last!

              mapView.addAnnotation(startPin)
              mapView.addAnnotation(finishPin)
        }
 
    }
    
    func checkDifference(){
            
        
    }

}

extension secondViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

 if let routePolyline = overlay as? MKPolyline {
    let renderer = MKPolylineRenderer(polyline: routePolyline)
    renderer.strokeColor = UIColor.blue.withAlphaComponent(0.9)
    renderer.lineWidth = 3
    return renderer
  }
  return MKOverlayRenderer()
}
}

extension secondViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLocation = locations.first{
            currentLocUpdate(currentLocation)
        }
        if challengeBool == true {
            if (abs(latitudes[0] - manager.location!.coordinate.latitude)) > 0.001 || (abs(longitudes[0] - manager.location!.coordinate.longitude)) > 0.001 {
                warningLabel.isHidden = false
                startButton.isEnabled = false
                startButton.setTitleColor(.gray, for: .normal)
                
            }
            else{
                warningLabel.isHidden = true
                startButton.isEnabled = true
                startButton.setTitleColor(.blue, for: .normal)
            }
            
            if startButton.isSelected{
                checkDifference()
            }
            
            if (abs(latitudes.last! - manager.location!.coordinate.latitude)) < 0.01 && (abs(longitudes.last! - manager.location!.coordinate.longitude)) < 0.01 {
                
                stopButton.isHidden = true
                startButton.isHidden = false
                stopTraining()
                challengeBool = false
                let vc = storyboard?.instantiateViewController(identifier: "third_vc") as! thirdViewController
                vc.run = run
                navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
        for newLocation in locations {
          let howRecent = newLocation.timestamp.timeIntervalSinceNow
          guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }


          if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.kilometers) / 1000
            let coordinates = [lastLocation.coordinate, newLocation.coordinate]
            if startButton.isHidden == true{
            mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
            }
          }
          
          locationList.append(newLocation)
        }
        
        
    }
    
}


extension UIButton
{
 func setUpLayer(sampleButton: UIButton?) {
    
    sampleButton!.layer.cornerRadius = 15
    sampleButton!.layer.masksToBounds = true
    
  sampleButton!.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
 }

}


