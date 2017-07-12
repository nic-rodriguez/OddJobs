//
//  Job.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class Job: NSObject {
    
//    var location: String
//    var title: String
//    var description: String
//    var datePosted: Date
//    var dateDue: Date
//    var tags: [String]?
//    var difficulty: Int
//    var pay: Double
//    var image: URL?
//    var available: Bool
//    var userWhoPosted: PFUser
    
//    private var userAccepted: User?
//    private var usersInterested: [User]?
//    private var id: Int64
    
    /* important user vars
     
     initialize user vars with user["location"] syntax
     reference Instagram for example code/syntax
     
     location: String //Google maps type
     name: String
     username: String
     bio: String?
     profilePic: URL?
     jobsTaken: [Job]?
     jobsPosted: [Job]?
     currentJob: Job?
     rating: Double
     bookmarkedUsers: [PFUser: Bool]?
     tags: [String]?
    */
    
//    init (dictionary: [String: Any]) {
//        location = dictionary["location"] as! String
//        title = dictionary["title"] as! String
//        description = dictionary["description"] as! String
//        datePosted = dictionary["datePosted"] as! Date
//        dateDue = dictionary["dateDue"] as! Date
//        tags = dictionary["tags"] as! [String]
//        difficulty = dictionary["difficulty"] as! Int
//        pay = dictionary["pay"] as! Double
//        image = dictionary["image"] as! URL
//        userWhoPosted = dictionary["userPosted"] as! PFUser
//        
//        //available = dictionary["isAvailable"]
//        
//    }
    
    class func postJob(location: String, title: String, description: String, datePosted: Date, dateDue: Date, tags: [String]?, difficulty: Int, pay: Double, image: URL?, completion: PFBooleanResultBlock?) {
        
        let job = PFObject(className: "Job")
        
        job["location"] = location
        job["title"] = title
        job["description"] = description
        job["datePosted"] = datePosted
        job["dateDue"] = dateDue
        job["tags"] = tags
        job["difficulty"] = difficulty
        job["pay"] = pay
        job["image"] = image
        job["userPosted"] = PFUser.current()
        job["isAvailable"] = true
        
    }
}
