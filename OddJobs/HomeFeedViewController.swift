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

class HomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, TagsRowTableViewCellDelegate, CustomSearchControllerDelegate {

    @IBOutlet weak var homeFeedTableView: UITableView!
    
    var jobs: [PFObject] = []
    var filteredJobs: [PFObject] = []
    var selectedTags: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false]
    var tags: [String] = ["Gardening", "Food", "Delivery", "Cleaning", "Pets", "Housework", "Caretaker", "Survey", "App Testing", "Logo Design", "Plumbing", "Sewing", "Dry Cleaning"]
    
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    var customSearchController: CustomSearchController!
    var isMoreDataLoading = false
    let initialQueryTotal = 3
    var queryTotal = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeFeedTableView.dataSource = self
        homeFeedTableView.delegate = self
        configureCustomSearchController()
        definesPresentationContext = true
        queryServer()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        homeFeedTableView.insertSubview(refreshControl, at: 0)
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
            if shouldShowSearchResults {
                return filteredJobs.count
            } else {
                return jobs.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsRowTableViewCell
            cell.delegate1 = self
            return cell
        } else {
            let cell = homeFeedTableView.dequeueReusableCell(withIdentifier: "HomeFeedTableViewCell", for: indexPath) as! HomeFeedTableViewCell
            if shouldShowSearchResults {
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
        query.limit = queryTotal
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.isMoreDataLoading = false
                self.jobs = jobs!
                self.filteredJobs = jobs!
                self.homeFeedTableView.reloadData()
            }
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl!) {
        queryTotal = initialQueryTotal
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
            let cell = sender as! UITableViewCell
            if let indexPath = homeFeedTableView.indexPath(for: cell) {
                let job: PFObject
                if shouldShowSearchResults {
                    job = filteredJobs[indexPath.row]
                } else {
                    job = jobs[indexPath.row]
                }
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.job = job
                homeFeedTableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func toggleTag1(position: Int) {
        selectedTags[position] = !selectedTags[position]
        
        //WORK IN PROGRESS
        let query = PFQuery(className: "Job")
        query.addDescendingOrder("createdAt")
        query.includeKey("userPosted")
        query.includeKey("tags")
        query.limit = 8
        //creat an array that holds only marked true objects
        var selected: [String] = []
        for (index, element) in selectedTags.enumerated() {
            if (element) { //if this location holds true
                selected.append(tags[index])
            }
        }
        query.whereKey("tags", containsAllObjectsIn: selected)
        query.findObjectsInBackground { (jobs: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.jobs = jobs!
                self.filteredJobs = jobs!
                self.homeFeedTableView.reloadData()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            // Filter the data array
            filteredJobs = jobs.filter({ (job) -> Bool in
                let range = (job["title"] as! String).localizedLowercase.range(of: searchText.localizedLowercase)
                return (range != nil)
            })
            homeFeedTableView.reloadData()
        }
    }
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect.init(x: 0.0, y: 0.0, width: homeFeedTableView.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor.black)
        
        customSearchController.customSearchBar.placeholder = "Search in this awesome bar..."
        homeFeedTableView.tableHeaderView = customSearchController.customSearchBar
        customSearchController.customDelegate = self
    }
    
    func didStartSearching() {
        shouldShowSearchResults = true
        homeFeedTableView.reloadData()
    }
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
             homeFeedTableView.reloadData()
        }
    }
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        homeFeedTableView.reloadData()
    }
    func didChangeSearchText(searchText: String) {
        filteredJobs = jobs.filter({ (job) -> Bool in
            let range = (job["title"] as! String).localizedLowercase.range(of: searchText.localizedLowercase)
            return (range != nil)
        })
        // Reload the tableview.
        homeFeedTableView.reloadData()
    }
}

extension HomeFeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = homeFeedTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight-homeFeedTableView.bounds.size.height
            if scrollView.contentOffset.y > scrollOffsetThreshold && homeFeedTableView.isDragging {
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.startAnimating()
                spinner.hidesWhenStopped = true
                homeFeedTableView.tableFooterView = spinner
                isMoreDataLoading = true
                queryTotal += initialQueryTotal
                queryServer()
                spinner.stopAnimating()
            }
        }
    }
}
