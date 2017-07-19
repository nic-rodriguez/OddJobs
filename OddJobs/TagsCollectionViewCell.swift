//
//  TagsCollectionViewCell.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/19/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

protocol TagsCollectionViewCellDelegate: class {
    func toggleTag(position: Int)
}

class TagsCollectionViewCell: UICollectionViewCell {
    
    var positionInArr: Int!
    weak var delegate:TagsCollectionViewCellDelegate?
    
    @IBOutlet weak var filterTagLabel: UILabel!
    
    @IBAction func tagIsSelected(_ sender: UIButton) {
        //print("button pressed")
        sender.isSelected = !sender.isSelected
        delegate?.toggleTag(position: positionInArr)
    }
    
}
