//
//  Rating.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 8/1/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class Rating: NSObject {
    
    class func rateUser(userId: String, starRating: Int, message: String?, completion: PFBooleanResultBlock?) {
        
        let rating = PFObject(className: "Rating")
        
        rating["userId"] = userId
        rating["starRating"] = starRating
        rating["message"] = message ?? ""
        
        rating.saveInBackground(block: completion)
    }
    
}
