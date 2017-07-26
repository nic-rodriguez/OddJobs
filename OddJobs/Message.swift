//
//  Message.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/25/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class Message: NSObject {
    
    class func sendMessage(user: PFUser, chatRoom: PFObject, text: String, completion: PFBooleanResultBlock?) {
        let message = PFObject(className: "Message")
        var firstMessages = chatRoom["firstMessages"] as! [PFObject]
        var secondMessages = chatRoom["secondMessgaes"] as! [PFObject]
        
        message["text"] = text
        message["chatRoom"] = chatRoom
        
        if user == firstMessages[0] {
            firstMessages.append(message)
            chatRoom["firstMessages"] = firstMessages
        } else {
            secondMessages.append(message)
            chatRoom["secondMessages"] = secondMessages
        }
        
        message.saveInBackground(block: completion)
        chatRoom.saveInBackground(block: completion)
        
    }
}
