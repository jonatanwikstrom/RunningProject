//
//  leaderboardViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-06-29.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class leaderboardViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [Gubbholmen]()
    //var item2 = [KarlstadStadslopp]()
    //var KSitems = [Gubbholmen]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var savedCoords: [CLLocationCoordinate2D] = []
    var savedRoute: PreLoadRun!
    var routeName = ""
    
    var latitudes = [Double]()
    var longitudes = [Double]()

    struct compStats : Comparable {
        static func < (lhs: leaderboardViewController.compStats, rhs: leaderboardViewController.compStats) -> Bool {
            return lhs.duration < rhs.duration
        }

        var date:Date
        var duration:Int16
    }
    
    var data:[compStats]=[compStats]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        uploadRoute()
        setCorrectRoute()
        loadMap()

        //checkComp()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "statCell")
        checkForStats()
        tableView.reloadData()
    }
    
    /*func checkComp() {
        
        if routeName == "Gubbholmen"{
            items = [Gubbholmen]()
        }
        else if routeName == "Karlstad stadslopp"{
       
        }
        
    }*/
    
    @IBAction func acceptTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "second_vc") as! secondViewController
        vc.latitudes = latitudes
        vc.longitudes = longitudes
        //vc.importedPolyline = polyLine()
        
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
    
    func checkForStats(){
        
        
        do{
            self.items = try context.fetch(Gubbholmen.fetchRequest())
        }
        catch{
            
        }
        for item in items {
            
            data.append(compStats(date: item.timestamp!, duration: item.time))
        }
        
    }

    
    public func clearAllCoreData() {
        let entities = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
        
    }
    
    public func clearSelectedCoreData(_ num: IndexPath){
        items.remove(at: num.row)
        tableView.deleteRows(at: [num], with: .fade)

        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Gubbholmen")
        requestDel.returnsObjectsAsFaults = false

        do {
            let arrUsrObj = try context.fetch(requestDel)
            let objectUpdate = arrUsrObj as! [NSManagedObject]
                context.delete(objectUpdate[num.row])

        } catch {
            print("Failed")
        }

        do {
            try context.save()
            print("deleted")

        } catch {
            print("Failed saving")
        }
        
    }

    private func clearDeepObjectEntity(_ entity: String) {
       
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
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

extension leaderboardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath)

        let data = data.sorted()
        let compStats = data[indexPath.row]
            
        cell.textLabel!.text = "\(compStats.date) date \(compStats.duration) seconds"


        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            clearSelectedCoreData(indexPath)

        }
        
    }

    
}

