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

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TopTableViewDelegate {
    
    var user: PFUser!
    var jobs: [PFObject] = []
    var topCell: TopTableViewCell? = nil
    let color = ColorObject()
    
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsTableView.dataSource = self
        jobsTableView.delegate = self
        
        fetchJobs()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        jobsTableView.insertSubview(refreshControl, at: 1)
        jobsTableView.backgroundColor = color.myRedColor
        jobsTableView.separatorStyle = .none
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            
            cell.topProfileCardView.backgroundColor = color.myLightColor
            cell.topProfileCardView.layer.cornerRadius = 3.0
            cell.topProfileCardView.layer.masksToBounds = false
            cell.topProfileCardView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
            cell.topProfileCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.topProfileCardView.layer.shadowOpacity = 0.4            
            
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
}
