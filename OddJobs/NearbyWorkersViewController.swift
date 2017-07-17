//
//  NearbyWorkersViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/17/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class NearbyWorkersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var workersTableView: UITableView!
    
    var workers: [PFUser]!
    
    var currentLocation: PFGeoPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workersTableView.dataSource = self
        workersTableView.delegate = self
        
        PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint!, error:Error?) in
            if geoPoint != nil {
                let geoPointLat = geoPoint.latitude
                let geoPointLong = geoPoint.longitude
                self.currentLocation = PFGeoPoint(latitude: geoPointLat, longitude: geoPointLong)
                print(self.currentLocation)
                print("is this printing")
                
                var query = PFQuery(className:"User")
                // Interested in locations near user.
                query.whereKey("location", nearGeoPoint:self.currentLocation)
                // Limit what could be a lot of points.
                query.limit = 10
                // Final list of objects
                self.workers = try! query.findObjects() as! [PFUser]
            }
            else{
                print(error?.localizedDescription ?? "Error")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = workersTableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath) as! WorkersTableViewCell
        
        
        return cell
    }
}
