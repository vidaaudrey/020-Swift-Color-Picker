//
//  PixelRectView.swift
//  020-Color-Play
//
//  Created by Audrey Li on 4/30/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

@IBDesignable
public class PixelsRectView: UIView {

    var colors: [UIColor] = [] {
        didSet {
            if colors.count <= rows * columns && colors.count != 0  {
                setNeedsDisplay()
            }
        }
    }
    var columns = APPConfig.colorPickerColumns
    var rows = APPConfig.colorPickerRows
    var middleCellXY:(column:Int, row:Int){
        get {
            return (Int(columns)/2, Int((rows)/2))
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override public func drawRect(rect: CGRect) {
        if colors.count == rows * columns {
            let ctx = UIGraphicsGetCurrentContext()
            let cellWidth = rect.width / CGFloat(columns)
            let cellHeight = rect.height / CGFloat(rows)
            let originCell = CGRectMake(rect.origin.x, rect.origin.y, cellWidth, cellHeight)
            
            for var r = 0; r < rows; r++ {
                for var c = 0; c < columns; c++ {
                    CGContextAddRect(ctx, originCell.rectByShift(shiftX: CGFloat(c) * cellWidth, shiftY: CGFloat(r) * cellHeight))
                    colors[r * columns + c].set()
                    CGContextFillPath(ctx)
                    
                }
            }
            
            // add the middle cell highLight 
            let middleCell = originCell.rectByShift(shiftX: cellWidth * CGFloat(middleCellXY.column), shiftY: CGFloat(middleCellXY.row) * cellHeight)
             CGContextAddRect(ctx, middleCell)
            UIColor.whiteColor().set()
            CGContextSetLineWidth(ctx, APPConfig.colorPickerMiddleCellLineWidth)
            CGContextStrokePath(ctx)

        }
    }
}

