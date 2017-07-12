//
//  TagTableViewCell.swift
//  OddJobs
//
//  Created by Pavani Malli on 7/12/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

   
    @IBOutlet weak var tagLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
