//
//  ViewController.swift
//  dayversary
//
//  Created by Marco Pugliese on 29/05/15.
//  Copyright (c) 2015 Marco Pugliese. All rights reserved.
//

import Foundation
import UIKit

class DatePicker: UIViewController {
    
    /* PUBLIC */
    var date = NSDate()
    
    /* PRIVATE */
    private let SK = sketchSize()
    private let cellWidth:Int = 138
    
    private let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
    
    private var day:Int = 31
    private var days:Array<String> = []
    private var dayHandlerCollectionView: ScrollHandlerCollectionView!
    private var dayExternalCollectionView: ScrollExternalCollectionView!
    private var dayCenterCollectionView: ScrollCenterCollectionView!
    
    private var month:Int = 8
    private var months:Array<String> = []
    private var monthHandlerCollectionView: ScrollHandlerCollectionView!
    private var monthExternalCollectionView: ScrollExternalCollectionView!
    private var monthCenterCollectionView: ScrollCenterCollectionView!
    
    private var year:Int = 2009
    private var years:Array<String> = []
    private var yearHandlerCollectionView: ScrollHandlerCollectionView!
    private var yearExternalCollectionView: ScrollExternalCollectionView!
    private var yearCenterCollectionView: ScrollCenterCollectionView!
    
    private var resultLavel = UILabel()
    private var dayDiff:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let components = calendar!.components([.Year, .Month, .Day], fromDate: date)
        day = components.day
        month = components.month
        year = components.year
        
        layout()
        
    }
    
    func layout() {
        view.backgroundColor = HEXColor(hex: "5B5B5B")
        
        let navigator = UIView(frame: SK.rect(x: 0, y: 0, width: 320, height: 64))
        navigator.backgroundColor = HEXColor(hex: "3D3D3D")
        navigator.layer.shadowOpacity = 1.0;
        navigator.layer.shadowRadius = 3.0;
        navigator.layer.shadowColor = HEXColor(hex: "252525").CGColor;
        navigator.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        
        let title = UILabel(frame: SK.rect(x: 70, y: 30, width: 180, height: 24))
        title.text = "Pick a date"
        title.textAlignment = .Center
        title.font = UIFont(name:"RobotoCondensed-Regular", size: SK.sizeW(20))
        title.textColor = UIColor.whiteColor()
        navigator.addSubview(title)

        
        let navigatorCenter = UIView(frame: SK.rect(x: 91, y: 62, width: Double(self.cellWidth), height: 10))
        navigatorCenter.backgroundColor = navigator.backgroundColor
        
        let bkCenter = UIView(frame: SK.rect(x: 91, y: 64, width: Double(self.cellWidth), height: 310))
        bkCenter.backgroundColor = navigator.backgroundColor
        bkCenter.layer.shadowOpacity = 1.0;
        bkCenter.layer.shadowRadius = 3.0;
        bkCenter.layer.shadowColor = HEXColor(hex: "252525").CGColor;
        bkCenter.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        
        let gradientSx = UIImageView(frame: SK.rect(x: 0, y: 60, width: 76, height: 304))
        gradientSx.image = UIImage(named: "GradientSx")
        
        let gradientDx = UIImageView(frame: SK.rect(x: 244, y: 60, width: 76, height: 304))
        gradientDx.image = UIImage(named: "GradientDx")
        
        /* YEAR */
        popolateYears()
        yearExternalCollectionView = ScrollExternalCollectionView(frame: SK.rect(x: -47, y: 264, width: 414, height: 100), cellIdentifier: "ExternalCellYear", elements: years)
        yearCenterCollectionView = ScrollCenterCollectionView(frame: SK.rect(x: 91, y: 264, width: Double(self.cellWidth), height: 100), cellIdentifier: "CenterCellYear", elements: years)
        yearHandlerCollectionView = ScrollHandlerCollectionView(frame: yearExternalCollectionView.frame, cellIdentifier: "HandlerCellYear", elements: years, center: yearCenterCollectionView, external: yearExternalCollectionView)
        yearHandlerCollectionView.setCurrentElement(year)
        yearHandlerCollectionView.callback = callbackPicker
        
        /* MONTH */
        popolateMonths()
        monthExternalCollectionView = ScrollExternalCollectionView(frame: SK.rect(x: -47, y: 164, width: 414, height: 100), cellIdentifier: "ExternalCellMonth", elements: months)
        monthCenterCollectionView = ScrollCenterCollectionView(frame: SK.rect(x: 91, y: 164, width: Double(self.cellWidth), height: 100), cellIdentifier: "CenterCellMonth", elements: months)
        monthHandlerCollectionView = ScrollHandlerCollectionView(frame: monthExternalCollectionView.frame, cellIdentifier: "HandlerCellMonth", elements: months, center: monthCenterCollectionView, external: monthExternalCollectionView)
        monthHandlerCollectionView.setCurrentElement(month)
        monthHandlerCollectionView.callback = callbackPicker
        
        /* DAYS */
        popolateDays(year, m: month)
        dayExternalCollectionView = ScrollExternalCollectionView(frame: SK.rect(x: -47, y: 64, width: 414, height: 100), cellIdentifier: "ExternalCellDay", elements: days)
        dayCenterCollectionView = ScrollCenterCollectionView(frame: SK.rect(x: 91, y: 64, width: Double(self.cellWidth), height: 100), cellIdentifier: "CenterCellDay", elements: days)
        dayHandlerCollectionView = ScrollHandlerCollectionView(frame: dayExternalCollectionView.frame, cellIdentifier: "HandlerCellDay", elements: days, center: dayCenterCollectionView, external: dayExternalCollectionView)
        dayHandlerCollectionView.setCurrentElement(day)
        dayHandlerCollectionView.callback = callbackPicker
        
        
        let yearBottomLine = UIView(frame: SK.rect(x: 0, y: 363, width: 320, height: 2))
        yearBottomLine.backgroundColor = HEXColor(hex: "515151")
        let monthBottomLine = UIView(frame: SK.rect(x: 0, y: 263, width: 320, height: 2))
        monthBottomLine.backgroundColor = HEXColor(hex: "515151")
        let dayBottomLine = UIView(frame: SK.rect(x: 0, y: 163, width: 320, height: 2))
        dayBottomLine.backgroundColor = HEXColor(hex: "515151")
        view.addSubview(yearBottomLine)
        view.addSubview(monthBottomLine)
        view.addSubview(dayBottomLine)
        
        
        // BOTTOM
        let bkResult = UIView(frame: SK.rect(x: 0, y: 365, width: 320, height: 204))
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = SK.rect(x: 0, y: 0, width: 320, height: 109)
        let cor1 = HEXColor(hex: "5C9F17"), cor2 = HEXColor(hex: "82C83B")
        bkResult.backgroundColor = cor2
        let arrayColors = [cor1.CGColor, cor2.CGColor]
        
        gradient.colors = arrayColors
        bkResult.layer.insertSublayer(gradient, atIndex: 0)
        
        resultLavel.frame = SK.rect(x: 10, y: 400, width: 300, height: 40)
        resultLavel.textAlignment = .Center
        resultLavel.font = UIFont(name:"RobotoCondensed-Regular", size: SK.sizeW(30))
        resultLavel.textColor = UIColor.whiteColor()
        resultLavel.text = "It's today!"
        
        resultLavel.layer.shadowOpacity = 1.0;
        resultLavel.layer.shadowRadius = 0.0;
        resultLavel.layer.shadowColor = UIColor.blackColor().CGColor;
        resultLavel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        
        
        // POSIZIONO I LAYER
        view.addSubview(dayExternalCollectionView)
        view.addSubview(monthExternalCollectionView)
        view.addSubview(yearExternalCollectionView)
        view.addSubview(bkResult)
        view.addSubview(bkCenter)
        view.addSubview(dayCenterCollectionView)
        view.addSubview(monthCenterCollectionView)
        view.addSubview(yearCenterCollectionView)
        
        view.addSubview(gradientSx)
        view.addSubview(gradientDx)
        view.addSubview(navigator)
        view.addSubview(navigatorCenter)
        
        view.addSubview(dayHandlerCollectionView)
        view.addSubview(monthHandlerCollectionView)
        view.addSubview(yearHandlerCollectionView)
        
        view.addSubview(resultLavel)
        
    }
    
    func popolateYears() {
        years = []
        years.append("")
        for index in 1...3000 {
            years.append("\(index)")
        }
        years.append("")
    }
    
    func popolateMonths() {
        months = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""]
    }
    
    
    func popolateDays(y:Int, m:Int) {
        days = []
        days.append("")
        for index in 1...getMonthDays(y, m: m) {
            days.append("\(index)")
        }
        days.append("")
        
    }
    
    func getMonthDays(y:Int, m:Int) -> Int {
        let components = NSDateComponents()
        components.year = y
        components.month = m+1
        components.day = 0
        
        let date = calendar!.dateFromComponents(components)
        let components2 = calendar!.components([.Month, .Day], fromDate: date!)
        
        return components2.day
        
    }
    
    func callbackPicker() {
        year = yearHandlerCollectionView.getCurrentElement()
        month = monthHandlerCollectionView.getCurrentElement()
        day = dayHandlerCollectionView.getCurrentElement()
        
        let maxDay = getMonthDays(year, m: month)
        if (day > maxDay) {
            // Scrollo indietro il giorno
            self.dayHandlerCollectionView.contentOffset.x = CGFloat(maxDay-1) * self.SK.sizeW(self.cellWidth)
        }
        
        calculateDayDiff()
        
        self.popolateDays(self.year, m: self.month)
        self.dayHandlerCollectionView.data = self.days
        self.dayHandlerCollectionView.reloadData()
        self.dayExternalCollectionView.data = self.days
        self.dayExternalCollectionView.reloadData()
        self.dayCenterCollectionView.data = self.days
        self.dayCenterCollectionView.reloadData()
        
        
    }
    
    
    func calculateDayDiff() {
        
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        let date = calendar!.dateFromComponents(components)
        
        let nowComps = calendar!.components([.Year, .Month, .Day], fromDate: NSDate())
        nowComps.hour = components.hour
        nowComps.minute = components.minute
        nowComps.second = components.second
        let now = calendar!.dateFromComponents(nowComps)
        
        let hours = self.calendar!.components(.Hour, fromDate: date!, toDate: now!, options: []).hour
        dayDiff = Int(ceil(Double(hours)/24))
        if (dayDiff > 0) {
            resultLavel.text = "\(self.dayDiff) days have passed"
        } else if (dayDiff < 0) {
            resultLavel.text = "\(abs(self.dayDiff)) days missing"
        } else {
            resultLavel.text = "It's today!"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    
}

