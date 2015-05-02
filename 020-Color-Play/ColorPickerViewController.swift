//
//  ColorRollViewController.swift
//  020-Color-Play
//
//  Created by Audrey Li on 4/30/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class ColorRollViewController: UIViewController {
    
    @IBOutlet weak var paletteView: ColorStripeView!
    @IBOutlet weak var colorPickerRectView: PixelsRectView!
    @IBOutlet weak var colorView: ColorRollView!
    @IBOutlet weak var sliderView: ColorStripeSliderView!
    
    override func viewDidLoad() {
        sliderView.actionHandler = { self.colorView.brightness = $0}
        let color = UIColor.redColor()
        println(color.hexValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        colorView.setNeedsDisplay()
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        colorView.setNeedsDisplay()
    }
    
    @IBAction func tapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(colorView)
        colorPickerRectView.colors = colorView.layer.getPixelColorsAtPoint(touchPoint, dx: CGFloat(APPConfig.colorPickerColumns - 1)/2, dy: CGFloat((APPConfig.colorPickerRows - 1)/2))
    }
    
    @IBAction func colorPickerRectDoubleTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(colorPickerRectView)
        let color = colorPickerRectView.layer.getPixelColorAtPoint(touchPoint)
        paletteView.colors.append(color)
    }
    
    @IBAction func colorViewDoubleTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(colorView)
        let color = colorView.layer.getPixelColorAtPoint(touchPoint)
        paletteView.colors.append(color)
    }

}
