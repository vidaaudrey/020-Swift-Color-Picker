//
//  ColorStripeSliderView.swift
//  020-Color-Play
//
//  Created by Audrey Li on 5/1/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class ColorStripeSliderView: UIView {

    @IBOutlet weak var slider: UISlider!
    var view: UIView!
    
    var bgColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
   
    var actionHandler:((CGFloat) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
    }
    override func drawRect(rect: CGRect) {
        let totalStrips = APPConfig.ColorStripeSliderSteps
        let ctx = UIGraphicsGetCurrentContext()
        let stripRectWidth = rect.width / CGFloat(totalStrips)
        let firstStripRect = CGRectMake(rect.origin.x, rect.origin.y, stripRectWidth, rect.height)
        
        let hsbaValues = bgColor.hsbaValues
        for i in 0..<totalStrips {
            CGContextAddRect(ctx, firstStripRect.rectByShift(shiftX: stripRectWidth * CGFloat(i)))
            UIColor(hue: hsbaValues.0, saturation: hsbaValues.1, brightness: (CGFloat(i) + 1) / CGFloat(totalStrips), alpha: hsbaValues.3).set()
            CGContextFillPath(ctx)
        }

    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ColorStripeSliderView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as UIView
        return view
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        actionHandler?(CGFloat(sender.value))
    }

    

}
