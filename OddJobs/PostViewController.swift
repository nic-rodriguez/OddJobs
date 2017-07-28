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
  
    
    @IBOutlet weak var jobTitleField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var payField: UITextField!
    
    
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date!
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        jobTitleField.setBottomBorder()
        descriptionTextView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @IBAction func endEditting(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func closePostView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        
        
        let width = 1.0
    
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
        
        borderLine.backgroundColor = UIColor.white
        self.addSubview(borderLine)
    }
}

