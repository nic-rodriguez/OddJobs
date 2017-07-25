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

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TopTableViewDelegate, ProfileViewControllerDelegate {
    
    var user: PFUser!
    var jobs: [PFObject] = []
    var topCell: TopTableViewCell? = nil
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsTableView.dataSource = self
        jobsTableView.delegate = self
        
        fetchJobs()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        jobsTableView.insertSubview(refreshControl, at: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showDetailView") {
            let cell = sender as! UITableViewCell
            if let indexPath = jobsTableView.indexPath(for: cell) {
                let job = jobs[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.job = job
                jobsTableView.deselectRow(at: indexPath, animated: true)
            }
        } else if (segue.identifier == "editProfile") {
            let editProfileViewController = storyboard?.instantiateViewController(withIdentifier: "editProfileViewController") as! EditProfileViewController
            editProfileViewController.topCell = topCell
        }
    }
    
    
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
            cell.user = user
            topCell = cell
            topTableViewCell(topCell!)
            return cell
        } else { //job postings
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserJobsTableViewCell", for: indexPath) as! UserJobsTableViewCell
            cell.job = jobs[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        if indexPath.section == 0 {
            height = 300
        }
        else {
            height = 50
        }
        return height
    }
    
    
    func fetchJobs() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        if (user == nil) {
            query.whereKey("userPosted", equalTo: PFUser.current()!)
        } else {
            query.whereKey("userPosted", equalTo: user!)
        }
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
        jobsTableView.reloadData()
        if let topCell = topCell {
            topTableViewCell(topCell)
        }
        refreshControl.endRefreshing()
    }
    
    func topTableViewCell(_ topTableViewCell: TopTableViewCell) {
        topTableViewCell.loadData()
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
    
    
}
