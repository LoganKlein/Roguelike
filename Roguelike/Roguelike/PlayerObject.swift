//
//  PlayerObject.swift
//  Roguelike
//
//  Created by Logan Klein on 11/17/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

enum CharacterClass: Int {
    case Hunter = 0
    case Knight
    case Cleric
    case Prophet
}

class PlayerObject: CharacterObject {
    var lck = 0.0
    var reg = 0.0
    var sty = 100.0
    var expNeeded = 20.0
    
    var weapon: ItemObject? = nil
    var armor: ItemObject? = nil
    var buff: ItemObject? = nil
    
    var type: CharacterClass!
    
    //MARK: - Initialization Methods
    
    class func initHero(map: CAMap) -> PlayerObject {
        let hero = PlayerObject()
        hero.displayView = UIView(frame: CGRectMake(0, 0, map.cellSize, map.cellSize))
        hero.characterIV = UIImageView(frame: hero.displayView.frame)
        hero.characterIV.image = UIImage(named: "hunter")
        hero.displayView.addSubview(hero.characterIV)
        hero.atk = 3.0
        hero.maxHP = 10.0
        hero.curHP = hero.maxHP
        hero.type = .Hunter
        return hero
    }
    
    //MARK: - Attack Methods
    
    func atkDmg() -> Double {
        let rand = Double(arc4random_uniform(100) + 1)
        if rand <= lck {
            return atk * 1.5
        }
        
        return atk
    }
    
    //MARK: - Item Methods
    
    func checkItems() {
        //Check Buff
        if buff != nil {
            if buff!.itemExpired() {
                self.removeItem(buff!)
                buff = nil
            }
        }
    }
    
    func removeItem(item: ItemObject) {
        if item.type == .Weapon { weapon = nil }
        if item.type == .Armor { armor = nil }
        if item.type == .Buff { buff = nil }
        
        self.atk -= item.atkBns
        self.def -= item.defBns
        self.maxHP -= item.maxHPBns
        self.curHP -= item.curHPBns
        self.lck -= item.lckBns
        self.reg -= item.regBns
        self.sty -= item.styBns
        
        if curHP > maxHP { curHP = maxHP }
    }
    
    func checkEquipment(item: ItemObject) {
        if item.type == .Weapon {
            if weapon != nil {
                removeItem(weapon!)
            }
            
            weapon = item
        }
        
        if item.type == .Armor {
            if armor != nil {
                removeItem(armor!)
            }
            
            armor = item
        }
        
        if item.type == .Buff {
            if buff != nil {
                removeItem(buff!)
            }
            
            buff = item
        }
    }
    
    func equipItem(item: ItemObject) {
        self.checkEquipment(item)
        self.atk += item.atkBns
        self.def += item.defBns
        self.maxHP += item.maxHPBns
        self.lck += item.lckBns
        self.reg += item.regBns
        self.sty += item.styBns
        
        heal(item.curHPBns)
    }
    
    //MARK: - Healing Methods
    
    func heal(amt: Double) {
        curHP += amt
        
        if curHP > maxHP { curHP = maxHP }
    }
    
    func regen() {
        heal(reg)
    }
    
    //MARK: - Experience Methods
    
    func gainExp(expGain: Double) -> Bool {
        exp += expGain
        
        if exp >= expNeeded {
            levelUp()
            return true
        }
        
        return false
    }
    
    func levelUp() {
        exp -= expNeeded
        lvl += 1
        expNeeded = pow(Double(lvl), 2) * 10
        
        if type == .Hunter {
            atk += 1.2
            def += 1.0
            maxHP += 5.0
            lck += 1.2
            reg += 0.01
        }
            
        else if type == .Knight {
            atk += 1.0
            def += 1.2
            maxHP += 7.0
            lck += 1.0
            reg += 0.01
        }
            
        else if type == .Cleric {
            atk += 1.0
            def += 1.0
            maxHP += 6.0
            lck += 1.0
            reg += 0.02
        }
            
        else {
            atk += 1.1
            def += 1.1
            maxHP += 6.0
            lck += 1.1
            reg += 0.01
        }
    }
}
