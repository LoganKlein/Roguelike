//
//  GameMap.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class GameMap: NSObject {
    var cellmap:[[Bool]]!
    var gridSize = CGSize(width: 20, height: 20)
    var cellSize: CGFloat = 50.0
    
    var treasures: [ItemObject] = []
    var treasureCoordinates: [CGPoint]!
    var enemyCoordinates: [CGPoint]!
    var stairCoordinates: CGPoint!
    var spawnCoordinates: CGPoint!
    
    //Placement Methods
    
    func countAliveNeighbours(_ x:Int, y:Int) -> Int{
        var count = 0
        var neighbour_x = 0
        var neighbour_y = 0
        
        for i in -1...1 {
            for j in -1...1 {
                neighbour_x = x + j
                neighbour_y = y + i
                
                if(i == 0 && j == 0) {}
                    
                else if(neighbour_x < 0 || neighbour_y < 0 || neighbour_y >= cellmap.count || neighbour_x >= cellmap[0].count) {
                    count = count + 1
                }
                    
                else if(cellmap[neighbour_y][neighbour_x]) {
                    count = count + 1
                }
            }
        }
        
        return count
    }
    
    func findUniqueLocations(_ treasure: Int, enemies: Int) {
        let enemyHiddenLimit = 0
        let stairHiddenLimit = 3
        let treasureHiddenLimit = 4
        var possibleEnemyLocations: [CGPoint] = []
        var possibleStairLocations: [CGPoint] = []
        var possibleTreasureLocations: [CGPoint] = []
        
        for y in 0...(cellmap.count - 1) {
            for x in 0...(cellmap[0].count - 1) {
                if !cellmap[y][x] {
                    let nbs = countAliveNeighbours(x, y: y)
                    let coord = CGPoint(x: CGFloat(x), y: CGFloat(y))
                    
                    if nbs >= treasureHiddenLimit {
                        possibleTreasureLocations.append(coord)
                    }
                        
                    else if nbs >= stairHiddenLimit {
                        possibleStairLocations.append(coord)
                    }
                        
                    else if nbs >= enemyHiddenLimit {
                        possibleEnemyLocations.append(coord)
                    }
                }
            }
        }
        
        //Randomize the location lists
        possibleEnemyLocations.shuffle()
        possibleStairLocations.shuffle()
        possibleTreasureLocations.shuffle()
        
        //Select the coordinates from the randomized lists
        enemyCoordinates = Array(possibleEnemyLocations.prefix(enemies))
        stairCoordinates = possibleStairLocations.first
        treasureCoordinates = Array(possibleTreasureLocations.prefix(treasure))
        spawnCoordinates = possibleEnemyLocations.last
        assignTreasure()
    }
    
    func assignTreasure() {
        treasures = []
        
        for _ in 0...treasureCoordinates.count - 1 {
            let treasure = ItemObject.getRandomTreasure()
            treasures.append(treasure)
        }
    }
}
