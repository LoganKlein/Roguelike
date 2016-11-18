//
//  ItemObject.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

enum ItemType: Int {
    case Consumable = 0
    case Armor
    case Weapon
    case Buff
}

class ItemObject: NSObject {
    var name = ""
    var imageName = ""
    var atkBns = 0.0
    var defBns = 0.0
    var maxHPBns = 0.0
    var curHPBns = 0.0
    var lckBns = 0.0
    var regBns = 0.0
    var styBns = 0.0
    var duration = 0
    var minFloor = 0
    var maxFloor = 0
    var type: ItemType!
    
    func itemExpired() -> Bool {
        duration -= 1
        if duration <= 0 {
            return true
        }
        
        return false
    }
    
    //MARK: - Retrieval Methods
    
    class func itemFromInfo(dict: NSDictionary) -> ItemObject {
        let item = ItemObject()
        item.name = dict["name"] as! String
        item.imageName = dict["image"] as! String
        item.atkBns = dict["atkBns"] as! Double
        item.defBns = dict["defBns"] as! Double
        item.maxHPBns = dict["maxHPBns"] as! Double
        item.curHPBns = dict["curHPBns"] as! Double
        item.lckBns = dict["lckBns"] as! Double
        item.regBns = dict["regBns"] as! Double
        item.styBns = dict["styBns"] as! Double
        item.duration = dict["duration"] as! Int
        let type = dict["type"] as! Int
        item.type = ItemType.init(rawValue: type)
        return item
    }
    
    class func getItemSet(name: String) -> [ItemObject] {
        let json: [NSDictionary] = JSONHelper.getArrayFromFile(name)
        var itemArray: [ItemObject] = []
        
        for dict in json {
            let item = ItemObject.itemFromInfo(dict)
            itemArray.append(item)
        }
        
        return itemArray
    }
    
    class func getRandomTreasure() -> ItemObject {
        let types = ["consumables", "armor", "weapons", "buffs"]
        let randNum = arc4random()%UInt32(types.count)
        let randType = types[Int(randNum)]
        let itemArray = ItemObject.getItemSet(randType)
        let randItem = arc4random()%UInt32(itemArray.count)
        let treasure = itemArray[Int(randItem)]
        return treasure
    }
}