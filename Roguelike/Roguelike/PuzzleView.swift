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
    
    class func generateInView(_ gameView: GameViewController) {
        let xib = Bundle.main.loadNibNamed("PuzzleView", owner: self, options: nil)
        let puzzleView = xib?[0] as! PuzzleView
        puzzleView.gameVC = gameView
        puzzleView.frame = gameView.view.frame
        
        let rings = 4.0
        let width = 300.0/rings
        
        for i in 0...Int(rings - 1) {
            let size: CGFloat = 300 - (CGFloat(i) * CGFloat(width))
            let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            iv.image = UIImage(named: "dragon_token")
            iv.contentMode = .center
            iv.center = puzzleView.center
            iv.clipsToBounds = true
            iv.layer.cornerRadius = iv.frame.size.width/2
            
            //Don't rotate the center image
            if Double(i) <= rings - 2 {
                let x = Double(arc4random_uniform(360))
                let radians = puzzleView.radiansToDegrees(x)
                iv.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
                iv.addGestureRecognizer(puzzleView.getPanGR())
                iv.isUserInteractionEnabled = true
            }
            
            puzzleView.addSubview(iv)
        }
        
        gameView.view.addSubview(puzzleView)
        gameView.changeSwipeEnabled(false)
    }
    
    //MARK: - Gesture Recognition Methods
    
    func getPanGR() -> UIPanGestureRecognizer {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(PuzzleView.rotate(_:)))
        return panGR
    }
    
    func rotate(_ recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        var angle = angleBetweenPoints((recognizer.view?.center)!, b: touchPoint)
        
        if recognizer.state == .ended {
            angle = CGFloat(roundedTo(Double(angle), nearest: 10.0))
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            let rotation = self.degreesToRadians(Double(angle))
            recognizer.view!.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        }) 
        
        if recognizer.state == .ended {
            self.checkComplete()
        }
    }
    
    //MARK: - Completion Methods
    
    func checkComplete() {
        var success = true
        
        for iv in self.subviews {
            let radians = atan2f(Float(iv.transform.b), Float(iv.transform.a))
            let degrees = radiansToDegrees(Double(radians))
            
            if degrees > 1 || degrees < -1 {
                success = false
            }
        }
        
        if success {
            gameVC.changeSwipeEnabled(true)
            UIView.animate(withDuration: 0.35, animations: {
                self.alpha = 0
            }) 
        }
    }
    
    //MARK: - Math Methods
    
    func degreesToRadians(_ degrees: Double) -> Double {
        return M_PI * (degrees) / 180.0
    }
    
    func radiansToDegrees(_ radians: Double) -> Double {
        return 180.0 * (radians) / M_PI
    }
    
    func roundedTo(_ num: Double, nearest: Double) -> Double {
        return nearest * floor((num/nearest)+0.5)
    }
    
    func angleBetweenPoints(_ a: CGPoint, b: CGPoint) -> CGFloat {
        let originPoint = CGPoint(x: b.x - a.x, y: b.y - a.y) // get origin point to origin by subtracting end from start
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.x)) // get bearing in radians
        var bearingDegrees = radiansToDegrees(Double(bearingRadians))
        bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)) // correct discontinuity
        return CGFloat(bearingDegrees)
    }
}
