//
//  NearbyWorkersViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/17/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import MapKit

class NearbyWorkersViewController: UIViewController {

    @IBOutlet weak var workersTableView: UITableView!
    
    var workers: [PFUser] = []
    var currentLocation: PFGeoPoint!
    let color = ColorObject()
    var protoCell: WorkersTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workersTableView.dataSource = self
        workersTableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (self.didPullToRefresh(_:)), for: .valueChanged)
        workersTableView.insertSubview(refreshControl, at: 0)
        
        queryNearbyUsers()
        
        workersTableView.rowHeight = UITableViewAutomaticDimension
        workersTableView.estimatedRowHeight = 100
        
        workersTableView.separatorStyle = .none
        workersTableView.backgroundColor = color.myTealColor
        
        protoCell = UINib(nibName: "customWorkerCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WorkersTableViewCell
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        workersTableView.reloadData()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        queryNearbyUsers()
        self.workersTableView.reloadData()
    
        refreshControl.endRefreshing()
    }
    
    func queryNearbyUsers() {
        //func can probably be changed since we're passing the currentLocation through using MapKit
        PFGeoPoint.geoPointForCurrentLocation(inBackground: { (geoPoint: PFGeoPoint!, error:Error?) in
            if geoPoint != nil {
                let geoPointLat = geoPoint.latitude
                let geoPointLong = geoPoint.longitude
                self.currentLocation = PFGeoPoint(latitude: geoPointLat, longitude: geoPointLong)
                
                let query: PFQuery = PFUser.query()!
                // Interested in locations near user.
                query.whereKey("homeLocation", nearGeoPoint:self.currentLocation, withinMiles: 40)
                // Limit what could be a lot of points.
                query.limit = 10
                // Final list of objects
                
                try! self.workers = query.findObjects() as! [PFUser]
                
                
                var count = 0
                var indexToRemove: Int?
                for worker in self.workers {
                    if worker.objectId == PFUser.current()!.objectId{
                        indexToRemove = count
                    }
                    count+=1
                }
                if indexToRemove != nil {
                    self.workers.remove(at: indexToRemove!)
                }
                self.workersTableView.reloadData()
                
            } else {
                print(error?.localizedDescription ?? "Error")
            }
        })

        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! WorkersTableViewCell
        if let indexPath = workersTableView.indexPath(for: cell) {
            let user = workers[indexPath.row]
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = user
            //just to hide the gear bar button item so it's only seen in other profiles
            profileViewController.editProfileButton.isEnabled = false
            profileViewController.editProfileButton.tintColor = UIColor.white
        }
    }
}

extension NearbyWorkersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = workersTableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath) as! WorkersTableViewCell
        cell.user = workers[indexPath.row]
        cell.currentUserLocation = self.currentLocation
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let worker = workers[indexPath.row]
        
        protoCell.nameLabel.text = worker.username
        protoCell.descriptionLabel.text = worker["bio"] as? String ?? ""
        protoCell.descriptionLabel.textColor = color.myRedColor
        protoCell.skillsLabel.text = ""
        
        
        let skills = worker["skills"] as! [String]
        if skills.count != 0 {
            protoCell.skillsLabel.text = "Skills: "
        }
        for (index, element) in skills.enumerated() {
            protoCell.skillsLabel.text = protoCell.skillsLabel.text! + element
            if (index < skills.count - 1) {
                protoCell.skillsLabel.text = protoCell.skillsLabel.text! + ", "
            }
        }
        
        let nameLabelSize = protoCell.nameLabel.systemLayoutSizeFitting(CGSize(width: 310, height: CGFloat.leastNormalMagnitude))

        let descriptionLabelSize = protoCell.descriptionLabel.systemLayoutSizeFitting(CGSize(width: 285.0, height: CGFloat.leastNormalMagnitude))
        
        
        let skillLabelSize = protoCell.skillsLabel.systemLayoutSizeFitting(CGSize(width: 343, height: CGFloat.leastNormalMagnitude))
        
        
        var additional: CGFloat = 0
        print("descripton")
        if (protoCell.descriptionLabel.text == "") {
            additional = additional + (37-16)
        } else if (descriptionLabelSize.width > 252.0) {
            additional = additional + 2*descriptionLabelSize.height
        } else {
            additional = additional + descriptionLabelSize.height
        }
        
        if (protoCell.skillsLabel.text == "") {
            additional = additional + (37-16)
        } else if (skillLabelSize.width > 310) {
            let intthis = skillLabelSize.width / 310
            let roundedF = CGFloat(ceil(Double(intthis)))
            additional = additional + skillLabelSize.height*roundedF
        } else {
            additional = additional + skillLabelSize.height
        }
        additional = additional + 4*8 + 16 + nameLabelSize.height
        return additional
    }

    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
//    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.text = self
//        label.sizeToFit()
//        
//        return label.frame.height
//    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

