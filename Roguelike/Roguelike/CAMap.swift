//
//  CAMap.swift
//  Roguelike
//
//  Created by Logan Klein on 11/8/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit
import GameKit

class CAMap: GameMap {
    var checkedMap:[[Bool]]!
    var floor: Int!
    
    let chanceToStartAlive = 35
    let deathLimit = 3
    let birthLimit = 4
    var generations = 5
    var visitedLocations: [CGPoint]!
    
    //MARK: - Initialization Methods
    
    func createMap(_ size: CGSize, floor: Int) -> CAMap? {
        self.gridSize = size
        print("New Map!")
        var startTime = Date()
        generateMap(floor)
        print("map generated \t(took: \(Date().timeIntervalSince(startTime)))")
        startTime = Date()
        
        checkedMap = Array(repeating: Array(repeating: false, count: Int(gridSize.width)), count: Int(gridSize.height))
        floodFill(Int(spawnCoordinates.x), y: Int(spawnCoordinates.y))
        print("map filled \t\t(took: \(Date().timeIntervalSince(startTime)))")
        startTime = Date()
        
        if !canVisitAllImportantCoordinates() {
            print("map discarded :(")
            createMap(size, floor: floor)
            return nil
        }
        
        print("map checked \t(took: \(Date().timeIntervalSince(startTime)))")
        return self
    }
    
    func generateMap(_ floor: Int) {
        cellmap = Array(repeating: Array(repeating: false, count: Int(gridSize.width)), count: Int(gridSize.height))
        cellmap = initializeMap(Int(gridSize.width), yIndex:Int(gridSize.height))
        
        for _ in 0...generations {
            nextGeneration()
        }
        
        visitedLocations = []
        
        let treasureCount = max(floor/10, 1)
        let enemyCount = max(floor/5, 1)
        findUniqueLocations(treasureCount, enemies: enemyCount)
    }
    
    func initializeMap(_ xIndex:Int, yIndex:Int) -> [[Bool]]{
        var map:[[Bool]] = Array(repeating: Array(repeating: false, count: xIndex), count: yIndex)
        
        for y in 0...(yIndex - 1) {
            for x in 0...(xIndex - 1) {
                let diceRoll = Int(arc4random_uniform(100))
                
                if diceRoll < chanceToStartAlive { map[y][x] = true }
                else { map[y][x] = false }
            }
        }
        
        return map
    }
    
    func nextGeneration() {
        var newMap:[[Bool]] = Array(repeating: Array(repeating: false, count: Int(gridSize.width)), count: Int(gridSize.height))
        
        for y in 0...(cellmap.count - 1) {
            for x in 0...(cellmap[0].count - 1) {
                let nbs = countAliveNeighbours( x, y: y)
                
                if(cellmap[y][x]){
                    if(nbs < deathLimit) { newMap[y][x] = false }
                    else { newMap[y][x] = true }
                }
                
                else {
                    if(nbs > birthLimit) { newMap[y][x] = true }
                    else { newMap[y][x] = false }
                }
                
                //Make sure there is a wall around the outside edge
                if ( x == 0 || y == 0 || x == Int(gridSize.width - 1) || y == Int(gridSize.height - 1) ) {
                    newMap[y][x] = true
                }
            }
        }
        
        cellmap = newMap
    }
    
    //MARK: - Quality Checking Methods
    
    func floodFill(_ x: Int, y: Int) {
        let currentLocation = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        if (x < 0 || x > Int(gridSize.width) || y < 0 || y > Int(gridSize.height)) { return }
        if cellmap[y][x] { return }
        if checkedMap[y][x] { return }
        
        visitedLocations.append(currentLocation)
        checkedMap[y][x] = true
        floodFill(x+1, y: y)
        floodFill(x-1, y: y)
        floodFill(x, y: y+1)
        floodFill(x, y: y-1)
    }
    
    func canVisitAllImportantCoordinates() -> Bool {
        if !visitedLocations.contains(stairCoordinates) { return false }
        
        for enemy in enemyCoordinates {
            if !visitedLocations.contains(enemy) { return false }
        }
        
        for treasure in treasureCoordinates {
            if !visitedLocations.contains(treasure) { return false }
        }
        
        return true
    }
}
