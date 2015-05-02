//
//  CGRectExtension.swift
//  017-Beautiful-ID-Photo
//
//  Created by Audrey Li on 4/16/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import Foundation
import UIKit
public enum Direction {
    case top
    case bottom
    case left
    case right
}

public extension CGRect {
    public var center: CGPoint { return CGPointMake(self.width/2, self.height/2)}
    
    // get the small area that inside the insets. assume the innerRect is in the center of the frame
    internal func insettedRect(innerRect: CGRect, direction: Direction) -> CGRect {
        let offsetX = (self.width - innerRect.width) / 2
        let offsetY = (self.height - innerRect.height) / 2
        switch direction {
        case .top:
            return CGRectMake(offsetX, 0, innerRect.width, offsetY)
        case .bottom:
            return CGRectMake(offsetX, offsetY + innerRect.height, innerRect.width, offsetY)
        case .left:
            return CGRectMake(0, offsetY, offsetX, innerRect.height)
        case .right:
            return CGRectMake(offsetX + innerRect.width, offsetY, offsetX, innerRect.height)
        }
    }
    
   public func rectByShift(shiftX: CGFloat = 0, shiftY: CGFloat = 0) -> CGRect {
        return CGRectMake(self.origin.x + shiftX, self.origin.y + shiftY, self.width, self.height)
    }
    
    public func rectByCenteringWithWidth(width: CGFloat) -> CGRect {
        return rectByCentering(width, height: self.height)
    }
   public func rectByCenteringWithHeight(height: CGFloat) -> CGRect {
        return rectByCentering(self.width, height: height)
    }
    
   public func rectByExchangeWidthHeight() -> CGRect{
        return self.rectByCentering(height, height: width)
    }
    
   public func getUIEdgeInsetsBySize(size: CGSize) -> UIEdgeInsets {
        return UIEdgeInsets(top: (size.height - self.height) / 2, left: (size.width - self.width) / 2, bottom: (size.height - self.height) / 2, right: (size.width - self.width) / 2)
    }
    
   public func rectByUIEdgeInsets(insets:UIEdgeInsets) -> CGRect {
        return CGRectMake(minX + insets.left, minY + insets.top, width - insets.left - insets.right, height - insets.top - insets.bottom)
    }
    
    public func rectByInsets(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) -> CGRect{
        return CGRectMake(minX + left, minY + top, width - left - right, height - top - bottom)
    }
    
    public func rectByScale(scale: CGFloat) -> CGRect {
        return rectByCentering(self.width * scale, height: self.height * scale)
    }
    
   public func getScaleRatioWithinRect(targetRect:CGRect) -> CGFloat {
        return min(self.width / targetRect.width, self.height / targetRect.height)
    }
    public func rectByCentering(width: CGFloat, height: CGFloat) -> CGRect {
        return CGRectMake(self.midX - width / 2, self.midY - height / 2, width, height)
    }
    
   public func getFittingRectColumnsAndRows(size: CGSize, innerPadding: CGFloat, outerPadding:CGFloat = 0) -> (numberOfColumns: Int, numberOfRows: Int){
        let numberOfColumns = Int(floor((self.size.width - 2 * outerPadding) / (size.width + innerPadding)))
        let numberOfRows = Int(floor((self.size.height - 2 * outerPadding) / (size.height + innerPadding)))
       return(numberOfColumns, numberOfRows)
        
    }
   public func getFittingRectNumbers (size: CGSize, innerPadding: CGFloat, outerPadding:CGFloat = 0) -> Int {
        let numberOfColumns = Int(floor((self.size.width - 2 * outerPadding) / (size.width + innerPadding)))
        let numberOfRows = Int(floor((self.size.height - 2 * outerPadding) / (size.height + innerPadding)))
        return numberOfRows * numberOfColumns
        
    }

    // make a new rect with the same center point, but different width and heigh ratio. default ratio is width ratio, default height ratio equals to width ratio
   public func insetRectWithRatio(ratio: CGFloat, heightRatio: CGFloat = 0) -> CGRect {
        var actualHeightRatio: CGFloat
        if heightRatio == 0 {
            actualHeightRatio = ratio
        } else {
            actualHeightRatio = heightRatio
        }
        
        return rectWithCenter(CGPointMake(self.midX, self.midY), width: self.width * ratio, height: self.height * actualHeightRatio)
    }
    
    public func rectWithCenter(center: CGPoint, width: CGFloat, height: CGFloat) -> CGRect {
            return CGRectMake(center.x - width / 2, center.y - height / 2, width, height)
    }
    
//    func insetTop(topInset:CGFloat) -> CGRect {
//        return CGRectMake(0, topInset, self.width, self.height)
//    }
//    func insetBottom(inset:CGFloat) -> CGRect {
//        return CGRectMake(0, 0, self.width, self.height - inset)
//    }
//    func insetLeft(inset:CGFloat) -> CGRect {
//        return CGRectMake(inset, 0, self.width - inset, self.height)
//    }
//    func insetRight(inset:CGFloat) -> CGRect {
//        return CGRectMake(0, 0, self.width - inset, self.height)
//    }
    
   public func insetTop(inset:CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y + inset, self.width, self.height - inset)
    }
    public func insetBottom(inset:CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y, self.width, self.height - inset)
    }
   public func insetLeft(inset:CGFloat) -> CGRect {
        return CGRectMake(inset + self.origin.x , self.origin.y, self.width - inset, self.height)
    }
   public func insetRight(inset:CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y, self.width - inset, self.height)
    }
    
   public func paddingTop(targetHeight: CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y + (self.height - targetHeight), self.width, targetHeight)
    }
    
   public func paddingBottom(targetHeight: CGFloat) -> CGRect{
        return CGRectMake(self.origin.x, self.origin.y, self.width, targetHeight)
    }
    
    public func paddingLeft(targetWidth: CGFloat) -> CGRect{
        return CGRectMake(self.origin.x + (self.width - targetWidth), self.origin.y, targetWidth, self.height)
    }
    public func paddingRight(targetWidth: CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y, targetWidth, self.height)
    }
    
    
    public func insetMaxSquare(rect: CGRect) -> CGRect {
        var width = rect.width < rect.height ? rect.width : rect.height
        return CGRect(x: rect.midX - rect.width / 2, y: rect.midY - rect.width / 2, width: width, height: width)
    }
    
    public func insetSquare(rect: CGRect, dx: CGFloat) -> CGRect {
        if rect.width < rect.height {
            var width = rect.width
            return CGRect(x: rect.midX - rect.width / 2 + dx, y: rect.midY - rect.width / 2 + dx, width: width - 2 * dx, height: width - 2 * dx)
        } else {
            return CGRect(x: rect.midX - rect.height / 2 + dx, y: rect.midY - rect.height / 2 + dx, width: height - 2 * dx, height: height - 2 * dx)
        }
        
    }
    
    // check if the rect is within the targetRect
    public func isWithinRect(targetRect: CGRect) -> Bool {
        let point2 = CGPointMake(self.origin.x + self.width, self.origin.y)
        let point3 = CGPointMake(self.origin.x + self.width, self.origin.y + self.height)
        let point4 = CGPointMake(self.origin.x, self.origin.y + self.height)
        return (self.origin.isPointWithinRect(targetRect) && point2.isPointWithinRect(targetRect)) && (point3.isPointWithinRect(targetRect) && point4.isPointWithinRect(targetRect))
    }
    
    public func createMaxRectWithinRectWithSize(sourceSize: CGSize) -> CGRect {
        let sourceAspect = sourceSize.width / sourceSize.height
        
        var returnWidth = self.width
        var returnHeight = self.height
        
       
        if (returnWidth / sourceAspect) > self.height {
            returnWidth = self.height * sourceAspect
           
        } else {
            returnHeight = returnWidth / sourceAspect
        }
        
        return CGRectMake(self.midX - returnWidth / 2, self.midY - returnHeight / 2, returnWidth, returnHeight)
        
    }
    
    // the padding is based on the size of the maxRect -> paddingRatio
    public func createMaxRectWithinRectWithSizeAndPaddingRatio (sourceSize: CGSize, paddingRatio: CGFloat) -> CGRect {
        let tempRect = createMaxRectWithinRectWithSize(sourceSize)
        
        let offSetX = (width - tempRect.width)/2
        let offSetY = (height - tempRect.height)/2
        if offSetX == 0 {
            let padding = (tempRect.width / (paddingRatio * 2 + 1)) * paddingRatio
            return CGRectInset(tempRect, padding, padding)
        } else {
            let padding = (tempRect.height / (paddingRatio * 2 + 1)) * paddingRatio
            return CGRectInset(tempRect, padding, padding)
        }
    }
    
   public  func createMaxRectWithinRectWithSizeAndPadding(sourceSize: CGSize, padding: CGFloat, paddingVertical: CGFloat = 0) -> CGRect {
        let tempRect = createMaxRectWithinRectWithSize(sourceSize)
        let offSetX = (width - tempRect.width)/2
        let offSetY = (height - tempRect.height)/2
        let paddingV =  paddingVertical == 0 ? padding : paddingVertical
        if offSetX == 0 {
            return CGRectInset(self, padding, offSetY + padding + paddingV )
        } else {
            return CGRectInset(self, offSetX + padding, padding + paddingV)
        }
    }
    
   public func rectByInsetLeft(inset: CGFloat) -> CGRect {
        return CGRectMake(self.origin.x + inset, self.origin.y, self.width - inset, self.height)
    }
    public func rectByInsetRight(inset: CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y, self.width - inset, self.height)
    }
   public func rectByInsetTop(inset: CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y + inset, self.width, self.height - inset)
    }
    public func rectByInsetBottom(inset: CGFloat) -> CGRect {
        return CGRectMake(self.origin.x, self.origin.y, self.width, self.height - inset)
    }
    
}
public extension CGPoint {
   public func isPointWithinRect(rect: CGRect) -> Bool {
        return (self.x > rect.origin.x   &&  self.x < rect.origin.x + rect.width) && (self.y > rect.origin.y && self.y < rect.origin.y + rect.height)
    }
    // handle if the point position +- dx or dy falls into the outside of the rect
    public func getPointIntoRectWithinInset(rect: CGRect, dx: CGFloat, dy: CGFloat) -> CGPoint{
        let pointMinX = (self.x - dx) > rect.origin.x ? self.x : (dx + rect.origin.x )
        let pointMaxX = (self.x + dx) < (rect.origin.x + rect.width) ? self.x : (rect.origin.x + rect.width - dx)
        let pointMinY = (self.y - dy) > rect.origin.y ? self.y : (dy + rect.origin.y)
        let pointMaxY = (self.y + dy) < (rect.origin.y + rect.height) ? self.y : (rect.origin.y + rect.height - dy)
        let pointX = self.x < rect.midX ? pointMinY : pointMaxX
        let pointY = self.y < rect.midY ? pointMinY : pointMaxY
        
        return CGPointMake(pointX, pointY)
    }
    
    func sanitize(rect: CGRect) {
        precondition(CGRectContainsPoint(rect, self), "CGPoint passed is not inside the rect of image.It will give wrong pixel and may crash.")
    }

}
public extension CGSize {
    public func sizeByScale(scale: CGFloat) -> CGSize {
        return CGSizeMake(width * scale, height * scale)
    }
}
public extension UIEdgeInsets{
   public func insetsByScale(scale: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.top * scale, left: self.left * scale, bottom: self.bottom * scale, right: self.right * scale)
    }
}