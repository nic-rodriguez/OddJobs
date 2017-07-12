//
//  PostViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

//TODO:  place autocomplete, tableView for tags, current date, image picker

import UIKit

class PostViewController: UIViewController,TagsTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var jobDescriptionField: UITextField!
    
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var payField: UITextField!
    
    @IBOutlet weak var jobDatePicker: UIDatePicker!
    
    @IBOutlet weak var jobImageView: UIImageView!
  
    @IBAction func addJobImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func closePostView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var jobDate: Date!
    var tags: [String] = []
    var currentDate: Date!
    var photoToPost: UIImage!
    var address: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    
    @IBAction func postJob(_ sender: UIButton) {
        jobTitle = jobTitleField.text!
        jobDescription = jobDescriptionField.text!
        address = addressField.text!
        pay = Double(payField.text!) ?? 0
        jobDate = jobDatePicker.date
        currentDate = Date()
        photoToPost = jobImageView.image
    
        
        Job.postJob(location: address, title: jobTitle, description: jobDescription, datePosted: currentDate, dateDue: jobDate, tags: self.tags, difficulty: 0, pay: pay, image: photoToPost , completion: { (success, error) in
            if success {
                print("Post was saved!")
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })
        
    }
    
    func createTags(tags: [String]) {
        self.tags = tags
    
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.jobImageView.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tagsViewController = segue.destination as! TagsTableViewController
        tagsViewController.delegate = self
    }
        


}
