//
//  ColorPickerWithImageViewController.swift
//  020-Color-Play
//
//  Created by Audrey Li on 5/2/15.
//  Copyright (c) 2015 shomigo.com. All rights reserved.
//

import UIKit
import MessageUI
class ColorPickerWithImageViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var paletteView: ColorStripeView!
    @IBOutlet weak var colorPickerRectView: PixelsRectView!
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        let image = UIImage(named: "color")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPointZero, size: image.size)
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
    }
    
    
    @IBAction func paletteDoubleTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(paletteView)
        paletteView.removeColorAtPoint(touchPoint)
    }
    @IBAction func paletteLongPressed(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.locationInView(paletteView)
        let color = paletteView.layer.getPixelColorAtPoint(touchPoint)
        var alert = UIAlertController(title: "Color", message: "Tapped Color:\(color.hexValue)", preferredStyle: UIAlertControllerStyle.Alert)
        
        // -> more work on this
        alert.addAction(UIAlertAction(title: "Email Palette", style: .Default, handler: { (action) -> Void in
           let mailController = self.configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self //imp
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("AL Color Picker Palette ")
        let colors = paletteView.colors
        let colorsString:String = "  ".join(colors.map{$0.hexValue})
        println("colors:\(colorsString)")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!\(colorsString)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func scrollViewSingleTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(scrollView)
        colorPickerRectView.colors = scrollView.layer.getPixelColorsAtPoint(touchPoint, dx: CGFloat(APPConfig.colorPickerColumns - 1)/2, dy: CGFloat((APPConfig.colorPickerRows - 1)/2))
    }
    
    @IBAction func scrollViewDoubleTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(scrollView)
        let color = colorPickerRectView.layer.getPixelColorAtPoint(touchPoint)
        paletteView.colors.append(color)
    }
    
    @IBAction func colorPickerRectDoubleTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.locationInView(colorPickerRectView)
        let color = colorPickerRectView.layer.getPixelColorAtPoint(touchPoint)
        paletteView.colors.append(color)
    }
}
