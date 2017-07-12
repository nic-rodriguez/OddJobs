//
//  PostViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

//TODO: GPS location, place autocomplete, tableView for tags

import UIKit

class PostViewController: UIViewController {

    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var jobDescriptionField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var payField: UITextField!
    
    @IBOutlet weak var jobDatePicker: UIDatePicker!
    
    
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var jobDate: Date
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    
    
    
    }
    

    
    @IBAction func postJob(_ sender: UIButton) {
        jobTitle = jobTitleField.text!
        jobDescription = jobDescriptionField.text!
        pay = Double(payField.text!) ?? 0
        jobDate = jobDatePicker.date
        
        
        
        
        Job.postJob(location: <#T##String#>, title: jobTitle, description: jobDescription, datePosted: <#T##Date#>, dateDue: jobDate, tags: <#T##[String]?#>, difficulty: 0, pay: pay, image: URL?, completion: { (success, error) in
            if success {
                print("Post was saved!")
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })

        
        
        }
        


}
