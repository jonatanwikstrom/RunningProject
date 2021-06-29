//
//  thirdViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-24.
//

import UIKit
import MapKit
import CoreLocation

class thirdViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var run: Run!
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        updateRun()
        
    }
    
    
    func updateRun(){
        
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
        let seconds = Int(run.duration)
        let formattedTime = FormatDisplay.time(seconds)
        
        distanceLabel.text = "Distance:  \(distance)"
        timeLabel.text = "Time:  \(formattedTime)"
        loadMap()

        
    }

    
    private func mapRegion() -> MKCoordinateRegion? {
      guard
        let locations = run.locations,
        locations.count > 0
      else {
        return nil
      }
    
      let latitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.latitude
      }
        
      let longitudes = locations.map { location -> Double in
        let location = location as! Location
        return location.longitude
      }
        
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
      guard let locations = run.locations else {
        return MKPolyline()
      }
     
      let coords: [CLLocationCoordinate2D] = locations.map { location in
        let location = location as! Location
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      }
    
      return MKPolyline(coordinates: coords, count: coords.count)
    }

    
    private func loadMap() {
      guard
        let locations = run.locations,
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

  extension thirdViewController: MKMapViewDelegate {
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

extension thirdViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
          if let lastLocation = locations.last {

            let region = MKCoordinateRegion(center: lastLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
          }
        }
    }
