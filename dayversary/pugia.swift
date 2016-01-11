//
//  pugia.swift
//  spleetter
//
//  Created by Marco Pugliese on 26/03/15.
//  Copyright (c) 2015 Marco Pugliese. All rights reserved.
//

import Foundation
import UIKit

class RGBAColor : UIColor {
    
    init(r:Int, g:Int, b:Int, a:Int) {
        
        let red = CGFloat(r)/255
        let green = CGFloat(g)/255
        let blue = CGFloat(b)/255
        let alpha = CGFloat(a)/100
        
        super.init(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }
    
}

class RGBColor : UIColor {
    
    init(r:Int, g:Int, b:Int) {
        
        let red = CGFloat(r)/255
        let green = CGFloat(g)/255
        let blue = CGFloat(b)/255
        
        super.init(red: red, green: green, blue: blue, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }
    
}


class HEXColor : RGBColor {
    
    init (hex:String) {
        
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        let hI: String.Index = cString.startIndex.advancedBy(1)
        let rI: String.Index = cString.startIndex.advancedBy(2)
        let gI: String.Index = cString.startIndex.advancedBy(4)
        
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(hI)
        }
        if (cString.characters.count != 6) {
            super.init(r: 100, g: 100, b: 100)
        } else {
            let rString = cString.substringToIndex(rI)
            let gString = cString.substringFromIndex(rI).substringToIndex(rI)
            let bString = cString.substringFromIndex(gI)
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
            NSScanner(string: rString).scanHexInt(&r)
            NSScanner(string: gString).scanHexInt(&g)
            NSScanner(string: bString).scanHexInt(&b)
            
            super.init(r: Int(r), g: Int(g), b: Int(b))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }
    
}

class sketchSize {
    
    let artboardWidth = 320
    let artboardHeight = 568
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    var ratioW:Double = 1
    var ratioH:Double = 1
    
    init() {
        
        ratioW = Double(self.screenWidth) / Double(self.artboardWidth)
        ratioH = Double(self.screenHeight) / Double(self.artboardHeight)
        
    }
    
    
    func rect(x x: Double, y:Double, width:Double, height:Double, preserveHeightRatio:Bool?=false, preserveYRatio:Bool?=false, fromBottom:Bool?=false) -> CGRect {
        
        var hh:Double = height * ratioW
        var yy:Double = y * ratioH
        
        if (preserveHeightRatio == nil || preserveHeightRatio! == false) {
            hh = height * ratioH
        }

        if ((preserveYRatio) != nil && preserveYRatio! == true) {
            yy = y * ratioW
        }

        if ((fromBottom) != nil && fromBottom! == true) {
            yy = Double(screenHeight) - hh - yy
        }
        
        return CGRect(x: x * ratioW, y: yy, width: width * ratioW, height: hh)
        
    }
    
    func rectFull() -> CGRect {
        return CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    }
    
    func sizeH(size: Int) -> CGFloat {
        
        return CGFloat(round(Double(size) * ratioH))
        
    }
    
    func sizeW(size: Int) -> CGFloat {
        
        return CGFloat(round(Double(size) * ratioW))
        
    }

}

class utility {
    
    func randomString(len:Int=8) -> String {
        
        var string:String = ""
        let a = Array(0x61...0x7A).map {String(UnicodeScalar($0))}
        for _ in 1...len {
            let cha = a[Int( arc4random()) % a.count]
            string += cha
        }
        
        return string
        
    }
        
}

/// Timeout wrapps a callback deferral that may be cancelled.
///
/// Usage:
/// Timeout(1.0) { println("1 second has passed.") }
///
class Timeout: NSObject
{
    private var timer: NSTimer?
    private var callback: (Void -> Void)?
    
    init(_ delaySeconds: Double, _ callback: Void -> Void)
    {
        super.init()
        self.callback = callback
        self.timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(delaySeconds),
            target: self, selector: "invoke", userInfo: nil, repeats: false)
    }
    
    func invoke()
    {
        self.callback?()
        // Discard callback and timer.
        self.callback = nil
        self.timer = nil
    }
    
    func cancel()
    {
        self.timer?.invalidate()
        self.timer = nil
    }
}

extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        print(data)
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            return try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}