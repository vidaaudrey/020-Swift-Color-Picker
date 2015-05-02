//
//  ViewController.swift
//  020-Color-Play
//
//  Created by Audrey Li on 4/29/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var demoView: UIView!

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    
    @IBAction func sliderValueChanged(sender: UISlider) {
      //  let color = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        let color = UIColor(hue: CGFloat(redSlider.value), saturation: CGFloat(greenSlider.value), brightness: CGFloat(blueSlider.value), alpha: 1)
        demoView.backgroundColor = color

        println(color.rgbaValues.0)
        println(color.rgbaValues.1)
        
        println(color.hsbaValues.0)
        println(color.hsbaValues.1)
      
    }

}

