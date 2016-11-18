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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if HUD == nil {
            HUD = HUDView.GenerateHUDView()
            HUD.frame = CGRectMake(0, self.view.frame.size.height - HUD.frame.size.height, self.view.frame.size.width, HUD.frame.size.height)
            self.view.addSubview(HUD)
        }
        
        if itemHUD == nil {
            itemHUD = ItemHUDView.GenerateItemHUDView()
            itemHUD.frame = CGRectMake(0, 0, self.view.frame.size.width, itemHUD.frame.size.height)
            self.view.addSubview(itemHUD)
        }
        
        self.view.bringSubviewToFront(maskView)
    }
    
    override func viewDidAppear(animated: Bool) {
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
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        longPress.minimumPressDuration = 0.5
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(upSwipe)
        self.view.addGestureRecognizer(downSwipe)
        self.view.addGestureRecognizer(longPress)
    }
    
    func changeSwipeEnabled(enabled: Bool) {
        leftSwipe.enabled = enabled
        rightSwipe.enabled = enabled
        upSwipe.enabled = enabled
        downSwipe.enabled = enabled
        longPress.enabled = enabled
    }
    
    func leftSwipe(recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPointMake(game.player.coordinates.x - 1, game.player.coordinates.y)
        attemptToMovePlayerTo(newLocation, xMult: game.map.cellSize, yMult: 0)
    }
    
    func rightSwipe(recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPointMake(game.player.coordinates.x + 1, game.player.coordinates.y)
        attemptToMovePlayerTo(newLocation, xMult: game.map.cellSize * -1, yMult: 0)
    }
    
    func upSwipe(recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPointMake(game.player.coordinates.x, game.player.coordinates.y - 1)
        attemptToMovePlayerTo(newLocation, xMult: 0, yMult: game.map.cellSize)
    }
    
    func downSwipe(recognizer: UISwipeGestureRecognizer) {
        let newLocation = CGPointMake(game.player.coordinates.x, game.player.coordinates.y + 1)
        attemptToMovePlayerTo(newLocation, xMult: 0, yMult: game.map.cellSize * -1)
    }
    
    func longPress(recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == .Began) {
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
        mapView = UIView(frame: CGRectMake(0, 0, width, height))
        mapView.center = self.view.center
        mapView.tag = 20
        mapView.alpha = 0
        self.view.addSubview(mapView)
        
        for (indexY, row) in game.map.cellmap.enumerate(){
            for (indexX, isWall) in row.enumerate(){
                if isWall {
                    let xPos = game.map.cellSize * CGFloat(indexX)
                    let yPos = game.map.cellSize * CGFloat(indexY)
                    let wall = UIImageView(frame: CGRectMake(xPos, yPos, game.map.cellSize, game.map.cellSize))
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
            self.view.bringSubviewToFront(HUD)
            HUD.updateHUD(self.game, speed: self.game.animSpeed)
        }
        
        if itemHUD != nil {
            self.view.bringSubviewToFront(itemHUD)
        }
        
        self.view.bringSubviewToFront(self.maskView)
    }
    
    func fadeBlack(val: CGFloat) {
        UIView.animateWithDuration(fadeSpeed) {
            self.maskView.alpha = val
            self.mapView.alpha = 1
        }
    }
    
    func centerOnSpawn() {
        let x = game.map.spawnCoordinates.x * game.map.cellSize * -1 + self.view.frame.size.width/2 - game.map.cellSize/2
        let y = game.map.spawnCoordinates.y * game.map.cellSize * -1 + self.view.frame.size.height/2 - game.map.cellSize/2
        mapView.frame = CGRectMake(x, y, mapView.frame.size.width, mapView.frame.size.height)
    }
    
    //MARK: - Placement Methods
    
    func placeEnemy(view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x + game.map.cellSize/2
        let yPos = game.map.cellSize * coordinates.y + game.map.cellSize/2
        let enemy = EnemyObject.getRandomEnemy(game)
        enemy.coordinates = coordinates
        enemy.displayView.center = CGPointMake(xPos, yPos)
        game.enemies.append(enemy)
        view.addSubview(enemy.displayView)
    }
    
    func placeTreasure(view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x
        let yPos = game.map.cellSize * coordinates.y
        let treasure = UIImageView(frame: CGRectMake(xPos, yPos, game.map.cellSize, game.map.cellSize))
        treasure.image = UIImage(named: "treasure")
        view.addSubview(treasure)
        treasureViews.append(treasure)
    }
    
    func placeStairs(view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x
        let yPos = game.map.cellSize * coordinates.y
        let stairs = UIImageView(frame: CGRectMake(xPos, yPos, game.map.cellSize, game.map.cellSize))
        stairs.image = UIImage(named: "stairs")
        view.addSubview(stairs)
    }
    
    func placeSpawn(view: UIView, coordinates: CGPoint) {
        let xPos = game.map.cellSize * coordinates.x
        let yPos = game.map.cellSize * coordinates.y
        let spawn = UIView(frame: CGRectMake(xPos, yPos, game.map.cellSize, game.map.cellSize))
        view.addSubview(spawn)
    }
    
    func addPlayer() {
        if game.player == nil {
            game.player = PlayerObject.initHero(game.map)
        }
        
        game.player.coordinates = game.map.spawnCoordinates
        game.player.displayView.center = self.view.center
        self.view.addSubview(game.player.displayView)
    }
    
    //MARK: - Collision Detection Methods
    
    func attemptToMovePlayerTo(newLocation: CGPoint, xMult: CGFloat, yMult: CGFloat) {
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
            UIView.animateWithDuration(game.animSpeed, animations: {
                self.mapView.center = CGPointMake(self.mapView.center.x + xMult, self.mapView.center.y + yMult)
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
                            print("LEVEL UP!")
                        }
                    }
                }
            }
            
            //Animate the bump
            let oldCenter = game.player.displayView.center
            UIView.animateWithDuration(game.animSpeed/2, animations: {
                self.game.player.displayView.center = CGPointMake(self.game.player.displayView.center.x - xMult/2, self.game.player.displayView.center.y - yMult/2)
                }, completion: { (Bool) in
                    UIView.animateWithDuration(self.game.animSpeed/2, animations: {
                        self.game.player.displayView.center = oldCenter
                    })
            })
        }
        
        if spaceValidity != 1 {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(game.animSpeed * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
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
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(game.animSpeed/2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.changeSwipeEnabled(true)
            self.HUD.updateHUD(self.game, speed: self.game.animSpeed)
        }
    }
    
    func treasureTouched(item: ItemObject!, index: Int) {
        var message = "The chest before you contains an item:\n\(item.name)"
        
        if item.type == .Weapon && game.player.weapon != nil { message = message.stringByAppendingString("\n\nThis will replace your current weapon") }
        if item.type == .Armor && game.player.armor != nil { message = message.stringByAppendingString("\n\nThis will replace your current armor") }
        if item.type == .Buff && game.player.buff != nil { message = message.stringByAppendingString("\n\nThis will replace your current buff") }
        
        let alert = UIAlertController(title: message, message: "Will you take the \(item.name)?", preferredStyle: .Alert)
        let stepAction = UIAlertAction(title: "Take Item", style: .Default, handler: { (UIAlertAction) in
            self.game.player.equipItem(item!)
            self.itemHUD.updateHUD(self.game.player)
            self.HUD.updateHUD(self.game, speed: self.game.animSpeed)
            self.game.map.treasureCoordinates.removeAtIndex(index)
            self.game.map.treasures.removeAtIndex(index)
            
            let treasureView = self.treasureViews[index]
            
            dispatch_async(dispatch_get_main_queue(),{
                UIView.animateWithDuration(self.game.animSpeed, animations: {
                    treasureView.alpha = 0
                    }, completion: { (Bool) in
                        treasureView.removeFromSuperview()
                        self.treasureViews.removeAtIndex(index)
                })
            })
        })
        
        let stayAction = UIAlertAction(title: "Leave Item", style: .Destructive, handler: nil)
        
        alert.addAction(stayAction)
        alert.addAction(stepAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

protocol GameViewControllerDelegate: class {
    func portalTouched()
}