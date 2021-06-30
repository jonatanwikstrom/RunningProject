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
    
    var run: Run!
    let manager = CLLocationManager()
    var timer:Timer?
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var seconds = 0
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    
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
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      manager.stopUpdatingLocation()
    }

    
    @IBAction func startTapped(_ sender: Any) {
        startButton.isHidden = true
        stopButton.isHidden = false
        startTraining()
        
    }
    
    
    @IBAction func stopTapped(_ sender: Any) {
        stopTraining()
        let vc = storyboard?.instantiateViewController(identifier: "third_vc") as! thirdViewController
        vc.run = run
        present(vc, animated: true)
        
    }
    
    func startTraining(){
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateStats()
        mapView.removeOverlays(mapView.overlays)
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
        let currentDistance = distance
        let currentTime = FormatDisplay.time(seconds)
        
        distanceLabel.text = "Distance:  \(currentDistance)"
        timeLabel.text = "Time:  \(currentTime)"
    }
    
    func startLocationUpdates() {
      manager.activityType = .fitness
      manager.distanceFilter = 10
      manager.startUpdatingLocation()
    }
    
    
    func stopTraining(){
        saveProgress()
        manager.stopUpdatingLocation()
    }
    
    func saveProgress(){
        let newStat = Run(context: CoreDataStack.context)
        newStat.distance = distance.value
        newStat.duration = Int16(seconds)
        
        for location in locationList {
          let locStat = Location(context: CoreDataStack.context)
          locStat.latitude = location.coordinate.latitude
          locStat.longitude = location.coordinate.longitude
          newStat.addToLocations(locStat)
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
        
        for newLocation in locations {
          let howRecent = newLocation.timestamp.timeIntervalSinceNow
          guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

          if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            let coordinates = [lastLocation.coordinate, newLocation.coordinate]
            mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
          }
          
          locationList.append(newLocation)
        }
      
        
    }
    
}

