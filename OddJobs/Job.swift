//
//  Job.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import Parse

class Job: NSObject, MKAnnotation {
    
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
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, location: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = location
    }
    
    class func postJob(location: CLLocationCoordinate2D, title: String, description: String, datePosted: Date, dateDue: Date, tags: [String]?, difficulty: Int, pay: Double, image: UIImage?, completion: PFBooleanResultBlock?) {

        
        let job = PFObject(className: "Job")
        
        job["title"] = title
        job["latitude"] = location.latitude
        job["longitude"] = location.longitude
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
