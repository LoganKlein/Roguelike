//
//  Extensions.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}

extension UIView {
    func rightSide() -> CGFloat {return frame.origin.x + frame.size.width;}
    func bottom() ->CGFloat {return frame.origin.y + frame.size.height;}
    func setX(_ x: CGFloat){frame = CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height);}
    func setY(_ y: CGFloat){frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height);}
    func setWidth(_ width: CGFloat){frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height);}
    func setHeight(_ height: CGFloat){frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height);}
}
