//
//  SignUpViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/19/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class SignUpViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    
    var address: CLLocationCoordinate2D?
    var tags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagsSegue" {
            let tagsViewController = segue.destination as! TagsTableViewController
            tagsViewController.delegate = self
        }
    }
    
    @IBAction func createUserPress(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = userField.text
        
        let alertController = UIAlertController(title: "Error", message: "Error", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("User dismissed error")
        })
        alertController.addAction(okAction)
        
        if passField.text == confirmField.text {
            
            newUser.password = passField.text
            newUser["bio"] = bioField.text ?? ""
            newUser["profilePicture"] = Job.getPFFileFromImage(image: profileImageView.image) ?? NSNull()
            newUser["skills"] = tags
            
            if let address = address {
                
                newUser["homeLocation"] = PFGeoPoint(latitude: address.latitude, longitude: address.longitude)
                newUser.signUpInBackground { (success: Bool, error: Error?) in
                    
                    if let error = error {
                        print("Error: " + error.localizedDescription)
                        alertController.message = error.localizedDescription
                        self.present(alertController, animated: true)
                    } else {
                        print("User successfully signed up!")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                alertController.title = "You didn't enter a home address"
                alertController.message = "Please select a home address"
                present(alertController, animated: true)
            }
        } else {
            alertController.title = "Your passwords don't match"
            alertController.message = "Please re-type your password"
            present(alertController, animated: true)
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func addProfileImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addressSelection(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: GMSAutocompleteViewControllerDelegate {
    
    // handle user selection
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        address = place.coordinate
        addressLabel.text = place.formattedAddress!
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
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

extension SignUpViewController: TagsTableViewControllerDelegate {
    
    func createTags(tags: [String]) {
        self.tags = tags
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
}
