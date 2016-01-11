//
//  ScrollExternalCollectionView.swift
//  dayversary
//
//  Created by Marco Pugliese on 31/05/15.
//  Copyright (c) 2015 Marco Pugliese. All rights reserved.
//

import Foundation
import UIKit

class ScrollExternalCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    var data:Array<String>
    private let cellWidth:Int = 138
    private let SK = sketchSize()
    private var cellIdentifier:String = "ExternalCell"
    private var ics:CGFloat = 0

    init(frame: CGRect, cellIdentifier:String="ExternalCell", elements:Array<String>) {
        
        self.cellIdentifier = cellIdentifier
        self.data = elements
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSize(width: SK.sizeW(self.cellWidth), height: frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.dataSource = self
        self.delegate = self
        self.registerClass(ScrollExternalCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.alwaysBounceHorizontal = false
        self.showsHorizontalScrollIndicator = false
        self.scrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! ScrollExternalCollectionViewCell
        if (indexPath.item != 0 && indexPath.item != data.count-1) {
            cell.label.text = self.data[indexPath.item]
        } else {
            cell.label.text = ""
        }
        return cell
    }
    
}