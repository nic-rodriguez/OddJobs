//
//  HomeFeedViewController.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/11/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import Foundation

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var homeFeedTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var jobs: [PFObject] = []
    var filteredJobs: [PFObject] = []
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeFeedTableView.dataSource = self
        homeFeedTableView.delegate = self
        searchBar.delegate = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        homeFeedTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        queryServer()
        
        filteredJobs = jobs //eh?
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        homeFeedTableView.insertSubview(refreshControl, at: 0)
        
//        homeFeedTableView.estimatedRowHeight = 100
//        homeFeedTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJobs.count //eh?
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "HomeFeedTableViewCell", for: indexPath) as! HomeFeedTableViewCell
        
        cell.job = filteredJobs[indexPath.row] //eh?
        return cell
    }
    
    func queryServer() {
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        query.limit = 8
        
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.jobs = jobs!
                self.homeFeedTableView.reloadData()
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl!) {
        queryServer()
        refreshControl.endRefreshing()
    }
    
    @IBAction func didLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User logged out successfully")
                NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "showDetailViewFromFeed") {
            let cell = sender as! UITableViewCell //UserJobsTableViewCell
            if let indexPath = homeFeedTableView.indexPath(for: cell) {
                let job = jobs[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.job = job
                homeFeedTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
 
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredJobs = searchText.isEmpty ? data : data.filter { (item: [String: Any]) -> Bool in
//            // If dataItem matches the searchText, return true to include it
//            return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//            
//            //(item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
        
        filteredJobs = jobs.filter({ (job) -> Bool in
            let range = (job["title"] as! String).range(of: searchText)
            
            
            
            
            //rangeOfString(searchText, options:NSString.CompareOptions.CaseInsensitiveSearch)
            return range != nil
        })
        
        
        
        homeFeedTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredJobs = jobs.filter({ (job) -> Bool in
                let range = (job["title"] as! String).range(of: searchText)
                return range != nil
            })
            
            homeFeedTableView.reloadData()
        }
    }


}
