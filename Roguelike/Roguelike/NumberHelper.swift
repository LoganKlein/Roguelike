//
//  NumberHelper.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class NumberHelper: NSObject {
    class func showNumber(number: Int, view: UIView) {
        let label = UILabel(frame: CGRectMake(0, 0, 5, 5))
        label.text = "\(number)"
        label.font = UIFont(name: "Benegraphic", size: 24)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        label.center = CGPointMake(view.frame.size.width/2, 0)
        view.addSubview(label)
        
        UIView.animateWithDuration(0.1, animations: {
            label.center = CGPointMake(label.center.x, label.center.y - 10)
            }) { (Bool) in
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    label.removeFromSuperview()
                }
        }
    }
}