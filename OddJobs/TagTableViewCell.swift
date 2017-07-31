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
    @IBOutlet weak var backgroundCard: UIView!
    
    let color = ColorObject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundCard.backgroundColor = color.myLightColor
        
        self.backgroundCard.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
