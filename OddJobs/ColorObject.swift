//
//  ColorObject.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/28/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit

class ColorObject: NSObject {
    
    var myDarkColor: UIColor!
    var myTealColor: UIColor!
    var myLightColor: UIColor!
    var myRedColor: UIColor!
    var myYellowColor: UIColor!

    
    override init() {
        self.myDarkColor = UIColor(red: 41/255.0, green: 47/255.0, blue: 54/255.0, alpha: 1.0)
        self.myTealColor = UIColor(red: 44/255.0, green: 170/255.0, blue: 192/255.0, alpha: 1.0)
        self.myLightColor = UIColor(red: 247/255.0, green: 255/255.0, blue: 247/255.0, alpha: 1.0)
        self.myRedColor = UIColor(red: 255/255.0 , green: 95/255.0, blue: 111/255.0, alpha: 1.0)
        self.myYellowColor = UIColor(red: 255/255.0, green: 230/255.0, blue: 109/255.0, alpha: 1.0)
    }
}
