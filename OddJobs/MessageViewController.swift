//
//  MessageViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/25/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class MessageViewController: UIViewController {
    
    var chatRoom: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chatRoom!)
        // Do any additional setup after loading the view.
    }

}
