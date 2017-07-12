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

    class func postJob(location: String, title: String, description: String, datePosted: Date, dateDue: Date, tags: [String]?, difficulty: Int, pay: Double, image: UIImage?, completion: PFBooleanResultBlock?) {
        
        let job = PFObject(className: "Job")
        
        job["location"] = location
        job["title"] = title
        job["description"] = description
        job["datePosted"] = datePosted
        job["dateDue"] = dateDue
        job["tags"] = tags
        job["difficulty"] = difficulty
        job["pay"] = pay
        job["image"] = getPFFileFromImage(image: image)
        job["userPosted"] = PFUser.current()
        job["isAvailable"] = true
        
        job.saveInBackground(block: completion)
        
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
