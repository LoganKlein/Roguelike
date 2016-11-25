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
    func setX(x: CGFloat){frame = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);}
    func setY(y: CGFloat){frame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);}
    func setWidth(width: CGFloat){frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);}
    func setHeight(height: CGFloat){frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);}
}