//
//  MessageTableViewCell.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/26/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit


class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    let color = ColorObject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundCard.backgroundColor = color.myLightColor
        self.backgroundCard.layer.cornerRadius = 3.0
        self.backgroundCard.layer.masksToBounds = false
        self.backgroundCard.layer.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        self.backgroundCard.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundCard.layer.shadowOpacity = 0.8
        
        contentView.backgroundColor = color.myTealColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
