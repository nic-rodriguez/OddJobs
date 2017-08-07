//
//  MessageViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/25/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class MessageViewController: UIViewController {
    
 
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var chatRoom: PFObject!
    var job: PFObject!
    var poster: Bool?
    var completeTimer: Timer?
    
    let color = ColorObject()

    override func viewDidAppear(_ animated: Bool) {
        messageTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTableView.backgroundColor = color.myTealColor
        messageTableView.separatorStyle = .none
        
        self.messageTableView.estimatedRowHeight = 50 // Always do slightly more than the average row height
        self.messageTableView.rowHeight = UITableViewAutomaticDimension
        
        messageButton.layer.cornerRadius = 5.0
        messageButton.layer.masksToBounds = true
        messageButton.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        messageButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        messageButton.layer.shadowOpacity = 0.4
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryChatRooms), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ratingSegue" {
            let vc = segue.destination as! RatingViewController
            vc.job = job
            if poster! {
                vc.user = job["userAccepted"] as! PFUser
            } else {
                vc.user = job["userPosted"] as! PFUser
            }
            
        }
    }
    
    func queryChatRooms() {
        let query = PFQuery(className: "ChatRoom")
        let job = chatRoom["job"] as! PFObject
        let firstUser = chatRoom["firstUser"] as! PFUser
        let secondUser = chatRoom["secondUser"] as! PFUser
        query.whereKey("job", equalTo: job)
        query.whereKey("firstUser", containedIn: [firstUser, secondUser])
        query.whereKey("secondUser", containedIn: [firstUser, secondUser])
        
        query.findObjectsInBackground { (chatRooms: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.chatRoom = chatRooms![0]
                self.messageTableView.reloadData()
            }
        }
    }
    
    func queryJobs() {
        let query = PFQuery(className: "Job")
        let id = job.objectId!
        query.getObjectInBackground(withId: id) { (job: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.job = job
                let posterBool = self.job["posterCompleted"] as? Bool
                let workerBool = self.job["workerCompleted"] as? Bool
                
                if posterBool == true && workerBool == true {
                    self.stopCompleteTimer()
                    self.performSegue(withIdentifier: "ratingSegue", sender: nil)
                }
            }
        }
    }
    
    func startCompleteTimer() {
        if completeTimer == nil {
            completeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryJobs), userInfo: nil, repeats: true)
        }
    }
    
    func stopCompleteTimer() {
        if completeTimer != nil {
            completeTimer!.invalidate()
            completeTimer = nil
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let messageText = messageTextField.text {
            var messages = chatRoom["messageArray"] as! [[String: String]]
            let messageArray = [PFUser.current()!.username! : messageText]
            messages.append(messageArray)
            chatRoom["messageArray"] = messages
            chatRoom.saveInBackground()
            messageTextField.text = nil
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func completeJob(_ sender: Any) {
        let jobPoster = job["userPosted"] as! PFUser
        let jobWorker = job["userAccepted"] as! PFUser
        if PFUser.current()!.objectId! == jobPoster.objectId! {
            poster = true
            job["posterCompleted"] = true
            job.saveInBackground()
        } else if PFUser.current()!.objectId! == jobWorker.objectId! {
            poster = false
            job["workerCompleted"] = true
            job.saveInBackground()
        }
        
        startCompleteTimer()
        
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messages = chatRoom["messageArray"] as! [[String : String]]
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        let messages = chatRoom["messageArray"] as! [[String : String]]
        let message = messages[indexPath.row]
        cell.userLabel.text = message.first!.key
        cell.messageLabel.text = message.first!.value
        
        
        return cell
    }
}
