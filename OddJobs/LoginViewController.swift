//
//  LoginViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/10/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogIn(_ sender: Any) {
        let username = userTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("Error: " + error.localizedDescription)
            } else {
                print("User successfully logged in!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)

            }
        }
        //add segue to next screen
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = userTextField.text
        newUser.password = passwordTextField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print("Error: " + error.localizedDescription)
            } else {
                print("User successfully signed up!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
        //add segue to next screen
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
