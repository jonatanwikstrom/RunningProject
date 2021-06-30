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
  
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var savedCoords: [CLLocationCoordinate2D] = []
    var savedRoute: Run!
    
    var latitudes = [59.385358, 59.385529, 59.385704, 59.385835, 59.385889, 59.385911, 59.385923, 59.385900, 59.385900, 59.385824, 59.385704, 59.385529, 59.385398, 59.385201, 59.385081, 59.384950, 59.384829, 59.384687, 59.384578, 59.384578, 59.384622]
    
    var longitudes = [13.516556, 13.517200, 13.517909, 13.518617, 13.519390, 13.520421, 13.521315, 13.522352, 13.523167, 13.523876, 13.524155, 13.523898, 13.523232, 13.522437, 13.521428, 13.520591, 13.519732, 13.518723, 13.517993, 13.517220, 13.516382]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        uploadRoute()
        loadMap()
    }
    
    func uploadRoute(){
        let newRoute = Run(context: CoreDataStack.context)
        newRoute.distance = 400
        newRoute.duration = Int16(60)
        
          let locStat = Location(context: CoreDataStack.context)
        
        for x in 0..<latitudes.count {
            locStat.latitude = latitudes[x]
            locStat.longitude = longitudes[x]
            newRoute.addToLocations(locStat)
            
        }
        CoreDataStack.saveContext()
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
        let locations = savedRoute.locations,
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
