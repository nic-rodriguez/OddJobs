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

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TagsTableViewControllerDelegate {

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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUserPress(_ sender: Any) {
        let newUser = PFUser()

        newUser.username = userField.text
        if passField.text == confirmField.text {
            newUser.password = passField.text
            newUser["bio"] = bioField.text ?? ""
            newUser["profilePicture"] = Job.getPFFileFromImage(image: profileImageView.image)
            newUser["skills"] = tags
            
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print("Error: " + error.localizedDescription)
                } else {
                    print("User successfully signed up!")
                    self.dismiss(animated: true, completion: nil)
//                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }

        } else {
            // raise alert controller
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createTags(tags: [String]) {
        self.tags = tags
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagsSegue" {
            let tagsViewController = segue.destination as! TagsTableViewController
            tagsViewController.delegate = self
            
        }
    }
}



extension SignUpViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        address = place.coordinate
        addressLabel.text = place.formattedAddress!
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
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
