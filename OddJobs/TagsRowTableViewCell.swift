//
//  TagsRowTableViewCell.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/19/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

protocol TagsRowTableViewCellDelegate: class {
    func toggleTag1(position: Int) 
}

class TagsRowTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, TagsCollectionViewCellDelegate {

    @IBOutlet weak var tagsCollectionView: UICollectionView!
    weak var delegate1: TagsRowTableViewCellDelegate?
    
    var tags: [String] = ["Gardening", "Food", "Delivery", "Cleaning", "Pets", "Housework", "Caretaker", "Survey", "App Testing", "Logo Design", "Plumbing", "Sewing", "Dry Cleaning"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagsCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCollectionViewCell
        cell.filterTagLabel.text = tags[indexPath.row]
        cell.positionInArr = indexPath.row
        cell.delegate = self //as? TagsCollectionViewCellDelegate
        return cell
    }
    
    func toggleTag(position: Int) {
        delegate1?.toggleTag1(position: position)
    }
    
}



