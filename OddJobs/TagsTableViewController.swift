//
//  TagsTableViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

protocol TagsTableViewControllerDelegate: class {
    func createTags(tags: [String])
}

class TagsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tagsTableView: UITableView!
    weak var delegate: TagsTableViewControllerDelegate?
    
    var tagsToPass: [String] = []
    var tags: [String] = ["Gardening", "Food", "Delivery", "Cleaning", "Pets", "Housework", "Caretaker", "Survey", "App Testing", "Logo Design", "Plumbing", "Sewing", "Dry Cleaning"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagsTableView.dataSource = self
        tagsTableView.delegate = self
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
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    @IBAction func didSaveTags(_ sender: UIButton) {
        self.delegate?.createTags(tags: tagsToPass)
        print(tagsToPass)
        
        //dismiss self?
//        dismiss(animated: true, completion: nil) //this is not the function we need
    }
    
}
