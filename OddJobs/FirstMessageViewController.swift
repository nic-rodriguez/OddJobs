//
//  FirstMessageViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/28/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class FirstMessageViewController: UIViewController {
    
    var chatRoom: PFObject!
    var job: PFObject!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPress(_ sender: Any) {
        var messages = chatRoom["messageArray"] as! [[String: String]]
        var userMessage = [String: String]()
        if let newMessage = messageTextField.text {
            userMessage[PFUser.current()!.username!] = newMessage
            messages.append(userMessage)
            chatRoom["messageArray"] = messages
            chatRoom.saveInBackground()
        }
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
