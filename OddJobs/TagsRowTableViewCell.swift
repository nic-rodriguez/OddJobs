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
    
    let myFont = UIFont(name: "Helvetica", size: 12)
    let myColor = UIColor(red: 255/255.0 , green: 107/255.0, blue: 107/255.0, alpha: 1.0)
    let color = ColorObject()
    
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
        protoCell.filterTagButton.titleLabel?.font = myFont
        
        var size = protoCell.systemLayoutSizeFitting(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.leastNormalMagnitude))
        size.width = size.width + 10
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCollectionViewCell
        
        cell.filterTagButton.setTitle(tags[indexPath.row], for: .normal)
        cell.filterTagButton.setTitle(tags[indexPath.row], for: .selected)
        
        cell.filterTagButton.setTitleColor(color.myLightColor, for: .normal)
        cell.filterTagButton.setTitleColor(color.myRedColor, for: .selected)
        
        cell.filterTagButton.titleLabel?.font = myFont
        
        self.contentView.backgroundColor = color.myRedColor
        cell.filterTagButton.layer.cornerRadius = 5.0
        cell.filterTagButton.layer.masksToBounds = false
        cell.filterTagButton.layer.shadowColor = myColor.cgColor
        cell.filterTagButton.layer.shadowOpacity = 0.8
        
        cell.filterTagButton.layer.borderWidth = 2
        cell.filterTagButton.layer.borderColor = color.myLightColor.cgColor
        
        cell.positionInArr = indexPath.row
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func toggleTag(position: Int) {
        delegate1?.toggleTag1(position: position)
    }
    
}



