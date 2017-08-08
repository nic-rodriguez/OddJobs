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
    var protoCell: TopTableViewCell!
    
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsTableView.dataSource = self
        jobsTableView.delegate = self
        
        fetchJobs()
        
        protoCell = UINib(nibName: "customTopProfileTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TopTableViewCell
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        jobsTableView.insertSubview(refreshControl, at: 1)
        jobsTableView.backgroundColor = color.myTealColor
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
            
            cell.jobsPosterCounterLabel?.text = String(jobs.count)
            
            
            
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
            
            var tempUser: PFUser!
            
            if (user == nil) {
                tempUser = PFUser.current()
            } else {
                tempUser = user
            }
            
            protoCell.usernameLabel?.text = tempUser?.username!
            protoCell.ratingLabel?.text = tempUser["rating"] as? String ?? "0"
            protoCell.bioLabel?.text = tempUser["bio"] as? String ?? ""
            protoCell.jobsTakenCounterLabel?.text = tempUser["jobsTakenInt"] as? String ?? "0"
            
            protoCell.skillsLabel?.text = ""
            let skills = tempUser["skills"] as! [String]
            if skills.count != 0 {
                protoCell.skillsLabel?.text = "Skills: "
            }
            for (index, element) in skills.enumerated() {
                protoCell.skillsLabel?.text = (protoCell.skillsLabel?.text!)! + element
                if (index < skills.count - 1) {
                    protoCell.skillsLabel?.text = (protoCell.skillsLabel?.text!)! + ", "
                }
            }
            
            //insert size calculation like in the other cells
            let usernameLabelSize = protoCell.usernameLabel?.systemLayoutSizeFitting(CGSize(width: 343, height: CGFloat.leastNormalMagnitude))
            let ratingLableSize = protoCell.ratingLabel?.systemLayoutSizeFitting(CGSize(width: 343, height: CGFloat.leastNormalMagnitude))
            let bioLabelSize = protoCell.bioLabel?.systemLayoutSizeFitting(CGSize(width: 343, height: CGFloat.leastNormalMagnitude))
            let jobsTakenLabelSize = protoCell.jobsTakenCounterLabel?.systemLayoutSizeFitting(CGSize(width: 343, height: CGFloat.leastNormalMagnitude))
            let skillsLabelSize = protoCell.skillsLabel?.systemLayoutSizeFitting(CGSize(width: 416.5, height: CGFloat.leastNormalMagnitude))
            
            //343
            //replaced 343 with 416 in skills label bc aparently the label is longer than 343 (???)
            
            var addition: CGFloat = 0
            if(protoCell.bioLabel?.text == "") {
                //no height
            } else {
                let intthis = (bioLabelSize?.width)! / 343.0
                let roundedF = CGFloat(ceil(Double(intthis)))
                addition = addition + (bioLabelSize?.height)!*roundedF
//                print("in biolabel, #rows: ", intthis)
            }
            
            if(protoCell.skillsLabel?.text == "") {
                //no heigh
            } else {
//                print("skill label size: ", skillsLabelSize)
                let intthis = (skillsLabelSize?.width)! / 416.5
                let roundedF = CGFloat(ceil(Double(intthis)))
                addition = addition + (skillsLabelSize?.height)!*roundedF
//                print("in skillsLabel, #rows: ", intthis)
            }
            
//            print()
            addition = addition + (usernameLabelSize?.height)!
            addition = addition + (ratingLableSize?.height)!
            addition = addition + (jobsTakenLabelSize?.height)! + 50 + (8*8)
            //50 = prof pic ; 8 * 6 = spacing between everything
            
            height = addition
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
