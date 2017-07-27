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
    var protoCell: TagsCollectionViewCell!
    
    
    weak var delegate1: TagsRowTableViewCellDelegate?
    
    var tags: [String] = ["Gardening", "Food", "Delivery", "Cleaning", "Pets", "Housework", "Caretaker", "Survey", "App Testing", "Logo Design", "Plumbing", "Sewing", "Dry Cleaning"]
    var cellSizes: [CGSize]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        protoCell = UINib(nibName: "nibCustomCollectionCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TagsCollectionViewCell
        
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // Sets up collection view of available tag filters
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        protoCell.filterTagButton.setTitle(tags[indexPath.row], for: .normal)
        
        var size = protoCell.systemLayoutSizeFitting(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.leastNormalMagnitude))
        size.width = size.width + 10
        
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCollectionViewCell
        
        cell.filterTagButton.setTitle(tags[indexPath.row], for: .normal)
        cell.filterTagButton.setTitle(tags[indexPath.row], for: .selected)
        
        cell.filterTagButton.setTitleColor(UIColor.blue, for: .normal)
        cell.filterTagButton.setTitleColor(UIColor.white, for: .selected)
        
//        cell.filterTagLabel.text = tags[indexPath.row] //as! String //also is invisible
//        cell.filterTagButton.sizeToFit()
        
        cell.positionInArr = indexPath.row
        cell.delegate = self
        
//        cell.filterTagButton.bounds.width = cell.filterTagLabel.intrinsicContentSize.width
        
//        var buttonFrame: CGRect = cell.filterTagButton.frame;
        
//        cell.filterTagButton.frame.width = 0.0
        
            
//            = //        cell.filterTagButton.frame = buttonFrame;
        
//        cell.filterTagButton.sizeThatFits(CGSize(width: cell.filterTagLabel.intrinsicContentSize.width, height: 20.0))
        
        
//        cell.filterTagButton.frame.size = CGSize.init(width: cell.filterTagLabel.intrinsicContentSize.width, height: 30.0)
        
            
            //CGRect.init(x: 0, y: 0, width: cell.filterTagLabel.intrinsicContentSize.width, height: cell.filterTagButton.bounds.height)

        
        
        
        
        
//        cell.filterTagButton.backgroundRect(forBounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: cell.filterTagLabel.intrinsicContentSize.width, height: 30)))
//        cell.filterTagButton.contentRect(forBounds: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: cell.filterTagLabel.intrinsicContentSize.width, height: 30)))
        
//        print(cell.filterTagLabel.intrinsicContentSize.width)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        NSLog("\(self), collectionView:layout:sizeForItemAtIndexPath")
//        return cellSizes[indexPath.item]
//    }

    
    func toggleTag(position: Int) {
        delegate1?.toggleTag1(position: position)
    }
    
}



