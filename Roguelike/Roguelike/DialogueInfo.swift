//
//  DialogueInfo.swift
//  Roguelike
//
//  Created by Logan Klein on 11/29/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class DialogueInfo: NSObject {
    
    var leftIVName: String?
    var rightIVName: String?
    var displayText: String?
    
    convenience init(left: String?, right: String?, text: String?) {
        self.init()
        
        leftIVName = left
        rightIVName = right
        displayText = text
    }
}
