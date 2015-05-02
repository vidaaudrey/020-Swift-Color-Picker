//
//  Utils.swift
//  017-Beautiful-ID-Photo
//
//  Created by Audrey Li on 4/18/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

public enum Unit: CGFloat, Printable {
    case mm = 5.7 //
    case inch = 144.9 // 144.9 point in 1 inch
    case cm = 0.57
    case point = 1
   public var description: String {
        get {
            switch self {
            case mm: return "mm"
            case inch: return "inch"
            case cm:  return "cm"
            case point: return "point"
            }
        }
    }
}

public enum Position: String {
    case topLeft = "topLeft"
    case topRight = "topRight"
    case leftTop = "leftTop"
    case leftBottom = "leftBottom"
    case rightTop = "rightTop"
    case rightBottom =  "rightBottom"
    case bottomLeft = "bottomLeft"
    case bottomRight = "bottomRight"
    case topCenter = "topCenter"
    case bottomCenter = "bottomCenter"
    case leftCenter = "leftCenter"
    case rightCenter = "rightCenter"
}
public enum StringAlignment {
    case LeftTop
    case CenterTop
    case RightTop
    case LeftCenter
    case Center
    case RightCenter
    case LeftBottom
    case CenterBottom
    case RightBottom
}

// -> clean up later to allow shared context

public class Utils {
    
    
    public class func saveImageToLibrary(image: UIImage){
        
        let library = ALAssetsLibrary()
        if let cgImage = image.CGImage {
            // -> check later for saving metadata  library.writeImageToSavedPhotosAlbum(cgImage, metadata: imageToSave.properties(), completionBlock: nil)
            library.writeImageToSavedPhotosAlbum(cgImage, metadata: nil) { (location, error) -> Void in
                println("saved in \(location)")  // -> make an alerview
            }
        } else {
            println("error in saving the image")
        }
    }
    
   public class func asyncGetImageDataFromURL(url: String, callback:((UIImage?) -> Void)!){
        let downloadQueue = dispatch_queue_create("com.shomigo.processsdownload", nil)
        dispatch_async(downloadQueue) {
            
            var data = NSData(contentsOfURL: NSURL(string: url)!)
            var image : UIImage?
            if data != nil {
                image = UIImage(data: data!)!
            }
            callback(image)
            
            //            dispatch_async(dispatch_get_main_queue()) {
            //                imageView.image = image
            //                callback(finished: true)
            //            }
        }
        
    }
    
   public class func asyncLoadImageFromURL(url: String, imageView : UIImageView){
        
        let downloadQueue = dispatch_queue_create("com.shomigo.processsdownload", nil)
        
        dispatch_async(downloadQueue) {
            
            var data = NSData(contentsOfURL: NSURL(string: url)!)
            
            var image : UIImage?
            if data != nil {
                image = UIImage(data: data!)!
            }
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
    
    public class func getJSON(url: String, callback:((jsonData:AnyObject) -> Void)){
        var nsURL = NSURL(string: url)!
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(nsURL, completionHandler: { data, response, error -> Void in
            if error != nil {
                println("error !")
            } else {
                if let jsonData: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) {
                    callback(jsonData: jsonData)
                }
            }
        })
        task.resume()
    }
    
   public class func getStringFromJSON(data: NSDictionary, key: String) -> String{
        
        let info : AnyObject? = data[key]
        
        if let info = data[key] as? String {
            return info
        }
        return ""
    }
    
   public class func stripHTML(str: NSString) -> String {
        
        var stringToStrip = str
        var r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        while r.location != NSNotFound {
            
            stringToStrip = stringToStrip.stringByReplacingCharactersInRange(r, withString: "")
            r = stringToStrip.rangeOfString("<[^>]+>", options:.RegularExpressionSearch)
        }
        
        return stringToStrip as String
    }
    
   public class func formatDate(dateString: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = formatter.dateFromString(dateString)
        
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.stringFromDate(date!)
    }

    
    //Sourcecode from Apple example clockControl
    //Calculate the direction in degrees from a center point to an arbitrary position.
    public func angleFromNorth(p1: CGPoint, p2: CGPoint, flipped: Bool) -> CGFloat {
        var middlePoint = CGPointMake(p2.x - p1.x, p2.y - p1.y)
        let distance = Utils.square(Utils.square(middlePoint.x) + Utils.square(middlePoint.y))
        middlePoint.x /= distance
        middlePoint.y /= distance
        let radians = atan2(middlePoint.y, middlePoint.x)
        let result = Utils.radianToDegree(radians)
        return result > 0 ? result : result + 360
    }
    public func getPiePath(frame: CGRect, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath{
        var path = UIBezierPath()
        path.moveToPoint(frame.center)
        path.addLineToPoint(CGPointMake(frame.center.x + radius * cos(startAngle), frame.center.y + radius * sin(startAngle)))
        path.addArcWithCenter(frame.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closePath()
        return path
    }
    
    
    public class func radianToDegree(radian: CGFloat) -> CGFloat {
        return radian * 180 / CGFloat(M_PI)
    }
    public class func degreeToRadian(degree: CGFloat) -> CGFloat {
        return degree * CGFloat(M_PI) / 180
    }
    public class func square(value: CGFloat) -> CGFloat {
        return value * value
    }
    
   public class func takeUIWindowScreenShot() -> UIImage {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return screenshot
    }
    
    public class func takeUIViewScreenShot(view: UIView) -> UIImage {
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public class func CGAffineTransformMakeSkew(skewAmount: CGFloat,isXAxisSkew: Bool = true, anchorAxisValue: CGFloat, size: CGSize, tx:CGFloat = 0, ty: CGFloat = 0, dx: CGFloat = 1, dy: CGFloat = 1 ) -> CGAffineTransform{
        let direction: CGFloat = (0.5 - anchorAxisValue) > 0 ? 1 : -1
        if isXAxisSkew {
            let actualtx = tx + (0.5 - anchorAxisValue) * skewAmount * size.height * direction
            return CGAffineTransform(a: 1, b: 0, c: skewAmount * direction, d: dy, tx: actualtx, ty: ty)
        } else {
            let actualty = ty + (0.5 - anchorAxisValue) * skewAmount * size.width * direction
            return CGAffineTransform(a: dx, b: skewAmount * direction, c: 0, d: 1, tx: tx, ty: actualty)
        }
    }
    
    public class func renderUIViewToImage(sourceView: UIView) -> UIImage{
        var rect = sourceView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)  // -> try different scale
        sourceView.drawViewHierarchyInRect(sourceView.bounds, afterScreenUpdates: true)
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return renderedImage
    }
    
    public class func generateTextLabelInRect(text: String, contentRect: CGRect, alignment: NSTextAlignment = .Center) -> UILabel{
        let label = UILabel(frame: contentRect)
        label.textAlignment = alignment
        label.text = text
        label.textColor = UIColor.blackColor()
      //  label.font = AppConstants.printTitleFont
        return label
    }
    public class func generateUIViewWithImagesAndContentRect(contentRect: CGRect, images:[UIImage], imageWidth: CGFloat, imageHeight: CGFloat, imagePadding: CGFloat,  withBorder: Bool = true, withCuttingBorder: Bool = true, fillUpContentRect:Bool = true ) -> UIView{
        
        let viewWithImages = UIView(frame: contentRect)
        let numberOfRows = Int(floor(contentRect.size.height / (imageHeight + imagePadding)))
        let numberOfColumns = Int(floor(contentRect.size.width / (imageWidth + imagePadding)))
        
        // if the image does not fill up the whole page, we'll create extra copies of the images
        let totalFillNumber = numberOfColumns * numberOfRows
        var fillImages = images
        if images.count < totalFillNumber && fillUpContentRect {
           var imageCount = images.count
            while imageCount < totalFillNumber {
                for var i = 0; i < images.count; i++ {
                    fillImages.append(images[i])
                    imageCount++
                }
            }
        }
        
        // use the maxFit to center the views
        let maxFitViewWidth = (imageWidth + imagePadding) * CGFloat(numberOfColumns)
        let maxFitViewHeight = (imageHeight + imagePadding) * CGFloat(numberOfRows)
        
        let fixedOffsetX = imagePadding/2 + (contentRect.width - maxFitViewWidth)/2
        let fixedOffsetY = imagePadding/2 + (contentRect.height - maxFitViewHeight)/2
        
        var offsetY = fixedOffsetY
        var imageCount = 0
      
        while imageCount < fillImages.count {
            for var r = 0; r < numberOfRows; r++ {
                var offsetX = fixedOffsetX
                for var c = 0; c < numberOfColumns; c++ {
                    let imageView = UIImageView(frame: CGRectMake(offsetX, offsetY, imageWidth, imageHeight))
                    imageView.image = fillImages[r * numberOfColumns + c]
                    imageCount++
                    
                    // remove later
                    imageView.contentMode = UIViewContentMode.ScaleAspectFit
                    imageView.layer.borderWidth = 1
                    imageView.layer.borderColor = UIColor.blackColor().CGColor
                    
                    offsetX += imagePadding + imageWidth
                    viewWithImages.addSubview(imageView)
                    
                    //add cutting lines
                    let cuttingLineView = UIView(frame: CGRectInset(imageView.frame, -imagePadding/2, -imagePadding/2))
                    cuttingLineView.addDashedBorder(FrameworkConstants.cuttingBorderColor, lineWidth: 2)
                    viewWithImages.addSubview(cuttingLineView)
                }
                offsetY += imagePadding + imageHeight
            }
            
        }
        
        return viewWithImages
    }

}


public class Array2D {
   public var cols:Int, rows:Int
   public var matrix:[Int]
    
    
    public init(cols:Int, rows:Int) {
        self.cols = cols
        self.rows = rows
        matrix = Array(count:cols*rows, repeatedValue:0)
    }
    
    public subscript(col:Int, row:Int) -> Int {
        get {
            return matrix[cols * row + col]
        }
        set {
            matrix[cols*row+col] = newValue
        }
    }
    
}


