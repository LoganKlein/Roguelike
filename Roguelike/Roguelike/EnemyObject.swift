//
//  EnemyObject.swift
//  Roguelike
//
//  Created by Logan Klein on 11/17/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class EnemyObject: CharacterObject {
    var name = ""
    var visionRange = 2
    var minFloor = 0
    var maxFloor = 0
    
    //MARK: - Initialization Methods
    
    class func getRandomEnemy(game: GameObject) -> EnemyObject {
        var enemies = EnemyObject.getEnemies("enemies", game: game)
        enemies.shuffle()
        let enemy = enemies.first
        return enemy!
    }
    
    class func getEnemies(name: String, game: GameObject) -> [EnemyObject] {
        let json: [NSDictionary] = JSONHelper.getArrayFromFile(name)
        var enemyArray: [EnemyObject] = []
        
        for dict in json {
            let enemy = EnemyObject.enemyFromInfo(dict, game: game)
            enemyArray.append(enemy)
        }
        
        return enemyArray
    }
    
    class func enemyFromInfo(dict: NSDictionary, game: GameObject) -> EnemyObject {
        let enemy = EnemyObject()
        enemy.name = dict["name"] as! String
        enemy.atk = dict["atk"] as! Double
        enemy.def = dict["def"] as! Double
        enemy.maxHP = dict["maxHP"] as! Double
        enemy.lvl = dict["lvl"] as! Int
        enemy.exp = dict["exp"] as! Double
        enemy.visionRange = dict["visionRange"] as! Int
        enemy.minFloor = dict["visionRange"] as! Int
        enemy.maxFloor = dict["visionRange"] as! Int
        enemy.curHP = enemy.maxHP
        
        let imageName = dict["image"] as! String
        enemy.displayView = UIView(frame: CGRectMake(0, 0, game.map.cellSize, game.map.cellSize))
        enemy.characterIV = UIImageView(frame: enemy.displayView.frame)
        enemy.characterIV.image = UIImage(named: imageName)
        enemy.displayView.addSubview(enemy.characterIV)
        return enemy
    }
    
    //MARK: - Location Methods
    
    func determineDirection(game: GameObject) {
        var newLocation = coordinates
        
        //First, determine if the hero is in visible range
        let tuple = nearHero(game.player)
        if tuple.near {
            newLocation = coordinates
            var validity: Int = 0
            
            if tuple.yDif < 0 {
                newLocation.y -= 1
            }
            
            validity = CollisionHelper().spaceIsValid(game, location: newLocation)
            
            if ( tuple.yDif > 0 && validity != 0 && validity != 4 ) {
                newLocation = coordinates
                newLocation.y += 1
            }
            
            validity = CollisionHelper().spaceIsValid(game, location: newLocation)
            
            if (tuple.xDif < 0 && validity != 0 && validity != 4 ) {
                newLocation = coordinates
                newLocation.x -= 1
            }
            
            validity = CollisionHelper().spaceIsValid(game, location: newLocation)
            
            if ( validity != 0 && validity != 4 ) {
                newLocation = coordinates
                newLocation.x += 1
            }
            
            validity = CollisionHelper().spaceIsValid(game, location: newLocation)
            
            if validity == 0 {
                moveTo(newLocation, map: game.map)
            }
                
            else if validity == 4 {
                bumpHero(game.map, hero: game.player, xDif: tuple.xDif, yDif: tuple.yDif)
                return
            }
        }
            
            //Otherwise, just wander around
        else {
            var tries = 0
            let direction = arc4random()%4
            
            while tries < 4 {
                newLocation = coordinates
                
                if direction == 0 { newLocation.y -= 1 }        //Up
                else if direction == 1 { newLocation.y += 1 }   //Down
                else if direction == 2 { newLocation.x -= 1 }   //Left
                else if direction == 3 { newLocation.x += 1 }   //Right
                
                let validity = CollisionHelper().spaceIsValid(game, location: newLocation)
                
                if validity == 0 {
                    tries = 5
                    moveTo(newLocation, map: game.map)
                }
                    
                else {
                    tries += 1
                    newLocation = coordinates
                }
            }
        }
    }
    
    func nearHero(hero: CharacterObject) -> (near: Bool, xDif: Int, yDif: Int) {
        let xDif = hero.coordinates.x - coordinates.x
        let yDif = hero.coordinates.y - coordinates.y
        let inXRange = (Int(xDif) >= visionRange * -1 && Int(xDif) <= visionRange)
        let inYRange = (Int(yDif) >= visionRange * -1 && Int(yDif) <= visionRange)
        return ((inXRange && inYRange), Int(xDif), Int(yDif))
    }
    
    //MARK: - Animation Methods
    
    func bumpHero(map: CAMap, hero: CharacterObject, xDif: Int, yDif: Int) {
        let oldCenter = self.displayView.center
        
        var newX = self.displayView.center.x
        var newY = self.displayView.center.y
        
        if xDif > 0 {newX += map.cellSize/2}
        else if xDif < 0 {newX -= map.cellSize/2}
        if yDif > 0 {newY += map.cellSize/2}
        else if yDif < 0 {newY -= map.cellSize/2}
        
        UIView.animateWithDuration(0.1, animations: {
            self.displayView.center = CGPointMake(newX, newY)
            }, completion: { (Bool) in
                UIView.animateWithDuration(0.1, animations: {
                    self.displayView.center = oldCenter
                    hero.takeDamage(self.atk)
                })
        })
    }
    
    //MARK: - Modification Methods
    
    func killUnit(game: GameObject) {
        let index = game.enemies.indexOf(self)
        game.enemies.removeAtIndex(index!)
        
        UIView.animateWithDuration(game.animSpeed, delay: game.animSpeed, options: .CurveEaseOut, animations: {
            self.characterIV.alpha = 0
        }) { (Bool) in
            self.displayView.removeFromSuperview()
        }
    }
}
