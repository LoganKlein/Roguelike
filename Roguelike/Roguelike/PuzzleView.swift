//
//  PuzzleView.swift
//  Roguelike
//
//  Created by Logan Klein on 11/29/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class PuzzleView: UIView {
    
    var gameVC: GameViewController!
    
    class func generateInView(gameView: GameViewController) {
        let xib = NSBundle.mainBundle().loadNibNamed("PuzzleView", owner: self, options: nil)
        let puzzleView = xib[0] as! PuzzleView
        puzzleView.gameVC = gameView
        puzzleView.frame = gameView.view.frame
        
        let rings = 4.0
        let width = 300.0/rings
        
        for i in 0...Int(rings - 1) {
            let size: CGFloat = 300 - (CGFloat(i) * CGFloat(width))
            let iv = UIImageView(frame: CGRectMake(0, 0, size, size))
            iv.image = UIImage(named: "dragon_token")
            iv.contentMode = .Center
            iv.center = puzzleView.center
            iv.clipsToBounds = true
            iv.layer.cornerRadius = iv.frame.size.width/2
            iv.layer.borderColor = UIColor.greenColor().CGColor
            iv.layer.borderWidth = 2.0
            
            //Don't rotate the center image
            if Double(i) <= rings - 2 {
                let x = Double(arc4random_uniform(360))
                iv.transform = CGAffineTransformMakeRotation(CGFloat((M_PI * (x) / 180.0)))
                iv.addGestureRecognizer(puzzleView.getPanGR())
                iv.userInteractionEnabled = true
            }
            
            puzzleView.addSubview(iv)
        }
        
        gameView.view.addSubview(puzzleView)
        gameView.changeSwipeEnabled(false)
    }
    
    func getPanGR() -> UIPanGestureRecognizer {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(PuzzleView.rotate(_:)))
        return panGR
    }
    
    func rotate(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.locationInView(self)
        let angle = angleBetweenPoints((recognizer.view?.center)!, b: touchPoint)
        
        UIView.animateWithDuration(0.2) { 
            recognizer.view!.transform = CGAffineTransformMakeRotation(CGFloat((M_PI * Double(angle) / 180.0)))
        }
    }
    
    func angleBetweenPoints(a: CGPoint, b: CGPoint) -> CGFloat {
        let originPoint = CGPointMake(b.x - a.x, b.y - a.y) // get origin point to origin by subtracting end from start
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.x)) // get bearing in radians
        var bearingDegrees = Double(bearingRadians) * (180.0 / M_PI) // convert to degrees
        bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)) // correct discontinuity
        return CGFloat(bearingDegrees)
    }
}
