//
//  personalPageViewController.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-07-06.
//

import UIKit
import CoreData

class personalPageViewController: UIViewController{
    
    
    @IBOutlet weak var KSTimeLabel: UILabel!
    @IBOutlet weak var GHTimeLabel: UILabel!
    @IBOutlet weak var KRTimeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items = [Run]()
    
    struct RunningStats {

        var duration:Int16
        var distance:Double

    }
    
    var data:[RunningStats]=[RunningStats]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "statCell")
        checkForStats()
        tableView.reloadData()

    }
    
    func checkForStats(){
        
        do{
            self.items = try context.fetch(Run.fetchRequest())
        }
        catch{
            
        }
        for item in items {
            
            data.append(RunningStats(duration: item.duration, distance: item.distance))
            
        }
        }
    
    public func clearAllCoreData() {
        let entities = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
        
    }
    
    public func clearSelectedCoreData(_ num: IndexPath){
        items.remove(at: num.row)
        tableView.deleteRows(at: [num], with: .fade)

        let requestDel = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")
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

class myCustomCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
}



extension personalPageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath)
        
        let RunningStats = data[indexPath.row]
        //let task = fetchTaskAtIndexPath(indexPath)
            
       cell.textLabel!.text = "\(RunningStats.distance) meters       \(RunningStats.duration) seconds"


        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            clearSelectedCoreData(indexPath)

        }
        
    }

    
}

