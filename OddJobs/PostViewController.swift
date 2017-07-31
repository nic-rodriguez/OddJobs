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
import RSKPlaceholderTextView

class PostViewController: UIViewController {
  
    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var descriptionTextView: RSKPlaceholderTextView!
    
    
    @IBOutlet weak var payField: UITextField!
    
    
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date!
    var moveView: Bool = false
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        jobTitleField.setBottomBorder()
        
    
        
        let titlePlaceholder = NSAttributedString(string: "Enter Job Title", attributes: [NSForegroundColorAttributeName:UIColor.white.withAlphaComponent(0.6)])
        
        jobTitleField.attributedPlaceholder = titlePlaceholder
    
        
        descriptionTextView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        descriptionTextView.placeholder = "Add a description"
        
        payField.setBottomBorder()
        
        let payPlaceholder = NSAttributedString(string: "Estimated Pay ($)", attributes: [NSForegroundColorAttributeName:UIColor.white.withAlphaComponent(0.6)])
        
        payField.attributedPlaceholder = payPlaceholder
        
        

      
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let postPartTwo = segue.destination as! PostPartTwoViewController
         postPartTwo.jobTitle = jobTitleField.text!
         postPartTwo.jobDescription = descriptionTextView.text
         postPartTwo.pay = Double(payField.text!)!
        
    }

    @IBAction func endEditting(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func closePostView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func nextPostPart(_ sender: Any) {
       
        let jobTitle = jobTitleField.text ?? nil
        let jobDescription = descriptionTextView.text
        let pay = Double(payField.text!) ?? nil
        
        if (jobTitle != nil) && (jobDescription != nil) && (pay != nil) {
            self.performSegue(withIdentifier: "postPartTwoSegue", sender: UIBarButtonItem.self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Some or all of the required fields are incomplete. Please fill in the missing information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            
        }
        
    }
   
    
    @IBAction func moveViewUp(_ sender: UITextField) {
        moveView = true
    }
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        if moveView == true {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if moveView == true {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
            moveView = false
        }
    }
}
    
    

}




