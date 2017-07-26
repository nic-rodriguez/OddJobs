//
//  ChatRoom.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/25/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class ChatRoom: NSObject {
    
    class func createChatRoom(firstUser: PFUser, secondUser: PFUser, completion: PFBooleanResultBlock?) {
        //firstUser is the user that posted the job
        
        let chatRoom = PFObject(className: "ChatRoom")
        
        chatRoom["firstMessages"] = [firstUser]
        chatRoom["secondMessages"] = [secondUser]
        
        chatRoom.saveInBackground(block: completion)
    }
}
