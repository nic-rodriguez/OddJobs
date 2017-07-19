//
//  TagsCollectionViewCell.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/19/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var filterTagLabel: UILabel!
    
    @IBAction func tagIsSelected(_ sender: UIButton) {
        print("button pressed")
        sender.isSelected = !sender.isSelected
        
    }
    
}
