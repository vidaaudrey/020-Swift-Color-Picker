//
//  ImageProcessing.swift
//  020-Color-Play
//
//  Created by Audrey Li on 4/30/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import Foundation
import UIKit

public class ImageUtils {

}

extension CALayer {
    public func getPixelColorAtPoint(point: CGPoint) -> UIColor{
        //   var pixel : [UInt8] = [0, 0, 0, 0]
        var pixel = [UInt8](count:4, repeatedValue: 0)
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let ctx = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, colorSpace, bitmapInfo)  // adjust go get more  points
        CGContextTranslateCTM(ctx, -point.x, -point.y)
        self.renderInContext(ctx)
        
        let r:CGFloat = CGFloat(pixel[0])/255.0
        let g:CGFloat = CGFloat(pixel[1])/255.0
        let b:CGFloat = CGFloat(pixel[2])/255.0
        let a:CGFloat = CGFloat(pixel[3])/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    //just use this one to test if getPixelColorsAtPoint() is working properly. Don't use it as it takes a lot more memory
    public func getPixelColorsAtPointHeavy(centerPoint: CGPoint, dx: CGFloat, dy: CGFloat) -> [UIColor]{
        
        let localCenterPoint: CGPoint = centerPoint.getPointIntoRectWithinInset(CGRectMake(0, 0, self.frame.width, self.frame.height), dx: dx, dy: dy)
        
        var colors:[UIColor] = []
        let columns = Int(2 * dx + 1)
        let rows = Int(2 * dy + 1)
        
        for var r = 0; r < rows; r++ {
            let pointY = localCenterPoint.y - dy + CGFloat(r)
            for var c = 0; c < columns; c++ {
                let pointX = localCenterPoint.x - dx + CGFloat(c)
                    colors.append(self.getPixelColorAtPoint(CGPointMake(pointX, pointY)))
            }
        }
        return colors
    }
    
    public func getPixelColorsAtPoint(centerPoint: CGPoint, dx: CGFloat, dy: CGFloat) -> [UIColor] {
        var colors:[UIColor] = []
        let columns = Int(2 * dx + 1)
        let rows = Int(2 * dy + 1)
        let localCenterPoint: CGPoint = centerPoint.getPointIntoRectWithinInset(CGRectMake(0, 0, self.frame.width, self.frame.height), dx: dx, dy: dy)
        
        var pixel = [UInt8](count:4 * columns * rows, repeatedValue: 0)
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
     
        //  bytesPerRow: 4 * columns * rows.The number of bytes of memory to use per row of the bitmap.
        let ctx = CGBitmapContextCreate(&pixel, UInt(dx) * 2 + 1, UInt(dy) * 2 + 1, 8, 4 *  UInt(columns), colorSpace, bitmapInfo)  // not sure why use 4 * columns, but it seems only work in this way
        CGContextTranslateCTM(ctx, -centerPoint.x + dx , -centerPoint.y + dy)
        self.renderInContext(ctx)
        
        for var r = 0; r < rows; r++ {
            let pointY = CGFloat(r)
            for var c = 0; c < columns; c++ {
                let pointX = CGFloat(c)
                let offset = 4*((columns * Int(pointY)) + Int(pointX))
                let r:CGFloat = CGFloat(pixel[offset])/255.0
                let g:CGFloat = CGFloat(pixel[offset + 1])/255.0
                let b:CGFloat = CGFloat(pixel[offset + 2])/255.0
                let a:CGFloat = CGFloat(pixel[offset + 3])/255.0
                colors.append(UIColor(red: r, green: g, blue: b, alpha: a))
            }
        }
        return colors.reverseColumns(columns)
    }
}


public extension UIImage {
    
    typealias RawColorType = (newRedColor:UInt8, newgreenColor:UInt8, newblueColor:UInt8,  newalphaValue:UInt8)
    
    public func getPixelColorAtPoint(point: CGPoint) -> UIColor {
        self.sanitizePoint(point)
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo:Int = (Int(self.size.width) * Int(point.y) + Int(point.x)) * 4
        
        let r: CGFloat = CGFloat(data[pixelInfo]) / 255
        let g: CGFloat = CGFloat(data[pixelInfo + 1]) / 255
        let b: CGFloat = CGFloat(data[pixelInfo + 2]) / 255
        let a: CGFloat = CGFloat(data[pixelInfo + 3]) / 255
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    

    public func getPixelColorsAtPoint(centerPoint: CGPoint, dx: CGFloat, dy: CGFloat) -> [UIColor] {
        let localCenterPoint: CGPoint = centerPoint.getPointIntoRectWithinInset(CGRectMake(0, 0, self.size.width, self.size.height), dx: dx, dy: dy)
        
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var colors:[UIColor] = []
        let columns:Int = Int(2 * dx + 1)
        let rows:Int = Int(2 * dy + 1)
        
        for var r = 0; r < rows; r++ {
            let pointY = localCenterPoint.y - dy + CGFloat(r)
            for var c = 0; c < columns; c++ {
                let pointX = localCenterPoint.x - dx + CGFloat(c)
                
                let pixelInfo:Int = (Int(self.size.width) * Int(pointY) + Int(pointX)) * 4
                let r: CGFloat = CGFloat(data[pixelInfo]) / 255
                let g: CGFloat = CGFloat(data[pixelInfo + 1]) / 255
                let b: CGFloat = CGFloat(data[pixelInfo + 2]) / 255
                let a: CGFloat = CGFloat(data[pixelInfo + 3]) / 255
                colors.append(UIColor(red: r, green: g, blue: b, alpha: a))
            }
        }
        println("total color rect \(rows * columns)")
        return colors
    }
    
    public func getPixelColorAtPointLight(centerPoint: CGPoint, dx: CGFloat, dy: CGFloat) -> [UIColor]{
        var colors:[UIColor] = []
        let columns = Int(2 * dx + 1)
        let rows = Int(2 * dy + 1)
        
        let inImage:CGImageRef = self.CGImage
        let context = self.createARGBBitmapContext(inImage)
        
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        //Clear the context and draw the image
        CGContextClearRect(context, rect)
        CGContextDrawImage(context, rect, inImage)
        
        let data = CGBitmapContextGetData(context)
        let dataType = UnsafePointer<UInt8>(data)
        
        let localCenterPoint: CGPoint = centerPoint.getPointIntoRectWithinInset(CGRectMake(0, 0, self.size.width, self.size.height), dx: dx, dy: dy)
        
        for var r = 0; r < rows; r++ {
            let pointY = localCenterPoint.y - dy + CGFloat(r)
            for var c = 0; c < columns; c++ {
                let pointX = localCenterPoint.x - dx + CGFloat(c)
                let offset = 4*((Int(pixelsWide) * Int(pointY)) + Int(pointX))
                let a = CGFloat(dataType[offset]) / 255.0
                let r = CGFloat(dataType[offset + 1]) / 255.0
                let g = CGFloat(dataType[offset + 2]) / 255.0
                let b = CGFloat(dataType[offset + 3]) / 255.0
                
                colors.append(UIColor(red: r, green: g, blue: b, alpha: a))
            }
        }
        println("total color: \(rows * columns)")
        return colors
    }
    
    // Change the color of pixel at a certain point
    public func setPixelColorAtPoint(point:CGPoint, color: RawColorType) -> UIImage? {
        self.sanitizePoint(point)
        let inImage:CGImageRef = self.CGImage
        let context = self.createARGBBitmapContext(inImage)
        
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        //Clear the context and draw the image to context
        CGContextClearRect(context, rect)
        CGContextDrawImage(context, rect, inImage)

        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        
        let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
        dataType[offset]   = color.newalphaValue
        dataType[offset+1] = color.newRedColor
        dataType[offset+2] = color.newgreenColor
        dataType[offset+3] = color.newblueColor
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, CUnsignedLong(8),  CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        return UIImage(CGImage: imageRef, scale: self.scale,orientation: self.imageOrientation)
        
    }
    
    func getGrayScale() -> UIImage? {
        let inImage:CGImageRef = self.CGImage
        let context = self.createARGBBitmapContext(inImage)
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        //Clear the context and draw the image into context
        CGContextClearRect(context, rect)
        CGContextDrawImage(context, rect, inImage)
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        let point: CGPoint = CGPointMake(0, 0)
        
        for var x = 0; x < Int(pixelsWide) ; x++ {
            for var y = 0; y < Int(pixelsHigh) ; y++ {
                let offset = 4*((Int(pixelsWide) * Int(y)) + Int(x))
                let alpha = dataType[offset]
                let red = dataType[offset+1]
                let green = dataType[offset+2]
                let blue = dataType[offset+3]
                
                let avg = (UInt32(red) + UInt32(green) + UInt32(blue))/3
                
                dataType[offset + 1] = UInt8(avg)
                dataType[offset + 2] = UInt8(avg)
                dataType[offset + 3] = UInt8(avg)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, CUnsignedLong(8),  CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        return UIImage(CGImage: imageRef, scale: self.scale,orientation: self.imageOrientation)
    }
    
    // Defining the closure.
    typealias ModifyPixelsClosure = (point:CGPoint, redColor:UInt8, greenColor:UInt8, blueColor:UInt8, alphaValue:UInt8)->(newRedColor:UInt8, newgreenColor:UInt8, newblueColor:UInt8,  newalphaValue:UInt8)
    
    
    // Provide closure which will return new color value for pixel using any condition you want inside the closure.
    
    func applyOnPixels(closure:ModifyPixelsClosure) -> UIImage? {
        let inImage:CGImageRef = self.CGImage
        let context = self.createARGBBitmapContext(inImage)
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        //Clear the context and draw image
        CGContextClearRect(context, rect)
        CGContextDrawImage(context, rect, inImage)
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context
        var data = CGBitmapContextGetData(context)
        var dataType = UnsafeMutablePointer<UInt8>(data)
        let point: CGPoint = CGPointMake(0, 0)
        
        for var x = 0; x < Int(pixelsWide) ; x++ {
            for var y = 0; y < Int(pixelsHigh) ; y++ {
                let offset = 4*((Int(pixelsWide) * Int(y)) + Int(x))
                let alpha = dataType[offset]
                let red = dataType[offset+1]
                let green = dataType[offset+2]
                let blue = dataType[offset+3]
                let (newRedColor:UInt8, newGreenColor:UInt8, newBlueColor:UInt8, newAlphaValue:UInt8)  =  closure(point: CGPointMake(CGFloat(x), CGFloat(y)), redColor: red, greenColor: green,  blueColor: blue, alphaValue: alpha)
                dataType[offset] = newAlphaValue
                dataType[offset + 1] = newRedColor
                dataType[offset + 2] = newGreenColor
                dataType[offset + 3] = newBlueColor
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, CUnsignedLong(8),  CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        
        let imageRef = CGBitmapContextCreateImage(finalcontext)
        return UIImage(CGImage: imageRef, scale: self.scale,orientation: self.imageOrientation)
    }
    
    
    
    //
    //    public func getPixelColorAtPointHeavy(centerPoint: CGPoint, dx: CGFloat, dy: CGFloat) -> [UIColor]{
    //        var colors:[UIColor] = []
    //        let columns = Int(2 * dx)
    //        let rows = Int(2 * dy)
    //
    //        for var r = 0; r < rows; r++ {
    //            let pointY = centerPoint.y - dy + CGFloat(r)
    //            for var c = 0; c < columns; c++ {
    //                let pointX = centerPoint.x - dx + CGFloat(c)
    //                colors.append(self.getPixelColorAtLocation(CGPointMake(pointX, pointY))!)
    //            }
    //        }
    //        println("total color in heavy \(rows * columns)")
    //        return colors
    //    }
    
}
private extension UIImage {
     func createARGBBitmapContext(inImage: CGImageRef) -> CGContext {
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this example is represented by 4 bytes; 8 bits each of red, green, blue, and alpha.
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(CUnsignedLong(bitmapByteCount))
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits per component. Regardless of what the source image format is (CMYK, Grayscale, and so on) it will be converted over to the format  specified here by CGBitmapContextCreate.
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, CUnsignedLong(8), CUnsignedLong(bitmapBytesPerRow), colorSpace, bitmapInfo)
        return context
    }
    
    func sanitizePoint(point:CGPoint) {
        let inImage:CGImageRef = self.CGImage
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
        
        precondition(CGRectContainsPoint(rect, point), "CGPoint passed is not inside the rect of image.It will give wrong pixel and may crash.")
    }
}