//
//  PlayerObject.swift
//  Roguelike
//
//  Created by Logan Klein on 11/17/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

enum CharacterClass: Int {
    case resilient = 0
    case deadly
    case persistent
    case mad
}

class PlayerObject: CharacterObject {
    var lck = 2.0
    var reg = 0.1
    var sty = 100.0
    var expNeeded = 20.0
    
    var weapon: ItemObject? = nil
    var armor: ItemObject? = nil
    var buff: ItemObject? = nil
    
    var type: CharacterClass!
    
    //MARK: - Initialization Methods
    
    class func initHero(_ map: CAMap, type: CharacterClass) -> PlayerObject {
        let hero = PlayerObject()
        hero.displayView = UIView(frame: CGRect(x: 0, y: 0, width: map.cellSize, height: map.cellSize))
        hero.characterIV = UIImageView(frame: hero.displayView.frame)
        hero.displayView.addSubview(hero.characterIV)
        
        hero.atk = 2.0
        hero.maxHP = 10.0
        hero.curHP = hero.maxHP
        hero.type = type
        
        //Finish starting stats
        if type == .resilient {
            hero.characterIV.image = UIImage(named: "knight")
            hero.def += 2.0
            hero.maxHP += 5.0
            hero.curHP = hero.maxHP
        }
        
        else if type == .deadly {
            hero.characterIV.image = UIImage(named: "hunter")
            hero.atk += 2.0
            hero.lck += 3.0
        }
        
        else if type == .persistent {
            hero.characterIV.image = UIImage(named: "cleric")
            hero.reg += 0.2
        }
        
        else if type == .mad {
            hero.characterIV.image = UIImage(named: "prophet")
            hero.sty = 50.0
        }
        
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
    
    func removeItem(_ item: ItemObject) {
        if item.type == .weapon { weapon = nil }
        if item.type == .armor { armor = nil }
        if item.type == .buff { buff = nil }
        
        self.atk -= item.atkBns
        self.def -= item.defBns
        self.maxHP -= item.maxHPBns
        self.curHP -= item.curHPBns
        self.lck -= item.lckBns
        self.reg -= item.regBns
        self.sty -= item.styBns
        
        if curHP > maxHP { curHP = maxHP }
    }
    
    func checkEquipment(_ item: ItemObject) {
        if item.type == .weapon {
            if weapon != nil {
                removeItem(weapon!)
            }
            
            weapon = item
        }
        
        if item.type == .armor {
            if armor != nil {
                removeItem(armor!)
            }
            
            armor = item
        }
        
        if item.type == .buff {
            if buff != nil {
                removeItem(buff!)
            }
            
            buff = item
        }
    }
    
    func equipItem(_ item: ItemObject) {
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
    
    func heal(_ amt: Double) {
        curHP += amt
        
        if curHP > maxHP { curHP = maxHP }
    }
    
    func regen() {
        heal(reg)
    }
    
    func loseSanity(_ amt: Double) -> Bool {
        //The Madman does not lose sanity
        if type == .mad { return false }
        
        sty -= amt
        
        //If sanity drops to zero, the character goes insane
        if sty <= 0 { return true }
        
        return false
    }
    
    //MARK: - Experience Methods
    
    func gainExp(_ expGain: Double) -> Bool {
        let sanityBoost = expGain - (expGain * (sty/100.0))
        exp += expGain + sanityBoost
        
        if exp >= expNeeded {
            while exp > expNeeded {
                levelUp()
            }
            
            return true
        }
        
        return false
    }
    
    func levelUp() {
        exp -= expNeeded
        lvl += 1
        expNeeded = pow(Double(lvl), 2) * 10
        
        if type == .resilient {
            atk += 1.0
            def += 1.2
            maxHP += 7.0
            lck += 1.0
            reg += 0.05
        }
            
        else if type == .deadly {
            atk += 1.2
            def += 1.0
            maxHP += 5.0
            lck += 1.2
            reg += 0.05
        }
            
        else if type == .persistent {
            atk += 1.0
            def += 1.0
            maxHP += 6.0
            lck += 1.0
            reg += 0.1
        }
            
        else {
            atk += 1.1
            def += 1.1
            maxHP += 6.0
            lck += 1.1
            reg += 0.05
        }
    }
}
