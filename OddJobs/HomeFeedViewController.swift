//
//  HomeFeedViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeFeedTableView: UITableView!
    
    var jobs: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeFeedTableView.dataSource = self
        homeFeedTableView.delegate = self
        
        queryServer()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        homeFeedTableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "HomeFeedTableViewCell", for: indexPath) as! HomeFeedTableViewCell
        
        cell.job = jobs[indexPath.row]
        return cell
    }
    
    func queryServer() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.jobs = jobs!
                self.homeFeedTableView.reloadData()
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl!) {
        queryServer()
        refreshControl.endRefreshing()
    }
    
    @IBAction func didLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User logged out successfully")
                NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
