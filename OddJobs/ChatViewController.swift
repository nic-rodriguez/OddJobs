//
//  ChatViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/21/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import SendBirdSDK
import Parse

class ChatViewController: UIViewController {
    
    var userToChat: String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        
        SBDMain.initWithApplicationId("FFA1F857-A1D7-4B6C-877F-DD9B9C20EFC8")
        
        SBDMain.connect(withUserId: (currentUser?.username)!, completionHandler: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                
            } else {
                print("success in connecting")
                var userIds: [String] = [(currentUser?.username!)!, self.userToChat]
                
                SBDGroupChannel.createChannel(withUserIds: userIds, isDistinct: true) { (channel, error) in
                    if error != nil {
                        print("Error with chats!")
                        print(error?.localizedDescription)
                        
                    } else {
                        
                        
                        channel?.sendUserMessage("testing message", data: "", completionHandler: { (userMessage, error) in
                            if error != nil {
                                NSLog("Error: %@", error!)
                                return
                            }
                            
                            // ...
                        })
                    }
                    
                    
                }
            }
            
        })

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
