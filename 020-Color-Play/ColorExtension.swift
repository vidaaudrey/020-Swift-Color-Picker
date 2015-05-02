//
//  ColorExtension.swift
//  010-Swift-Material-Design-Color-Kit
//
//  Created by Audrey Li on 3/27/15.
//  Copyright (c) 2015 UIColle. All rights reserved.
//

import Foundation

import Foundation

#if os(iOS)
    import UIKit
   public typealias Color = UIColor
    #else
    import Cocoa
    public typealias Color = NSColor
#endif

public typealias RGBA = UInt

public extension Color {
    
    public var rgbaValues: (CGFloat, CGFloat, CGFloat,CGFloat) {
        var rgba = [CGFloat](count:4, repeatedValue: 0)
        self.getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])
        return (rgba[0], rgba[1], rgba[1], rgba[3])
    }

    public var hsbaValues: (CGFloat, CGFloat, CGFloat,CGFloat) {
        var hsba = [CGFloat](count:4, repeatedValue: 0)
        self.getHue(&hsba[0], saturation: &hsba[1], brightness: &hsba[2], alpha: &hsba[3])
        return (hsba[0], hsba[1], hsba[1], hsba[3])
    }

    public var hexValue:String {
        let rgbaValues = self.rgbaValues
        return NSString(format: "#%02lX%02lX%02lX", Int(rgbaValues.0), Int(rgbaValues.1), Int(rgbaValues.2))
    }
    
    public convenience init(rgb: RGBA, alpha: CGFloat) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((rgb & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
   public convenience init(rgba: RGBA){
        let sRgba = min(rgba,0xFFFFFFFF)
        let red: CGFloat = CGFloat((sRgba & 0xFF000000) >> 24) / 255.0
        let green: CGFloat = CGFloat((sRgba & 0x00FF0000) >> 16) / 255.0
        let blue: CGFloat = CGFloat((sRgba & 0x0000FF00) >> 8) / 255.0
        let alpha: CGFloat = CGFloat(sRgba & 0x000000FF) / 255.0
        
        self.init(red: red, green: green, blue:blue, alpha:alpha)
    }
    
    public convenience init(hex: String){
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        var rgb:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgb)
        
        if (countElements(cString) != 6) {
            rgb = 11119017
        }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((rgb & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    
   public convenience init(hex: String, alpha: CGFloat){
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        var rgb:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgb)
        
        if (countElements(cString) != 6) {
            rgb = 11119017
        }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((rgb & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)

    }
  public convenience init (color: Color, alpha: CGFloat ){
    let colorValues = CGColorGetComponents(color.CGColor)
       self.init(red:colorValues[0], green:colorValues[1], blue:colorValues[2], alpha:alpha)
    }
}

public extension RGBA {
  public var color: Color {
        return self > 0x00FFFFFF ? Color(rgba: self) : Color(rgb: self, alpha: 1)
    }
}

// blend 2 colors into a new color 
public func + (left: UIColor, right: UIColor) -> UIColor {
    var leftRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
    var rightRGBA = [CGFloat](count: 4, repeatedValue: 0.0)
    
    left.getRed(&leftRGBA[0], green: &leftRGBA[1], blue: &leftRGBA[2], alpha: &leftRGBA[3])
    right.getRed(&rightRGBA[0], green: &rightRGBA[1], blue: &rightRGBA[2], alpha: &rightRGBA[3])
    
    return UIColor(
        red: (leftRGBA[0] + rightRGBA[0]) / 2,
        green: (leftRGBA[1] + rightRGBA[1]) / 2,
        blue: (leftRGBA[2] + rightRGBA[2]) / 2,
        alpha: (leftRGBA[3] + rightRGBA[3]) / 2
    )
}



