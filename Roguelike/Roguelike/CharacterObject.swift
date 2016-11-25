//
//  CharacterObject.swift
//  Roguelike
//
//  Created by Logan Klein on 11/10/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class CharacterObject: NSObject {
    var atk = 0.0
    var def = 0.0
    var maxHP = 0.0
    var curHP = 0.0
    var lvl = 1
    var exp = 0.0
    
    var coordinates: CGPoint!
    var displayView: UIView!
    var characterIV: UIImageView!
    
    //MARK: - Location Methods
    
    func moveTo(newLocation: CGPoint, map: CAMap) {
        UIView.animateWithDuration(0.2, animations: {
            let xPos = map.cellSize * newLocation.x + map.cellSize/2
            let yPos = map.cellSize * newLocation.y + map.cellSize/2
            self.coordinates = newLocation
            self.displayView.center = CGPointMake(xPos, yPos)
        })
    }
    
    //MARK: - Modification Methods
    
    func takeDamage(dmg: Double) -> Bool {
        let dmgTaken = max(dmg - def, 0)
        LabelHelper.showNumber(Int(dmgTaken * -1), view: self.displayView)
        
        curHP -= dmgTaken
        
        if curHP <= 0 {
            return true
        }
        
        return false
    }
}
