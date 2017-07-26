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
        print(chatRoom)
        var messageDict = chatRoom["messages"] as! [String : [PFObject]]
        var currentMessages = messageDict[user.username!]!
        
        message["text"] = text
        message["chatRoom"] = chatRoom
        
        currentMessages.append(message)
        messageDict[user.username!] = currentMessages
        print("dict \(messageDict)")
        chatRoom["messages"] = messageDict
        print("Room \(chatRoom)")
        message.saveInBackground(block: completion)
        chatRoom.saveInBackground(block: completion)
        
//        return chatRoom
        
    }
}
