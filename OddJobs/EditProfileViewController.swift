//
//  EditProfileViewController.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/13/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditProfileViewController: UIViewController {

    let user = PFUser.current()
    
    @IBOutlet weak var backgroundProfilePFImage: PFImageView!
    @IBOutlet weak var profilePFImage: PFImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.text = user?.username
        if let bio = user?["bio"] {
            bioTextField.text = bio as! String
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //verify for things that havent been changed or filled in
        if let name = usernameTextField.text {
            user?.username = name
        }
        if let bio = bioTextField.text {
            user?["bio"] = bio
        }
        
        
        
        //refresh changes and apply them everywhere
        dismiss(animated: true, completion: nil)
    }
    
}
