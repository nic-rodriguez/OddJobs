//
//  PostViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

//TODO:  place autocomplete, tableView for tags, current date, image picker

import UIKit

class PostViewController: UIViewController,TagsTableViewControllerDelegate {

    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var jobDescriptionField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var payField: UITextField!
    
    @IBOutlet weak var jobDatePicker: UIDatePicker!
    
    
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var jobDate: Date!
    var tags: [String] = []
    
    
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
        
        
    
        
       /* Job.postJob(location: <#T##String#>, title: jobTitle, description: jobDescription, datePosted: <#T##Date#>, dateDue: jobDate, tags: self.tags, difficulty: 0, pay: pay, image: URL?, completion: { (success, error) in
            if success {
                print("Post was saved!")
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })
*/
        
        
        }
    
    func createTags(tags: [String]) {
        self.tags = tags
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tagsViewController = segue.destination as! TagsTableViewController
        tagsViewController.delegate = self
    }
        


}
