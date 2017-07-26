//
//  NotificationsViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var notificationControl: UISegmentedControl!
    @IBOutlet weak var headerView: UIView!
    
    var jobsPosted: [PFObject] = []
    var jobsUserInterested: [PFObject] = []
    var totalUsersInterested: [PFUser] = []
    var jobsInterested: [PFObject] = []
    var usersPosted: [PFUser] = []
    var chatRooms: [PFObject]?
    
    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        notificationsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.tableHeaderView = headerView
        notificationsTableView.rowHeight = 105
        
        fetchNotificationData()
        fetchPendingJobsData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        notificationsTableView.insertSubview(refreshControl, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageSegue" {
            let vc = segue.destination as! MessageViewController
            let cell = sender as! NotificationCell
            vc.chatRoom = cell.chatRoom!
        }
    }
    
    //Query jobs that user has posted and find if usersInterested is nil or not
    func fetchNotificationData() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        query.includeKey("usersInterested")
        query.includeKey("_User")
        query.whereKey("userPosted", equalTo: PFUser.current()!)
        
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("saving jobs")
                self.jobsPosted = jobs!
                self.notificationsTableView.reloadData()
                
                //explain this code block later
                for job in self.jobsPosted {
                    if job["usersInterested"] != nil {
                        let usersInterested = job["usersInterested"] as! [PFUser]
                        var counter = 0
                        while (counter < usersInterested.count) {
                            self.jobsUserInterested.append(job)
                            self.totalUsersInterested.append((usersInterested[counter]))
                            counter += 1
                        }
                    }
                }
                self.notificationsTableView.reloadData()
            }
        }
    }
    

    func fetchPendingJobsData() {
        let query = PFQuery(className: "_User")
        query.includeKey("jobsInterested")
        query.includeKey("_p_userPosted")
        query.includeKey("_User")
        query.includeKey("Job")
        query.includeKey("username")
         
        
        query.getObjectInBackground(withId: PFUser.current()!.objectId!) { (user: PFObject?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if user?["jobsInterested"] != nil {
                    self.jobsInterested = user?["jobsInterested"] as! [PFObject]
                    for job in self.jobsInterested{
                        self.usersPosted.append(job["userPosted"] as! PFUser)
                    }
                }
                self.notificationsTableView.reloadData()
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl!) {
        fetchNotificationData()
        fetchPendingJobsData()
        
        refreshControl.endRefreshing()
    }

}






extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            cell.correspondingJob = jobsUserInterested[indexPath.row]
            cell.userInterested = totalUsersInterested[indexPath.row]
            
            return cell
        } else {
            let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "PendingJobsCell", for: indexPath) as! PendingJobsCell
            if jobsInterested.count > 0 {
                cell.jobInterested = jobsInterested[indexPath.row]
                cell.userPosted = self.usersPosted[indexPath.row]
               
            }
            return cell
        }
        
    }
}

extension NotificationsViewController: NotificationCellDelegate {
    
    
    func queryChatRooms(notificationCell: NotificationCell, job: PFObject, firstUser: PFUser, secondUser: PFUser) {
        let query = PFQuery(className: "ChatRoom")
        query.whereKey("job", equalTo: job)
        query.whereKey("firstUser", containedIn: [firstUser, secondUser])
        query.whereKey("secondUser", containedIn: [firstUser, secondUser])
        query.findObjectsInBackground { (chatRooms: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if chatRooms! != [] {
                    notificationCell.chatRoom = chatRooms![0]
                    self.performSegue(withIdentifier: "messageSegue", sender: notificationCell)
                } else {
                    notificationCell.chatRoom = ChatRoom.createChatRoom(firstUser: firstUser, secondUser: secondUser, job: job, completion: { (success: Bool, error: Error?) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("chat room created")
                            self.performSegue(withIdentifier: "messageSegue", sender: notificationCell)
                        }
                    })
                }
            }
        }
    }
}
