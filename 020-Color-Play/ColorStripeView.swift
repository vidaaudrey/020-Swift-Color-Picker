//
//  ColorStripeView.swift
//  020-Color-Play
//
//  Created by Audrey Li on 4/30/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

@IBDesignable
public class ColorStripeView: UIView {
    var colors: [UIColor] = [] {
        didSet {
            if colors.count > 0 {
                if colors.count > APPConfig.maxmumPaletteColors{
                    for var i = 0; i < (colors.count - APPConfig.maxmumPaletteColors); i++ {
                        colors.removeAtIndex(0)
                    }
                }
                 setNeedsDisplay()
            }
        }
    }
    var isHorizental: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
    }
    
    public func removeColorAtPoint(point: CGPoint){
        if colors.count > 0 {
            if isHorizental {
                let colorIndex = CGFloat(colors.count) * (point.x - frame.origin.x) / frame.width
                colors.removeAtIndex(Int(colorIndex) + 1)
            } else {
                let colorIndex = CGFloat(colors.count) * (point.y - frame.origin.y) / frame.height
                colors.removeAtIndex(Int(colorIndex))
            }
        }
    }
    
    override public func drawRect(rect: CGRect) {
        if colors.count > 0 {
            let totalStrips = CGFloat(colors.count)
            let ctx = UIGraphicsGetCurrentContext()
            if isHorizental {
                let stripRectWidth = rect.width / CGFloat(totalStrips)
                let firstStripRect = rect.paddingRight(stripRectWidth * (totalStrips - 1) )
                for var i = 0; i < colors.count; i++ {
                    CGContextAddRect(ctx, firstStripRect.rectByShift(shiftX: stripRectWidth * CGFloat(i)))
                    colors[i].set()
                    CGContextFillPath(ctx)
                }
            } else {
                let stripeRectHeight = rect.height / CGFloat(colors.count)
                let firstStripeRect = rect.paddingBottom(stripeRectHeight * (totalStrips - 1))
                for var i = 0; i < colors.count; i++ {
                    CGContextAddRect(ctx, firstStripeRect.rectByShift(shiftY: stripeRectHeight * CGFloat(i)))
                    colors[i].set()
                    CGContextFillPath(ctx)
                }
            }
        }
       
    }
    

}
