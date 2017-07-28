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
    
    @IBOutlet weak var filterTagButton: UIButton!
    let myColor = UIColor(red: 255/255.0 , green: 107/255.0, blue: 107/255.0, alpha: 1.0)

    
    var positionInArr: Int!
    weak var delegate:TagsCollectionViewCellDelegate?

    
    @IBAction func tagIsSelected(_ sender: UIButton) {
        //print("button pressed")
        sender.isSelected = !sender.isSelected
        
        
        if (filterTagButton.isSelected) {
            filterTagButton.backgroundColor = UIColor.white
        } else {
            filterTagButton.backgroundColor = myColor
        }
        
        
        delegate?.toggleTag(position: positionInArr)
    }

    
    
}


