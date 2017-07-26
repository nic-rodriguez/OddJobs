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
