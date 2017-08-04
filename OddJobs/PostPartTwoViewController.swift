//
//  PostPartTwoViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/28/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import Parse

class PostPartTwoViewController: UIViewController {

    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var enterAddressField: UITextField!
    
    @IBOutlet weak var addressPreviewLabel: UILabel!
    
    @IBOutlet var totalView: UIView!
    
    @IBOutlet weak var dateTimeLabel: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var resultsController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var jobDate: Date!
    var address: CLLocationCoordinate2D?
    var formattedAddress: String!
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date!
    
    let color = ColorObject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterAddressField.setBottomBorder()
        
         backgroundImageView.backgroundColor = color.myTealColor
        
        addressPreviewLabel.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        let addressPlaceholder = NSAttributedString(string: "Enter Job Location", attributes: [NSForegroundColorAttributeName:UIColor.white.withAlphaComponent(0.6)])
        
        enterAddressField.attributedPlaceholder = addressPlaceholder
        
        dateTimeLabel.setBottomBorder()
        
        dateTimeLabel.isUserInteractionEnabled = false
        
        let datePlaceholder = NSAttributedString(string: "Estimated Date & Time", attributes: [NSForegroundColorAttributeName:UIColor.white.withAlphaComponent(0.6)])
        
        dateTimeLabel.attributedPlaceholder = datePlaceholder
        
        
        datePickerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        jobDate = datePicker.date
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    @IBAction func openGMS(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TagsTableViewController
        destination.jobTitle = jobTitle
        destination.jobDescription = jobDescription
        destination.pay = pay
        destination.address = address
        destination.formattedAddress = formattedAddress
        destination.jobDate = jobDate
        
        
    }
    
    
    @IBAction func openTags(_ sender: UIBarButtonItem) {
        if (self.address != nil) {
            self.performSegue(withIdentifier: "jobTagsSegue", sender: UIBarButtonItem.self)
        } else {
            let alert = UIAlertController(title: "Error", message: "Some or all of the required fields are incomplete. Please fill in the missing information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    
}

extension PostPartTwoViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        address = place.coordinate
        formattedAddress = place.formattedAddress!
        addressPreviewLabel.text = place.formattedAddress!
        
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



extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        
        
        let width = 1.0
        
        let color = ColorObject()
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
        
        borderLine.backgroundColor = UIColor.white
        self.addSubview(borderLine)
    }
}
