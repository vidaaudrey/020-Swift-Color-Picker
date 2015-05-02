//
//  ColorRollView.swift
//  020-Color-Play
//
//  Created by Audrey Li on 4/29/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

//@IBDesignable
public class ColorRollView: UIView {
   
    let rows:CGFloat = 12
    let columns:CGFloat = 18
    let columnSpacingAngle:CGFloat = 0.5 // angle
    let rowSpacing:CGFloat = 2            // width
    @IBInspectable var brightness:CGFloat = 0.9
        {
        didSet {
            if brightness > 0 && brightness < 1 {
                setNeedsDisplay()
            }
        }
    }
   
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let ctx = UIGraphicsGetCurrentContext()
        let middleRect = rect.insetMaxSquare(rect)
        let singleLineWidth:CGFloat = middleRect.width / (2 * CGFloat(rows)) - rowSpacing
        let singleColumnAngle: CGFloat = 360 / self.columns
        
        CGContextSetLineWidth(ctx, singleLineWidth)
        for var r = 0; r < Int(rows); r++ {
            let currentRadius = singleLineWidth * CGFloat(r) + rowSpacing * CGFloat (r+1)
            
            for var c = 0; c < Int(columns); c++ {
                let currentStartAngle = singleColumnAngle * CGFloat(c)
                let currentEndAngle = singleColumnAngle * CGFloat(c + 1) - columnSpacingAngle
                
                  CGContextAddArc(ctx, middleRect.midX, middleRect.midY, currentRadius , Utils.degreeToRadian(currentStartAngle), Utils.degreeToRadian(currentEndAngle), 0)

//                if r > Int(rows) / 2 {
//                    brightness = (rows - CGFloat(r)) * 2 / rows
//                    println(brightness)
//                }
                
                 UIColor(hue: currentStartAngle / 360, saturation: currentRadius * 2 / (middleRect.width), brightness: brightness, alpha: 1).set()
                CGContextDrawPath(ctx, kCGPathStroke)
            }
            
        }
        
      //  CGContextSaveGState(ctx)
      //  CGContextRestoreGState(ctx)

    }
    

}
