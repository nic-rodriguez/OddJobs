//
//  TagsTableViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import Parse
import RSKPlaceholderTextView

protocol TagsTableViewControllerDelegate: class {
    func createTags(tags: [String])
}

class TagsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagsTableView: UITableView!
    weak var delegate: TagsTableViewControllerDelegate?
    
    
    var tags: [String] = ["Gardening", "Food", "Delivery", "Cleaning", "Pets", "Housework", "Caretaker", "Survey", "App Testing", "Logo Design", "Plumbing", "Sewing", "Dry Cleaning"]
    
    var jobDate: Date!
    var tagsToPass: [String] = []
    var address: CLLocationCoordinate2D?
    var formattedAddress: String!
    var jobTitle: String = ""
    var jobDescription: String = ""
    var pay: Double = 0
    var currentDate: Date!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tagsTableView.dataSource = self
        tagsTableView.delegate = self
        
        let backgroundImage = UIImage(named: "gradient1.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tagsTableView.backgroundView = imageView
        tagsTableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath) as! TagTableViewCell
        cell.tagLabel.text = tags[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tagsTableView.cellForRow(at: indexPath as IndexPath) as? TagTableViewCell {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                var count = -1
                for tag in tagsToPass {
                    count += 1
                    if tag == cell.tagLabel.text {
                        tagsToPass.remove(at: count)
                    }
                }
            }
            else{
                cell.accessoryType = .checkmark
                tagsToPass.append(tags[indexPath.row])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPostSegue" {
            let destination = segue.destination as! ConfirmPostViewController
            destination.jobTitle = jobTitle
            destination.jobDescription = jobDescription
            destination.pay = pay
            destination.address = address
            destination.formattedAddress = formattedAddress
            destination.jobDate = jobDate
            destination.tags = tagsToPass
            
            
        }
    }
    
    @IBAction func didSaveTags(_ sender: UIButton) {
        self.delegate?.createTags(tags: tagsToPass)
        
        if self.address != nil {
            self.performSegue(withIdentifier: "confirmPostSegue", sender: UIBarButtonItem.self)
            
        }
        
        //dismiss self?
//        dismiss(animated: true, completion: nil) //this is not the function we need
    }
    
}
