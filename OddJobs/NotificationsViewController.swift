//
//  NotificationsViewController.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/18/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationsTableView: UITableView!
    
    @IBOutlet weak var notificationControl: UISegmentedControl!
    
    @IBOutlet weak var headerView: UIView!
    

    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        switch notificationControl.selectedSegmentIndex
        {
        case 0:
            break
        case 1:
            break
            
        default:
            break
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.tableHeaderView = headerView

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        if notificationControl.selectedSegmentIndex == 0 {
            notificationsTableView.dequeueReusableCell(withIdentifier: "PendingJobsCell", for: indexPath) as! PendingJobsCell
        }
        
        return cell
        
    }

    
}
