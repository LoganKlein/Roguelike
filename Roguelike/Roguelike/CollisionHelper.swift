//
//  CollisionHelper.swift
//  Roguelike
//
//  Created by Logan Klein on 11/10/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class CollisionHelper: NSObject {
    func spaceIsValid(game:GameObject, location: CGPoint) -> Int {
        let x = Int(location.x)
        let y = Int(location.y)
        
        //Stairs
        if game.map.stairCoordinates == location { return -1 }
        
        //Wall
        if game.map.cellmap[y][x] { return 1 }
        
        //Treasure
        if game.map.treasureCoordinates.contains(location) { return 2 }
        
        //Enemy
        for enemy in game.enemies {
            if enemy.coordinates == location { return 3 }
        }
        
        //Player
        if game.player.coordinates == location { return 4 }
        
        return 0
    }
    
    func enemyAtLocation(game: GameObject, location: CGPoint) -> EnemyObject? {
        for enemy in game.enemies {
            if enemy.coordinates == location {
                return enemy
            }
        }
        
        return nil
    }
    
    func treasureAtLocation(game: GameObject, location: CGPoint) -> (item: ItemObject?, index: Int) {
        for treasureLocation in game.map.treasureCoordinates {
            if treasureLocation == location {
                let index = game.map.treasureCoordinates.indexOf(treasureLocation)
                let treasure = game.map.treasures[index!]
                return (treasure, index!)
            }
        }
        
        return (nil, -1)
    }
}
