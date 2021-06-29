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
    let manager = LocationManager.shared
    var timer:Timer?
    
    var seconds = 0
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.startUpdatingLocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      manager.stopUpdatingLocation()
    }

    
    func currentPosition(_ location: CLLocation){
        
        let MyCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: MyCoordinate, span: span)
        mapView.setRegion(region, animated: true)

        mapView.showsUserLocation = true
        
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
      manager.desiredAccuracy = kCLLocationAccuracyBest
      manager.delegate = self
      manager.activityType = .fitness
      manager.distanceFilter = 10
      manager.startUpdatingLocation()
    }
    
    
    func stopTraining(){
        saveProgress()
        manager.stopUpdatingLocation()
    }
    
    func saveProgress(){
        let newRun = Run(context: CoreDataStack.context)
        newRun.distance = distance.value
        newRun.duration = Int16(seconds)
        
        for location in locationList {
          let locationObject = Location(context: CoreDataStack.context)
          locationObject.latitude = location.coordinate.latitude
          locationObject.longitude = location.coordinate.longitude
          newRun.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        run = newRun
    }

}

extension secondViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .blue
    renderer.lineWidth = 3
    return renderer
  }
}

extension secondViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
          let howRecent = newLocation.timestamp.timeIntervalSinceNow
          guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

          if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            let coordinates = [lastLocation.coordinate, newLocation.coordinate]
            mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: newLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            currentPosition(lastLocation)
          }
          
          locationList.append(newLocation)
        }
      
        
    }
    
}

