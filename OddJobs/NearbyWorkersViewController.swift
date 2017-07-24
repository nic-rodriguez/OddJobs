//
//  NearbyWorkersViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/17/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import MapKit

class NearbyWorkersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var workersTableView: UITableView!
    
    var workers: [PFUser] = []
    
    var currentLocation: PFGeoPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workersTableView.dataSource = self
        workersTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector (self.didPullToRefresh(_:)), for: .valueChanged)
       
        workersTableView.insertSubview(refreshControl, at: 0)
        
        queryNearbyUsers()
        //Find a way to not include current user in nearby users
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userLocation = MKUserLocation()
        currentLocation = PFGeoPoint(location: userLocation.location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = workersTableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath) as! WorkersTableViewCell
        
        cell.user = workers[indexPath.row]
        cell.currentUserLocation = self.currentLocation
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workersTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        queryNearbyUsers()
        
        self.workersTableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    func queryNearbyUsers() {
        
        PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint!, error:Error?) in
            print("is running")
            if geoPoint != nil {
                let geoPointLat = geoPoint.latitude
                let geoPointLong = geoPoint.longitude
                self.currentLocation = PFGeoPoint(latitude: geoPointLat, longitude: geoPointLong)
                print(self.currentLocation)
            
                
                let query: PFQuery = PFUser.query()!
                // Interested in locations near user.
                query.whereKey("homeLocation", nearGeoPoint:self.currentLocation)
                // Limit what could be a lot of points.
                query.limit = 10
                // Final list of objects
                
                try! self.workers = query.findObjects() as! [PFUser]
                self.workersTableView.reloadData()
                
            } else{
                print(error?.localizedDescription ?? "Error")
            }
        })

        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! WorkersTableViewCell
        if let indexPath = workersTableView.indexPath(for: cell) {
            let user = workers[indexPath.row]
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = user
        }
    }
}
