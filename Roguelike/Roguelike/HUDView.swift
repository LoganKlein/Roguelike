//
//  HUDView.swift
//  Roguelike
//
//  Created by Logan Klein on 11/14/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class HUDView: UIView {
    @IBOutlet var healthView: UIView!
    @IBOutlet var healthIV: UIImageView!
    @IBOutlet var healthLbl: UILabel!
    @IBOutlet var healthWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var sanityView: UIView!
    @IBOutlet var sanityIV: UIImageView!
    @IBOutlet var sanityLbl: UILabel!
    @IBOutlet var sanityWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var expView: UIView!
    @IBOutlet var expIV: UIImageView!
    @IBOutlet var expLbl: UILabel!
    @IBOutlet var expWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var floorLbl: UILabel!
    @IBOutlet var levelLbl: UILabel!
    
    class func GenerateHUDView() -> HUDView {
        let xib = Bundle.main.loadNibNamed("HUDView", owner: self, options: nil)
        let hud = xib?[0] as! HUDView
        hud.healthView.layer.cornerRadius = hud.healthView.frame.size.height/2
        hud.sanityView.layer.cornerRadius = hud.sanityView.frame.size.height/2
        hud.expView.layer.cornerRadius = hud.expView.frame.size.height/2
        return hud
    }
    
    func updateHUD(_ game: GameObject, speed: Double) {
        UIView.animate(withDuration: speed, animations: {
            self.levelLbl.text = "Level\n\(game.player.lvl)"
            self.floorLbl.text = "Floor\n\(game.floor)"
            self.healthLbl.text = "[\(Int(game.player.curHP))/\(Int(game.player.maxHP))]"
            self.sanityLbl.text = "[\(Int(game.player.sty))/100]"
            self.expLbl.text = "[\(Int(game.player.exp))/\(Int(game.player.expNeeded))]"
            
            let healthPercent = game.player.curHP / game.player.maxHP
            let sanityPercent = game.player.sty / 100.0
            let expPercent = game.player.exp / game.player.expNeeded
            
            let healthWidth = self.healthView.frame.size.width * CGFloat(healthPercent)
            let sanityWidth = self.sanityView.frame.size.width * CGFloat(sanityPercent)
            let expWidth = self.expView.frame.size.width * CGFloat(expPercent)
            
            self.healthWidthConstraint.constant = healthWidth
            self.sanityWidthConstraint.constant = sanityWidth
            self.expWidthConstraint.constant = expWidth
            
            self.layoutIfNeeded()
        }) 
    }
}
