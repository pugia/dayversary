//
//  ScrollExternalCollectionViewCell.swift
//  dayversary
//
//  Created by Marco Pugliese on 31/05/15.
//  Copyright (c) 2015 Marco Pugliese. All rights reserved.
//

import Foundation
import UIKit

class ScrollExternalCollectionViewCell: UICollectionViewCell {
    
    let SK = sketchSize()
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = SK.rect(x: 10, y: 40, width: 118, height: 30)
        label.textAlignment = .Center
        label.font = UIFont(name:"RobotoCondensed-Regular", size: SK.sizeW(30))
        label.textColor = UIColor.whiteColor()
        
        label.layer.shadowOpacity = 1.0;
        label.layer.shadowRadius = 0.0;
        label.layer.shadowColor = UIColor.blackColor().CGColor;
        label.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}