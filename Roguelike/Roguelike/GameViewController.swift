//
//  GameViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var maskView: UIView!
    
    var mapView: UIView!
    var treasureViews: [UIView]!
    var itemHUD: ItemHUDView!
    var HUD: HUDView!
    
    var game: GameObject!
    weak var delegate:GameViewControllerDelegate?
    var characterType: CharacterClass!
    
    var fadeSpeed = 3.0
    var leftSwipe: UISwipeGestureRecognizer!
    var rightSwipe: UISwipeGestureRecognizer!
    var upSwipe: UISwipeGestureRecognizer!
    var downSwipe: UISwipeGestureRecognizer!
    var longPress: UILongPressGestureRecognizer!
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        game = GameObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if HUD == nil {
            HUD = HUDView.GenerateHUDView()
            HUD.frame = CGRect(x: 0, y: self.view.frame.size.height - HUD.frame.size.height, width: self.view.frame.size.width, height: HUD.frame.size.height)
            self.view.addSubview(HUD)
        }
        
        if itemHUD == nil {
            itemHUD = ItemHUDView.GenerateItemHUDView()
            itemHUD.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: itemHUD.frame.size.height)
            self.view.addSubview(itemHUD)
        }
        
        self.view.bringSubview(toFront: maskView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if HUD != nil {
            HUD.updateHUD(self.game, speed: 0)
        }
        
        fadeBlack(0)
    }
    
    //MARK: - Gesture Recognition Methods
    
    func setupGestureRecognizers() {
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PortalViewController.leftSwipe(_:)))
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PortalViewController.rightSwipe(_:)))
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PortalViewController.upSwipe(_:)))
        downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(PortalViewController.downSwipe(_:)))
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(PortalViewController.longPress(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        longPress.minimumPressDuration = 0.5
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(upSwipe)
        self.view.addGestureRecognizer(downSwipe)
        self.view.addGestureRecognizer(longPress)
    }
    
    func changeSwipeEnabled(_ enabled: Bool) {
        leftSwipe.isEnabled = enabled
        rightSwipe.isEnabled = enabled
        upSwipe.isEnabled = enabled
        downSwipe.isEnabled = enabled
        longPress.isEnabled = enabled
    }
    
    func leftSwipe(_ recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPoint(x: game.player.coordinates.x - 1, y: game.player.coordinates.y)
        attemptToMovePlayerTo(newLocation, xMult: game.map.cellSize, yMult: 0)
    }
    
    func rightSwipe(_ recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPoint(x: game.player.coordinates.x + 1, y: game.player.coordinates.y)
        attemptToMovePlayerTo(newLocation, xMult: game.map.cellSize * -1, yMult: 0)
    }
    
    func upSwipe(_ recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPoint(x: game.player.coordinates.x, y: game.player.coordinates.y - 1)
        attemptToMovePlayerTo(newLocation, xMult: 0, yMult: game.map.cellSize)
    }
    
    func downSwipe(_ recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPoint(x: game.player.coordinates.x, y: game.player.coordinates.y + 1)
        attemptToMovePlayerTo(newLocation, xMult: 0, yMult: game.map.cellSize * -1)
    }
    
    func longPress(_ recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == .began) {
            moveEnemies()
        }
    }
    
    //MARK: - Display Methods
    
    func displayMap() {
        //Remove the old views from the map
        if mapView != nil {
            for subview in mapView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        treasureViews = []
        
        let width = game.map.gridSize.width * game.map.cellSize
        let height = game.map.gridSize.height * game.map.cellSize
        mapView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        mapView.center = self.view.center
        mapView.tag = 20
        mapView.alpha = 0
        self.view.addSubview(mapView)
        
        for (indexY, row) in game.map.cellmap.enumerated(){
            for (indexX, isWall) in row.enumerated(){
                if isWall {
                    let xPos = game.map.cellSize * CGFloat(indexX)
                    let yPos = game.map.cellSize * CGFloat(indexY)
                    let wall = UIImageView(frame: CGRect(x: xPos, y: yPos, width: game.map.cellSize, height: game.map.cellSize))
                    wall.image = UIImage(named: "tile1_0")
                    mapView.addSubview(wall)
                }
            }
        }
        
        for treasureLocation in game.map.treasureCoordinates {
            placeTreasure(mapView, coordinates: treasureLocation)
        }
        
        game.enemies = []
        for enemyLocation in game.map.enemyCoordinates {
            placeEnemy(mapView, coordinates: enemyLocation)
        }
        
        placeStairs(mapView, coordinates: game.map.stairCoordinates)
        placeSpawn(mapView, coordinates: game.map.spawnCoordinates)
        addPlayer()
        centerOnSpawn()
        
        if HUD != nil {
            self.view.bringSubview(toFront: HUD)
            HUD.updateHUD(self.game, speed: self.game.animSpeed)
        }
        
        if itemHUD != nil {
            self.view.bringSubview(toFront: itemHUD)
        }
        
        self.view.bringSubview(toFront: self.maskView)
    }
    
    func fadeBlack(_ val: CGFloat) {
        UIView.animate(withDuration: fadeSpeed, animations: {
            self.maskView.alpha = val
            self.mapView.alpha = 1
        }) 
    }
    
    func centerOnSpawn() {
        let x = game.map.spawnCoordinates.x * game.map.cellSize * -1 + self.view.frame.size.width/2 - game.map.cellSize/2
        let y = game.map.spawnCoordinates.y * game.map.cellSize * -1 + self.view.frame.size.height/2 - game.map.cellSize/2
        mapView.frame = CGRect(x: x, y: y, width: mapView.frame.size.width, height: mapView.frame.size.height)
    }
    
    //MARK: - Placement Methods
    
    func placeEnemy(_ view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x + game.map.cellSize/2
        let yPos = game.map.cellSize * coordinates.y + game.map.cellSize/2
        let enemy = EnemyObject.getRandomEnemy(game)
        enemy.coordinates = coordinates
        enemy.displayView.center = CGPoint(x: xPos, y: yPos)
        game.enemies.append(enemy)
        view.addSubview(enemy.displayView)
    }
    
    func placeTreasure(_ view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x
        let yPos = game.map.cellSize * coordinates.y
        let treasure = UIImageView(frame: CGRect(x: xPos, y: yPos, width: game.map.cellSize, height: game.map.cellSize))
        treasure.image = UIImage(named: "treasure")
        view.addSubview(treasure)
        treasureViews.append(treasure)
    }
    
    func placeStairs(_ view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x
        let yPos = game.map.cellSize * coordinates.y
        let stairs = UIImageView(frame: CGRect(x: xPos, y: yPos, width: game.map.cellSize, height: game.map.cellSize))
        stairs.image = UIImage(named: "stairs")
        view.addSubview(stairs)
    }
    
    func placeSpawn(_ view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x
        let yPos = game.map.cellSize * coordinates.y
        let spawn = UIView(frame: CGRect(x: xPos, y: yPos, width: game.map.cellSize, height: game.map.cellSize))
        view.addSubview(spawn)
    }
    
    func addPlayer() {
        if game.player == nil {
            game.player = PlayerObject.initHero(game.map, type: characterType)
        }
        
        game.player.coordinates = game.map.spawnCoordinates
        game.player.displayView.center = self.view.center
        self.view.addSubview(game.player.displayView)
    }
    
    //MARK: - Collision Detection Methods
    
    func attemptToMovePlayerTo(_ newLocation: CGPoint, xMult: CGFloat, yMult: CGFloat) {
        let spaceValidity = CollisionHelper().spaceIsValid(game, location: newLocation)
        if spaceValidity < 1 {
            //Stairs?
            if spaceValidity == -1 {
                delegate!.portalTouched()
            }
            
            else {
                game.player.regen()
            }
            
            game.player.coordinates = newLocation
            UIView.animate(withDuration: game.animSpeed, animations: {
                self.mapView.center = CGPoint(x: self.mapView.center.x + xMult, y: self.mapView.center.y + yMult)
            })
        }
            
        else {
            //What did we hit?
            //Treasure
            if spaceValidity == 2 {
                let tuple = CollisionHelper().treasureAtLocation(game, location: newLocation)
                
                if tuple.item != nil {
                    self.treasureTouched(tuple.item, index: tuple.index)
                }
            }
            
            //Enemy
            if spaceValidity == 3 {
                if let enemy = CollisionHelper().enemyAtLocation(game, location: newLocation) {
                    if enemy.takeDamage(game.player.atkDmg()) {
                        enemy.killUnit(game)
                        
                        if game.player.gainExp(enemy.exp) {
                            LabelHelper.showString("LEVEL UP!", view: game.player.displayView)
                        }
                    }
                }
            }
            
            //Animate the bump
            let oldCenter = game.player.displayView.center
            UIView.animate(withDuration: game.animSpeed/2, animations: {
                self.game.player.displayView.center = CGPoint(x: self.game.player.displayView.center.x - xMult/2, y: self.game.player.displayView.center.y - yMult/2)
                }, completion: { (Bool) in
                    UIView.animate(withDuration: self.game.animSpeed/2, animations: {
                        self.game.player.displayView.center = oldCenter
                    })
            })
        }
        
        if spaceValidity != 1 {
            let delayTime = DispatchTime.now() + Double(Int64(game.animSpeed * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.game.player.checkItems()
                self.moveEnemies()
                self.itemHUD.updateHUD(self.game.player)
            }
        }
        
        HUD.updateHUD(self.game, speed: self.game.animSpeed)
    }
    
    func moveEnemies() {
        self.changeSwipeEnabled(false)
        for enemy in game.enemies {
            enemy.determineDirection(game)
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(game.animSpeed/2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.changeSwipeEnabled(true)
            self.HUD.updateHUD(self.game, speed: self.game.animSpeed)
        }
    }
    
    func treasureTouched(_ item: ItemObject!, index: Int) {
        var message = "The chest before you contains an item:\n\(item.name)"
        
        if item.type == .weapon && game.player.weapon != nil { message = message + "\n\nThis will replace your current weapon" }
        if item.type == .armor && game.player.armor != nil { message = message + "\n\nThis will replace your current armor" }
        if item.type == .buff && game.player.buff != nil { message = message + "\n\nThis will replace your current buff" }
        
        let alert = UIAlertController(title: message, message: "Will you take the \(item.name)?", preferredStyle: .alert)
        let stepAction = UIAlertAction(title: "Take Item", style: .default, handler: { (UIAlertAction) in
            self.game.player.equipItem(item!)
            self.itemHUD.updateHUD(self.game.player)
            self.HUD.updateHUD(self.game, speed: self.game.animSpeed)
            self.game.map.treasureCoordinates.remove(at: index)
            self.game.map.treasures.remove(at: index)
            
            let treasureView = self.treasureViews[index]
            
            DispatchQueue.main.async(execute: {
                UIView.animate(withDuration: self.game.animSpeed, animations: {
                    treasureView.alpha = 0
                    }, completion: { (Bool) in
                        treasureView.removeFromSuperview()
                        self.treasureViews.remove(at: index)
                })
            })
        })
        
        let stayAction = UIAlertAction(title: "Leave Item", style: .destructive, handler: nil)
        
        alert.addAction(stayAction)
        alert.addAction(stepAction)
        self.present(alert, animated: true, completion: nil)
    }
}

protocol GameViewControllerDelegate: class {
    func portalTouched()
}
