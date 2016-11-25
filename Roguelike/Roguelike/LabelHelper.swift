//
//  LabelHelper.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class LabelHelper: NSObject {
    class func showNumber(number: Int, view: UIView) {
        let string = "\(number)"
        LabelHelper.showString(string, view: view)
    }
    
    class func showString(string: String, view: UIView) {
        let label = UILabel(frame: CGRectMake(0, 0, 5, 5))
        label.font = UIFont(name: "Benegraphic", size: 36)
        label.textColor = UIColor.whiteColor()
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -1.0,
            ]
        
        label.attributedText = NSAttributedString(string: string, attributes: strokeTextAttributes)
        
        label.sizeToFit()
        label.center = view.center
        view.superview!.addSubview(label)
        
        UIView.animateWithDuration(0.2, animations: {
            label.center = CGPointMake(label.center.x, label.center.y - view.frame.size.height)
        }) { (Bool) in
            UIView.animateWithDuration(0.2, animations: {
                label.alpha = 0
            }) { (Bool) in
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    label.removeFromSuperview()
                }
            }
        }
    }
}