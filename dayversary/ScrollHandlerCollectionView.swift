//
//  ScrollHandlerCollectionView.swift
//  dayversary
//
//  Created by Marco Pugliese on 31/05/15.
//  Copyright (c) 2015 Marco Pugliese. All rights reserved.
//

import Foundation
import UIKit

class ScrollHandlerCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    
    var data:Array<String>
    var callback: (Void -> Void)?

    private let cellWidth:Int = 138
    private let SK = sketchSize()
    private var cellIdentifier:String = "HandlerCell"
    private var ics:CGFloat = 0
    private var selected:Int = 1
    private var centerCollection:ScrollCenterCollectionView?
    private var externalCollection:ScrollExternalCollectionView?
    
    init(frame: CGRect, cellIdentifier:String="HandlerCell", elements:Array<String>, center:ScrollCenterCollectionView?=nil, external:ScrollExternalCollectionView?=nil) {
        
        self.cellIdentifier = cellIdentifier
        self.centerCollection = center
        self.externalCollection = external
        self.data = elements
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSize(width: SK.sizeW(self.cellWidth), height: frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.dataSource = self
        self.delegate = self
        self.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.alwaysBounceHorizontal = false
        self.showsHorizontalScrollIndicator = false
        self.canCancelContentTouches = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) 
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.ics = scrollView.contentOffset.x
        
        if (self.centerCollection != nil) {
            self.centerCollection?.contentOffset.x = self.ics + SK.sizeW(self.cellWidth)
        }
        
        if (self.externalCollection != nil) {
            self.externalCollection?.contentOffset.x = self.ics
        }
        
    }
        
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.ics = round(scrollView.contentOffset.x / SK.sizeW(self.cellWidth)) * SK.sizeW(self.cellWidth)
        self.blockPosition(scrollView)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.x == 0) {
            self.ics = round(scrollView.contentOffset.x / SK.sizeW(self.cellWidth)) * SK.sizeW(self.cellWidth)
            _ = Timeout(0.1) {
                self.blockPosition(scrollView)
            }
        }
    }
    
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        return true
    }
    
    func setCurrentElement(i:Int) {
        self.selected = i
        self.contentOffset.x = SK.sizeW(self.cellWidth) * CGFloat(i-1)
    }
    
    func getCurrentElement() -> Int {
        return self.selected
    }
    
    func blockPosition(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.1, animations: {
            scrollView.contentOffset.x = self.ics
        })
        _ = Timeout(0.1) {
            self.selected = Int(self.ics / self.SK.sizeW(self.cellWidth) + 1)
            self.callback?()
        }
    }
    
    
}