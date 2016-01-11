//
//  ScrollCenterCollectionViewCell.swift
//  dayversary
//
//  Created by Marco Pugliese on 31/05/15.
//  Copyright (c) 2015 Marco Pugliese. All rights reserved.
//

import Foundation
import UIKit

class ScrollCenterCollectionViewCell: UICollectionViewCell {
    
    let SK = sketchSize()
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = SK.rect(x: 10, y: 20, width: 118, height: 60)
        label.textAlignment = .Center
        label.font = UIFont(name:"RobotoCondensed-Bold", size: SK.sizeW(55))
        label.textColor = HEXColor(hex: "82FF00")
        
        label.layer.shadowOpacity = 0.5;
        label.layer.shadowRadius = 0.0;
        label.layer.shadowColor = UIColor.blackColor().CGColor;
        label.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}