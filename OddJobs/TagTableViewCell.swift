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
        
    
        self.backgroundCard.layer.cornerRadius = 6.0
        self.backgroundCard.layer.masksToBounds = false
        self.backgroundCard.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundCard.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCard.layer.shadowOpacity = 0.8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
