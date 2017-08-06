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
    
    @IBOutlet weak var segmentedControlBackground: UIView!
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var notificationControl: UISegmentedControl!
    @IBOutlet weak var headerView: UIView!
    
    var jobsPosted: [PFObject] = []
    // posted cell
    var jobsUserInterested: [PFObject] = []
    var totalUsersInterested: [PFUser] = []
    // pending cell
    var jobsInterested: [PFObject] = []
    var usersPosted: [PFUser] = []
    
    var chatRooms: [PFObject]?
    let color = ColorObject()
    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        notificationsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.tableHeaderView = headerView
        notificationsTableView.rowHeight = 122
        notificationsTableView.backgroundColor = color.myTealColor
        notificationsTableView.separatorStyle = .none
        headerView.backgroundColor = color.myTealColor
    
        notificationControl.removeBorders()
        
        segmentedControlBackground.backgroundColor = color.myDarkColor
        segmentedControlBackground.layer.cornerRadius = 10.0
        segmentedControlBackground.layer.masksToBounds = true
        segmentedControlBackground.layer.borderWidth = 1.0
        segmentedControlBackground.layer.borderColor = color.myRedColor.cgColor
        
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
            vc.job = cell.correspondingJob
        } else if segue.identifier == "pendingMessageSegue" {
            let vc = segue.destination as! MessageViewController
            let cell = sender as! PendingJobsCell
            vc.chatRoom = cell.chatRoom!
            vc.job = cell.jobInterested
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
                self.jobsUserInterested = []
                self.totalUsersInterested = []
                for job in self.jobsPosted {
                    if job["usersInterested"] != nil {
                        let usersInterested = job["usersInterested"] as! [PFUser]
                        let usersDeclined = job["usersDeclined"] as? [String] ?? []
                        if job["userAccepted"] != nil {
                            let acceptedUser = job["userAccepted"] as! PFUser
                            for user in usersInterested {
                                if user.objectId! == acceptedUser.objectId! {
                                    self.jobsUserInterested.append(job)
                                    self.totalUsersInterested.append(user)
                                }
                            }
                        } else {
                            for user in usersInterested {
                                if !usersDeclined.contains(user.objectId!) {
                                    self.jobsUserInterested.append(job)
                                    self.totalUsersInterested.append(user)
                                }
                            }
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
                self.jobsInterested = []
                self.usersPosted = []
                if let interestedJobs = user?["jobsInterested"] as? [PFObject] {
                    for job in interestedJobs {
                        if let userAccepted = job["userAccepted"] as? PFUser {
                            if userAccepted.objectId! == PFUser.current()!.objectId! {
                                self.jobsInterested.append(job)
                                self.usersPosted.append(job["userPosted"] as! PFUser)
                            }
                        } else if let declinedUsers = job["usersDeclined"] as? [String] {
                            if !declinedUsers.contains(PFUser.current()!.objectId!) {
                                self.jobsInterested.append(job)
                                self.usersPosted.append(job["userPosted"] as! PFUser)
                            }
                        } else {
                            self.jobsInterested.append(job)
                            self.usersPosted.append(job["userPosted"] as! PFUser)
                        }
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
            cell.cellIndex = indexPath.row
            cell.correspondingJob = jobsUserInterested[indexPath.row]
            cell.userInterested = totalUsersInterested[indexPath.row]
            
            cell.declinedButton.layer.cornerRadius = 5.0
            cell.declinedButton.layer.masksToBounds = false
            cell.declinedButton.layer.borderWidth = 2
            cell.declinedButton.layer.borderColor = color.myRedColor.cgColor
            
            cell.acceptedButton.layer.cornerRadius = 5.0
            cell.acceptedButton.layer.masksToBounds = false
            cell.acceptedButton.layer.borderWidth = 2
            cell.acceptedButton.layer.borderColor = color.myRedColor.cgColor
            
            cell.acceptedButton.setTitleColor(color.myRedColor, for: .normal)
            cell.acceptedButton.setTitleColor(color.myLightColor, for: .selected)
            cell.declinedButton.setTitleColor(color.myRedColor, for: .normal)
            cell.declinedButton.setTitleColor(color.myLightColor, for: .selected)
            
            let userInterested = totalUsersInterested[indexPath.row]
            if let acceptedUser = jobsUserInterested[indexPath.row]["userAccepted"] as? PFUser {
                if acceptedUser.objectId! == userInterested.objectId! {
                    cell.acceptedButton.isSelected = true
                }
            } else {
                cell.acceptedButton.isSelected = false
            }
            
            if (cell.acceptedButton.isSelected) {
                cell.acceptedButton.backgroundColor = color.myRedColor
            } else {
                cell.acceptedButton.backgroundColor = color.myLightColor
            }
            
            if (cell.declinedButton.isSelected) {
                cell.declinedButton.backgroundColor = color.myRedColor
                cell.acceptedButton.setTitleColor(color.myLightColor, for: .disabled)
            } else {
                cell.declinedButton.backgroundColor = color.myLightColor
            }
            
            let backgroundView = UIView()
            let transparent = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
            backgroundView.backgroundColor = transparent
            cell.selectedBackgroundView = backgroundView
            
            return cell
        } else {
            let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "PendingJobsCell", for: indexPath) as! PendingJobsCell
            if jobsInterested.count > 0 {
                cell.jobInterested = jobsInterested[indexPath.row]
                cell.userPosted = self.usersPosted[indexPath.row]
               
            }
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
                }
            }
        }
    }
    
    func acceptUser(userInterested: PFUser, cellIndex: Int) {
        if let acceptedUser = jobsUserInterested[cellIndex]["userAccepted"] as? PFUser {
            if acceptedUser.objectId! == userInterested.objectId! {
                let alert = UIAlertController(title: "Whoops!", message: "You have already accepted this user to complete your task.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            jobsUserInterested[cellIndex]["userAccepted"] = userInterested
            var updatedJobs = [] as! [PFObject]
            var updatedUsers = [] as! [PFUser]
            for num in 0..<jobsUserInterested.count {
                if jobsUserInterested[num] == jobsUserInterested[cellIndex] {
                    if num == cellIndex {
                        updatedJobs.append(jobsUserInterested[num])
                        updatedUsers.append(totalUsersInterested[num])
                    }
                } else {
                    updatedJobs.append(jobsUserInterested[num])
                    updatedUsers.append(totalUsersInterested[num])
                }
            }
            jobsUserInterested = updatedJobs
            totalUsersInterested = updatedUsers
            notificationsTableView.reloadData()
            jobsUserInterested[cellIndex].saveInBackground().continue({ (task: BFTask<NSNumber>) -> Void in
                let alert = UIAlertController(title: "User accepted!", message: "You have accepted this user to complete your task. Please select the complete button when your task has been finished", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func declineUser(userInterested: PFUser, cellIndex: Int) {
        let currentJob = jobsUserInterested[cellIndex]
        if let acceptedUser = currentJob["userAccepted"] as? PFUser {
            if acceptedUser.objectId! == userInterested.objectId! {
                currentJob["userAccepted"] = NSNull()
            }
        }
        var usersDeclined = currentJob["usersDeclined"] as? [String] ?? []
        usersDeclined.append(totalUsersInterested[cellIndex].objectId!)
        currentJob["usersDeclined"] = usersDeclined
        var updatedJobs = [] as! [PFObject]
        var updatedUsers = [] as! [PFUser]
        for num in 0..<totalUsersInterested.count {
            if num != cellIndex {
                updatedJobs.append(jobsUserInterested[num])
                updatedUsers.append(totalUsersInterested[num])
            }
        }
        jobsUserInterested = updatedJobs
        totalUsersInterested = updatedUsers
        notificationsTableView.reloadData()
        currentJob.saveInBackground()
    }
}


extension NotificationsViewController: PendingJobsCellDelegate {
    func queryChatRooms(pendingCell: PendingJobsCell, job: PFObject, firstUser: PFUser, secondUser: PFUser) {
        let query = PFQuery(className: "ChatRoom")
        query.whereKey("job", equalTo: job)
        query.whereKey("firstUser", containedIn: [firstUser, secondUser])
        query.whereKey("secondUser", containedIn: [firstUser, secondUser])
        query.findObjectsInBackground { (chatRooms: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if chatRooms! != [] {
                    pendingCell.chatRoom = chatRooms![0]
                    self.performSegue(withIdentifier: "pendingMessageSegue", sender: pendingCell)
                }
            }
        }
    }
   
}

extension UISegmentedControl {
    func removeBorders() {
        let color = ColorObject()
        setBackgroundImage(imageWithColor(color: color.myLightColor), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color:color.myRedColor), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
