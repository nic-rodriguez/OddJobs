//
//  ProfileViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: PFUser!
    var jobs: [PFObject] = []
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jobsTableView.dataSource = self
        jobsTableView.delegate = self
        
        // Do any additional setup after loading the view.
        jobsTableView.rowHeight = UITableViewAutomaticDimension
        jobsTableView.estimatedRowHeight = 100

        fetchJobs()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        jobsTableView.insertSubview(refreshControl, at: 1)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return 1
        } else {
            return jobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){ //profile
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopTableViewCell", for: indexPath) as! TopTableViewCell
            //cell.user = user                      //for now always will be current user
            return cell
        } else { //job postings
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserJobsTableViewCell", for: indexPath) as! UserJobsTableViewCell
            
            //jobsTableView.deselectRow(at: indexPath, animated: true)
            
            cell.job = jobs[indexPath.row]
            return cell
        }
    }
        
        
    func fetchJobs() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        query.limit = 8
        
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.jobs = jobs!
                self.jobsTableView.reloadData()
            }
        }
    }

    
    func refreshControlAction(_ refreshControl: UIRefreshControl!) {
        fetchJobs()
        refreshControl.endRefreshing()
    }

}
