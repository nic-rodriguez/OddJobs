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
    
    class func createChatRoom(firstUser: PFUser, secondUser: PFUser, job: PFObject, completion: PFBooleanResultBlock?) -> PFObject {
        //firstUser is the user that posted the job
        
        let chatRoom = PFObject(className: "ChatRoom")
        var messageDict = [String: [PFObject]]()
        messageDict[firstUser.username!] = []
        messageDict[secondUser.username!] = []
        chatRoom["messages"] = messageDict
        chatRoom["job"] = job
        chatRoom.saveInBackground(block: completion)
        
        return chatRoom
    }
}
