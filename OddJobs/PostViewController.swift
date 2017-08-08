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
  
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var descriptionTextView: RSKPlaceholderTextView!
    
    @IBOutlet var totalView: UIView!
    
    @IBOutlet weak var payField: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date!
    var moveView: Bool = false
    
    let color = ColorObject()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        backgroundImageView.backgroundColor = color.myTealColor
        
        
        backgroundView.backgroundColor = color.myLightColor
        self.backgroundView.layer.cornerRadius = 6.0
        self.backgroundView.layer.masksToBounds = false
        self.backgroundView.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundView.layer.shadowOpacity = 0.8
        
        
        nextButton.backgroundColor = color.myLightColor
        nextButton.layer.cornerRadius = 5.0
        nextButton.layer.masksToBounds = false
        nextButton.layer.shadowColor = color.myTealColor.cgColor
        nextButton.layer.shadowOpacity = 0.8
        nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = color.myRedColor.cgColor

        
        jobTitleField.setBottomBorder()
        
        
        let titlePlaceholder = NSAttributedString(string: "Enter Job Title", attributes: [NSForegroundColorAttributeName:UIColor.black.withAlphaComponent(0.6)])
        
        jobTitleField.attributedPlaceholder = titlePlaceholder
    
        
        descriptionTextView.backgroundColor = UIColor.black.withAlphaComponent(0.04)
        
        descriptionTextView.placeholder = "Add a description"
        
        payField.setBottomBorder()
        
        let payPlaceholder = NSAttributedString(string: "Estimated Pay ($)", attributes: [NSForegroundColorAttributeName:UIColor.black.withAlphaComponent(0.6)])
        
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
    
    
    @IBAction func nextButton(_ sender: UIButton) {
        let jobTitle = jobTitleField.text ?? nil
        let jobDescription = descriptionTextView.text
        let pay = Double(payField.text!) ?? nil
        
        if (jobTitle != nil) && (jobDescription != nil) && (pay != nil) {
            if (nextButton.isSelected) {
                nextButton.backgroundColor = color.myRedColor

            }
            self.performSegue(withIdentifier: "postPartTwoSegue", sender: UIBarButtonItem.self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Some or all of the required fields are incomplete. Please fill in the missing information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    @IBAction func fillJobTitle(_ sender: UIButton) {
        jobTitleField.text = "Build Table"
        
    }
  
    @IBAction func fillDescriptionTitle(_ sender: UIButton) {
        descriptionTextView.text = "I bought a table at IKEA and I can't put it together. Someone please do it for me. Would take about 1-2 hours. Thanks!"
        
    }
   
    @IBAction func fillPayField(_ sender: UIButton) {
        payField.text = "25"
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




