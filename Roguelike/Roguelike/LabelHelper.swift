//
//  LabelHelper.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class LabelHelper: NSObject {
    class func showNumber(_ number: Int, view: UIView) {
        let string = "\(number)"
        LabelHelper.showString(string, view: view)
    }
    
    class func showString(_ string: String, view: UIView) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        label.font = UIFont(name: "Benegraphic", size: 36)
        label.textColor = UIColor.white
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : -1.0,
            ] as [String : Any]
        
        label.attributedText = NSAttributedString(string: string, attributes: strokeTextAttributes)
        
        label.sizeToFit()
        label.center = view.center
        view.superview!.addSubview(label)
        
        UIView.animate(withDuration: 0.2, animations: {
            label.center = CGPoint(x: label.center.x, y: label.center.y - view.frame.size.height)
        }, completion: { (Bool) in
            UIView.animate(withDuration: 0.2, animations: {
                label.alpha = 0
            }, completion: { (Bool) in
                let delayTime = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    label.removeFromSuperview()
                }
            }) 
        }) 
    }
}
