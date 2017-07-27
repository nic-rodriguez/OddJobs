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
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var chatRoom: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.queryChatRooms), userInfo: nil, repeats: true)
    }
    
    func queryChatRooms() {
        let query = PFQuery(className: "ChatRoom")
        let job = chatRoom["job"] as! PFObject
        let firstUser = chatRoom["firstUser"] as! PFUser
        let secondUser = chatRoom["secondUser"] as! PFUser
        query.whereKey("job", equalTo: job)
        query.whereKey("firstUser", equalTo: firstUser)
        query.whereKey("secondUser", equalTo: secondUser)
        
        query.findObjectsInBackground { (chatRooms: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.chatRoom = chatRooms![0]
                self.messageTableView.reloadData()
            }
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let messageText = messageTextField.text {
            var messages = chatRoom["messageArray"] as! [[String: String]]
            let messageArray = [PFUser.current()!.username! : messageText]
            messages.append(messageArray)
            chatRoom["messageArray"] = messages
            chatRoom.saveInBackground()
        }
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
