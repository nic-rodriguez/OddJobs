//
//  NotificationsViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationsTableView: UITableView!
    
    @IBOutlet weak var notificationControl: UISegmentedControl!
    
    @IBOutlet weak var headerView: UIView!
    
    var usersInterestedCount = 0
    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        switch notificationControl.selectedSegmentIndex
        {
        case 0:
            break
        case 1:
            break
            
        default:
            break
            
        }
        
    }

    var jobsPosted: [PFObject] = []
    
    var jobsUserInterested: [PFObject] = []
    
    var totalUsersInterested: [PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.tableHeaderView = headerView
        notificationsTableView.rowHeight = 95
        
        fetchJobs()
        
        print("function running")
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalUsersInterested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.correspondingJob = jobsUserInterested[indexPath.row]
        
        cell.userInterested = totalUsersInterested[indexPath.row]
 
        if notificationControl.selectedSegmentIndex == 1 {
            notificationsTableView.dequeueReusableCell(withIdentifier: "PendingJobsCell", for: indexPath) as! PendingJobsCell
        }
        
        return cell
        
    }
    
    
    
    //Query jobs that user has posted and find if usersInterested is nil or not
    func fetchJobs() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        query.includeKey("usersInterested")
        
        query.whereKey("userPosted", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("saving jobs")
                self.jobsPosted = jobs!
                print(self.jobsPosted.count)
                self.notificationsTableView.reloadData()
                self.setData()
            }
        }

    }
    
    func setData() {
        print(jobsPosted.count)
        for job in jobsPosted {
            print ("iterating over")
            if job["usersInterested"] != nil {
                let usersInterested = job["usersInterested"] as! [PFUser]
                
                var counter = 0
                print (usersInterested.count)
                while (counter < usersInterested.count){
                    jobsUserInterested.append(job)
                    totalUsersInterested.append((usersInterested[counter]) as! PFUser)
                    counter += 1
                    print("appended")
                }
            }
            
            
        }
        
        self.notificationsTableView.reloadData()
        
        
    }
    
}
