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

class TagsRowTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TagsCollectionViewCellDelegate {
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    weak var delegate1: TagsRowTableViewCellDelegate?
    
    var tags: [String] = ["Gardening", "Food", "Delivery", "Cleaning", "Pets", "Housework", "Caretaker", "Survey", "App Testing", "Logo Design", "Plumbing", "Sewing", "Dry Cleaning"]
    var cellSizes: [CGSize]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagsCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // Sets up collection view of available tag filters
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCollectionViewCell
        
        cell.filterTagButton.setTitle(tags[indexPath.row], for: .normal)
        cell.filterTagButton.setTitle(tags[indexPath.row], for: .selected)
        
        cell.filterTagButton.setTitleColor(UIColor.blue, for: .normal)
        cell.filterTagButton.setTitleColor(UIColor.white, for: .selected)
        
        cell.filterTagLabel.text = tags[indexPath.row] //as! String
        
        cell.positionInArr = indexPath.row
        cell.delegate = self
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        NSLog("\(self), collectionView:layout:sizeForItemAtIndexPath")
        return cellSizes[indexPath.item]
    }

    
    func toggleTag(position: Int) {
        delegate1?.toggleTag1(position: position)
    }
    
}



