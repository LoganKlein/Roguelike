//
//  PortalViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/7/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class PortalViewController: GameViewController {
    
    @IBOutlet var talkBtn: UIButton!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupGestureRecognizers()
        game.map = CAMap()
        createMap()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.alpha = 1
    }
    
    func createMap() {
        var width = 10 + (game.floor/2 + 1)
        var height = 10 + (game.floor/2)
        
        //Don't let the maps get out of hand
        if width > 150 { width = 150 }
        if height > 150 { height = 150 }
        
        let size = CGSizeMake(CGFloat(width), CGFloat(height))
        game.map = CAMap().createMap(size, floor: game.floor)
        
        while game.map == nil {
            game.map = CAMap().createMap(size, floor: game.floor)
        }
        
        displayMap()
        self.view.bringSubviewToFront(talkBtn)
    }
    
    func startDialogue() {
        let dialogue1 = DialogueInfo(left: "hunter", right: nil, text: "The protagonist says: Hey dude, where am I?")
        let dialogue2 = DialogueInfo(left: nil, right: "enemy", text: "The enemy says: Raaaargh, *teeth gnashing & general unpleasantness*")
        let dialogue3 = DialogueInfo(left: "hunter", right: nil, text: "HOLY CHRIST, WHAT'S WRONG WITH YOU!?!?!")
        let chain = [dialogue1, dialogue2, dialogue3]
        DialogueView.generateInView(self, dialogue: chain)
    }
    
    //MARK: - IBActions
    
    @IBAction func talkPressed(sender: UIButton) {
        startDialogue()
    }
}

extension PortalViewController: GameViewControllerDelegate {
    func portalTouched() {
        let alert = UIAlertController(title: "A glowing portal gapes before you...", message: "Step through?", preferredStyle: .Alert)
        let stepAction = UIAlertAction(title: "Step Through", style: .Default, handler: { (UIAlertAction) in
            self.game.floor += 1
            self.fadeBlack(1)
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.fadeSpeed * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.game.player.loseSanity(1.0)
                self.createMap()
                self.fadeBlack(0)
            }
        })
        
        let stayAction = UIAlertAction(title: "Stay Here", style: .Destructive, handler: nil)
        
        alert.addAction(stayAction)
        alert.addAction(stepAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}