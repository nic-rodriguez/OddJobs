//
//  NotificationsViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import SendBirdSDK

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, notificationCellDelegate {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    
    @IBOutlet weak var notificationControl: UISegmentedControl!
    
    @IBOutlet weak var headerView: UIView!
    
    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        notificationsTableView.reloadData()
    }
    
    var jobsPosted: [PFObject] = []
    
    var jobsUserInterested: [PFObject] = []
    
    var totalUsersInterested: [PFUser] = []
    
    var jobsInterested: [PFObject] = []
    
    var userToChat: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.tableHeaderView = headerView
        notificationsTableView.rowHeight = 105
        
        fetchNotificationData()
        fetchPendingJobsData()
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if notificationControl.selectedSegmentIndex == 0 {
            return totalUsersInterested.count
        } else {
        
        return jobsInterested.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if notificationControl.selectedSegmentIndex == 0 {
            let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
            
            cell.delegate = self
            
            cell.cellIndex = indexPath.row
            
            cell.correspondingJob = jobsUserInterested[indexPath.row]
            
            cell.userInterested = totalUsersInterested[indexPath.row]
            
            
            return cell
            
        } else {
            let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "PendingJobsCell", for: indexPath) as! PendingJobsCell
            
            
            if jobsInterested.count > 0 {
                cell.jobInterested = jobsInterested[indexPath.row]
            }
            return cell
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let chatViewController = segue.destination as! ChatViewController
            

        chatViewController.userToChat = self.userToChat
        
        
        
    }
    
    func callSegueFromCell(userID: String, cellIndex: Int) {
        self.userToChat = userID

    }
    
    
    
    //Query jobs that user has posted and find if usersInterested is nil or not
    func fetchNotificationData() {
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
                for job in self.jobsPosted {
                    print ("iterating over")
                    if job["usersInterested"] != nil {
                        let usersInterested = job["usersInterested"] as! [PFUser]
                        
                        var counter = 0
                        print (usersInterested.count)
                        while (counter < usersInterested.count){
                            self.jobsUserInterested.append(job)
                            self.totalUsersInterested.append((usersInterested[counter]) )
                            counter += 1
                            print("appended")
                        }
                    }
                    
                    
                }
                
                self.notificationsTableView.reloadData()
            }
        }
        
    }
    
    
    func fetchPendingJobsData() {
        let query: PFQuery = PFUser.query()!
        query.includeKey("jobsInterested")
        query.getObjectInBackground(withId: PFUser.current()!.objectId!) { (user: PFObject?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
                print("error here")
            } else {
                if user?["jobsInterested"] != nil{
                self.jobsInterested = user?["jobsInterested"] as! [PFObject]
                print("jobs interested")
                    print(self.jobsInterested.count) }
                self.notificationsTableView.reloadData()
                
            }

        }
        
    }
 
}
