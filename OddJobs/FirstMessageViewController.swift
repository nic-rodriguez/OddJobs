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
    
    override func viewWillDisappear(_ animated: Bool) {
        let tab = self.presentingViewController as! UITabBarController
        let nav = tab.selectedViewController as! UINavigationController
        let vc = nav.topViewController as! DetailViewController
        vc.justApplied = true
    }
    
    func savejobData() {
        let currentUser = PFUser.current()
        
        if self.job["usersInterested"] == nil {
            
            var usersInterested: [PFUser]! = []
            usersInterested.append(currentUser!)
            self.job["usersInterested"] = usersInterested!
            print("user saved!")
            self.job.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                self.saveUserData()
            })
        } else {
            var usersInterested = self.job["usersInterested"] as! [PFUser]
            usersInterested.append(currentUser!)
            self.job["usersInterested"] = usersInterested
            self.job.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
                self.saveUserData()
            })
        }
    }
    
    func saveUserData() {
        let currentUser = PFUser.current()
        
        if currentUser?["jobsInterested"] == nil {
            var jobsInterested: [PFObject] = []
            jobsInterested.append(self.job)
            currentUser?["jobsInterested"] = jobsInterested
            currentUser?.saveInBackground().continue({ (task: BFTask<NSNumber>) -> Any? in
               print("job sent")
                
            })
            
        } else {
            var jobsInterested = currentUser?["jobsInterested"] as! [PFObject]
            jobsInterested.append(self.job)
            currentUser?["jobsInterested"] = jobsInterested
            currentUser?.saveInBackground().continue({ (task: BFTask<NSNumber>) -> Any? in
                print("job sent")
            })
            print("saved interested job")
        }
        
    }
    

    
    @IBAction func sendPress(_ sender: Any) {
        var messages = chatRoom["messageArray"] as! [[String: String]]
        var userMessage = [String: String]()
        if let newMessage = messageTextField.text {
            userMessage[PFUser.current()!.username!] = newMessage
            messages.append(userMessage)
            chatRoom["messageArray"] = messages
            chatRoom.saveInBackground()
            savejobData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
