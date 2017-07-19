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
        
        searchController.searchBar.scopeButtonTitles = ["All", "type", "year", "country"]
        //just a test thingy
        
        queryServer()
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return filteredJobs.count //eh?
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsRowTableViewCell
            print ("am i even doing anything")
            return cell
        } else {
            let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "HomeFeedTableViewCell", for: indexPath) as! HomeFeedTableViewCell
            
            //cell.job = filteredJobs[indexPath.row] //eh?
            if searchController.isActive && searchController.searchBar.text != "" {
                cell.job = filteredJobs[indexPath.row]
            } else {
                cell.job = jobs[indexPath.row]
            }
            return cell
        }
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
                self.filteredJobs = jobs! // eh?
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
                let job = filteredJobs[indexPath.row]
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
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredJobs = jobs.filter({ (job) -> Bool in
                let range = (job["title"] as! String).localizedLowercase.range(of: searchText.localizedLowercase)
                return range != nil
            })
            
            homeFeedTableView.reloadData()
        }
    }
}
