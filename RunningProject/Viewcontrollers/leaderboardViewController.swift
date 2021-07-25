//
//  leaderboardViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-29.
//

import UIKit
import MapKit
import CoreLocation

class leaderboardViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var savedCoords: [CLLocationCoordinate2D] = []
    var savedRoute: PreLoadRun!
    var routeName = ""
    
    var latitudes = [Double]()
    var longitudes = [Double]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        uploadRoute()
        setCorrectRoute()
        loadMap()
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "second_vc") as! secondViewController
        vc.latitudes = latitudes
        vc.longitudes = longitudes
        vc.importedPolyline = polyLine()
        
        navigationController?.pushViewController(vc, animated: true)
    
        
    }
    
    func switchTabItem(tt: Int){
        
        tabBarController?.selectedIndex = tt
        
    }
    
    
    func setCorrectRoute(){
        self.routeLabel.text = routeName
 
        
    }
    
    
    func uploadRoute(){
        let newRoute = PreLoadRun(context: preLoadCoreDataStack.secondContext)
        newRoute.distance = 400
        
          let locStat = PreLoadLocation(context: preLoadCoreDataStack.secondContext)
        
        for x in 0..<latitudes.count {
            locStat.latitude = latitudes[x]
            locStat.longitude = longitudes[x]
            newRoute.addToPreLoadLocations(locStat)
            
        }
        preLoadCoreDataStack.saveContext()
        savedRoute = newRoute
    }
    
    private func mapRegion() -> MKCoordinateRegion? {

        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
          
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let largerSpan = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
          
          
        return MKCoordinateRegion(center: center, span: largerSpan)
        
    }
    
    private func polyLine() -> MKPolyline {
        
        for x in 0..<latitudes.count {
            let lat = Double(latitudes[x])
            let lon = Double(longitudes[x])
            let destination = CLLocationCoordinate2DMake(lat, lon)

                savedCoords.append(destination)
        }
    
      return MKPolyline(coordinates: savedCoords, count: savedCoords.count)
    }
    
    private func loadMap() {
      guard
        let locations = savedRoute.preLoadLocations,
        locations.count > 0,
        let region = mapRegion()
      else {
          let alert = UIAlertController(title: "Error",
                                        message: "Sorry, this run has no locations saved",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel))
          present(alert, animated: true)
          return
      }
        
      mapView.setRegion(region, animated: true)
      mapView.addOverlay(polyLine())
      let startPin = MKPointAnnotation()
      let finishPin = MKPointAnnotation()
        startPin.coordinate.latitude = latitudes.first!
        startPin.coordinate.longitude = longitudes.first!
        finishPin.coordinate.latitude = latitudes.last!
        finishPin.coordinate.longitude = longitudes.last!

        mapView.addAnnotation(startPin)
        mapView.addAnnotation(finishPin)
       
 
    }
 
}


extension leaderboardViewController: MKMapViewDelegate {
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
