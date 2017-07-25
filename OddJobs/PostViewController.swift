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
import GoogleMaps
import GooglePlacePicker
import Parse

class PostViewController: UIViewController {
   
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var jobTitleField: UITextField!
    @IBOutlet weak var jobDescriptionField: UITextField!
    @IBOutlet weak var payField: UITextField!
    @IBOutlet weak var jobDatePicker: UIDatePicker!
    @IBOutlet weak var jobImageView: UIImageView!
    @IBOutlet weak var enterAddress: UIButton!
    
    var resultsController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var jobDate: Date!
    var tags: [String] = []
    var currentDate: Date!
    var photoToPost: UIImage!
    var address: CLLocationCoordinate2D?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tagsViewController = segue.destination as! TagsTableViewController
        tagsViewController.delegate = self
    }
    
    @IBAction func addJobImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func closePostView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openGMS(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func endEditting(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func postJob(_ sender: UIButton) {
        print ("entered")
        jobTitle = jobTitleField.text!
        jobDescription = jobDescriptionField.text!
       
        pay = Double(payField.text!) ?? 0
        jobDate = jobDatePicker.date
        currentDate = Date()
        photoToPost = jobImageView.image
    
        if (pay != nil) && (jobDate != nil) && (currentDate != nil) && (photoToPost != nil) {
            Job.postJob(location: address!, title: jobTitle, description: jobDescription, datePosted: currentDate, dateDue: jobDate, tags: self.tags, difficulty: 0, pay: pay, image: photoToPost , completion: { (success, error) in
                if success {
                    print("Post was saved!")
                    self.dismiss(animated: true, completion: nil)
                } else if let error = error {
                    print("Problem saving message: \(error.localizedDescription)")
                }
            })
        } else {
            print("user tried to post an empty thing")
            let alert = UIAlertController(title: "Error", message: "Some or all of the required fields are incomplete. Please fill in the missing information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PostViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        address = place.coordinate
        addressLabel.text = place.formattedAddress!

        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension PostViewController: TagsTableViewControllerDelegate {
    
    func createTags(tags: [String]) {
        self.tags = tags
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        jobImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
}
