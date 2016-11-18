//
//  PortalViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/7/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class PortalViewController: GameViewController {
    
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
        let width = 10 + (game.floor/2 + 1)
        let height = 10 + (game.floor/2)
        let size = CGSizeMake(CGFloat(width), CGFloat(height))
        game.map = CAMap().createMap(size, floor: game.floor)
        
        while game.map == nil {
            game.map = CAMap().createMap(size, floor: game.floor)
        }
        
        displayMap()
    }
    
    //MARK: - IBActions
    
    @IBAction func backPressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func rebuildPressed(sender: UIButton) {
        createMap()
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