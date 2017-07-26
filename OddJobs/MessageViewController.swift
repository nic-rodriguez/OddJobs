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
    
    var chatRoom: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chatRoom!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let messageText = messageTextField.text {
            var messages = chatRoom!["messageArray"] as! [[String: String]]
            let messageArray = [PFUser.current()!.username! : messageText]
            messages.append(messageArray)
            chatRoom!["messageArray"] = messages
            chatRoom!.saveInBackground()
        }
    }

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
//        let user =
//        
//        cell.userLabel.text =
        
        return cell
    }
}
