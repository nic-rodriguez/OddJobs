//
//  FirstMessageViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/28/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import RSKPlaceholderTextView

class FirstMessageViewController: UIViewController {
    
    var chatRoom: PFObject!
    var job: PFObject!
    var didApply = false

    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var messageTextView: RSKPlaceholderTextView!
    
    let color = ColorObject()
    
    override func viewDidAppear(_ animated: Bool) {
        messageTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        backgroundView.backgroundColor = color.myLightColor
        self.backgroundView.layer.cornerRadius = 5.0
        self.backgroundView.layer.masksToBounds = false
        self.backgroundView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundView.layer.shadowOpacity = 0.8
    
        messageTextView.placeholder = "Send a message with your request"
    
           }
    
    override func viewWillDisappear(_ animated: Bool) {
        if didApply {
            let tab = self.presentingViewController as! UITabBarController
            let nav = tab.selectedViewController as! UINavigationController
            let vc = nav.topViewController as! DetailViewController
            vc.justApplied = true
        }
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
    
    
    @IBAction func fillMessageText(_ sender: UIButton) {
        
        messageTextView.text = "I'm SUPER great at building tables. I can save you from having to do this yourself!"
    }

    @IBAction func endEditting(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func sendPress(_ sender: Any) {
        var messages = chatRoom["messageArray"] as! [[String: String]]
        var userMessage = [String: String]()
        if let newMessage = messageTextView.text {
            userMessage[PFUser.current()!.username!] = newMessage
            messages.append(userMessage)
            chatRoom["messageArray"] = messages
            chatRoom.saveInBackground()
            savejobData()
            didApply = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        chatRoom.deleteInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("chatRoom deleted")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
