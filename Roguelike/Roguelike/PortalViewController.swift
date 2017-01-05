//
//  PortalViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/7/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class PortalViewController: GameViewController {
    
    @IBOutlet var puzzleBtn: UIButton!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupGestureRecognizers()
        game.map = CAMap()
        createMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.alpha = 1
    }
    
    func createMap() {
        var width = 10 + (game.floor/2 + 1)
        var height = 10 + (game.floor/2)
        
        //Don't let the maps get out of hand
        if width > 150 { width = 150 }
        if height > 150 { height = 150 }
        
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
        game.map = CAMap().createMap(size, floor: game.floor)
        
        while game.map == nil {
            game.map = CAMap().createMap(size, floor: game.floor)
        }
        
        displayMap()
        self.view.bringSubview(toFront: puzzleBtn)
    }
    
    //MARK: - Dialogue Example
    
    func startDialogue() {
        let dialogue1 = DialogueInfo(left: "hunter", right: nil, text: "The protagonist says: Hey dude, where am I?")
        let dialogue2 = DialogueInfo(left: nil, right: "enemy", text: "The enemy says: Raaaargh, *teeth gnashing & general unpleasantness*")
        let dialogue3 = DialogueInfo(left: "hunter", right: nil, text: "HOLY CHRIST, WHAT'S WRONG WITH YOU!?!?!")
        let chain = [dialogue1, dialogue2, dialogue3]
        DialogueView.generateInView(self, dialogue: chain)
    }
    
    //MARK: - Puzzle Example
    
    func startPuzzle() {
        PuzzleView.generateInView(self)
    }
    
    //MARK: - IBActions
    
    @IBAction func puzzlePressed(_ sender: UIButton) {
        startPuzzle()
    }
}

extension PortalViewController: GameViewControllerDelegate {
    func portalTouched() {
        let alert = UIAlertController(title: "A glowing portal gapes before you...", message: "Step through?", preferredStyle: .alert)
        let stepAction = UIAlertAction(title: "Step Through", style: .default, handler: { (UIAlertAction) in
            self.game.floor += 1
            self.fadeBlack(1)
            
            let delayTime = DispatchTime.now() + Double(Int64(self.fadeSpeed * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                if self.game.player.loseSanity(1.0) {
                    print("died")
                }
                
                else {
                    self.createMap()
                    self.fadeBlack(0)
                }
            }
        })
        
        let stayAction = UIAlertAction(title: "Stay Here", style: .destructive, handler: nil)
        
        alert.addAction(stayAction)
        alert.addAction(stepAction)
        self.present(alert, animated: true, completion: nil)
    }
}
