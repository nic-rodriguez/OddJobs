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

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    
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
            
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    print("Error: " + error.localizedDescription)
                } else {
                    print("User successfully signed up!")
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = originalImage
        dismiss(animated: true, completion: nil)
    }
}
