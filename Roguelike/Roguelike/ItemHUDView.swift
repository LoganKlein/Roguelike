//
//  ItemHUDView.swift
//  Roguelike
//
//  Created by Logan Klein on 11/17/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class ItemHUDView: UIView {
    @IBOutlet var weaponView: UIView!
    @IBOutlet var weaponIV: UIImageView!
    
    @IBOutlet var armorView: UIView!
    @IBOutlet var armorIV: UIImageView!
    
    @IBOutlet var buffView: UIView!
    @IBOutlet var buffIV: UIImageView!
    
    class func GenerateItemHUDView() -> ItemHUDView {
        let xib = Bundle.main.loadNibNamed("ItemHUDView", owner: self, options: nil)
        let hud = xib?[0] as! ItemHUDView
        let radius:CGFloat = 10.0
        hud.weaponView.layer.cornerRadius = radius
        hud.armorView.layer.cornerRadius = radius
        hud.buffView.layer.cornerRadius = radius
        hud.weaponView.layer.borderColor = UIColor.white.cgColor
        hud.armorView.layer.borderColor = UIColor.white.cgColor
        hud.buffView.layer.borderColor = UIColor.white.cgColor
        hud.weaponView.layer.borderWidth = 1
        hud.armorView.layer.borderWidth = 1
        hud.buffView.layer.borderWidth = 1
        return hud
    }
    
    func updateHUD(_ player: PlayerObject) {
        if player.weapon != nil { weaponIV.image = UIImage(named: (player.weapon?.imageName)!) }
        else { weaponIV.image = nil }
        
        if player.armor != nil { armorIV.image = UIImage(named: (player.armor?.imageName)!) }
        else { armorIV.image = nil }
        
        if player.buff != nil { buffIV.image = UIImage(named: (player.buff?.imageName)!) }
        else { buffIV.image = nil }
    }
}
