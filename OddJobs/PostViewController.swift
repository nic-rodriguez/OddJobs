//
//  PostViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

//TODO:  place autocomplete, tableView for tags, current date, image picker

import UIKit
import GooglePlaces

class PostViewController: UIViewController,TagsTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {
   
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var jobDescriptionField: UITextField!
    
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
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
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
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController as? UISearchResultsUpdating
        
        let subView = UIView(frame: CGRect(x: 20, y: 290, width: 330.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Enter Address"
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
         print("are predictions working")
        
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }

    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    
    }
    

    
    @IBAction func postJob(_ sender: UIButton) {
        jobTitle = jobTitleField.text!
        jobDescription = jobDescriptionField.text!
       
        pay = Double(payField.text!) ?? 0
        jobDate = jobDatePicker.date
        currentDate = Date()
        photoToPost = jobImageView.image
    
        
      /*  Job.postJob(location: address, title: jobTitle, description: jobDescription, datePosted: currentDate, dateDue: jobDate, tags: self.tags, difficulty: 0, pay: pay, image: photoToPost , completion: { (success, error) in
            if success {
                print("Post was saved!")
                
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        })*/
        
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


