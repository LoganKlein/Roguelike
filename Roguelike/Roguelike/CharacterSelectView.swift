//
//  CharacterSelectView.swift
//  Roguelike
//
//  Created by Logan Klein on 11/12/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class CharacterSelectView: UIView {
    
    @IBOutlet var characterIV: UIImageView!
    @IBOutlet var classLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func populateWithClass(character: String) {
        let dict = [
            "Resilient": "A tenacious fighter who can\nweather any blow",
            "Deadly": "A fierce warrior who takes the\nfight to the enemy",
            "Persistent": "A steady combatant who chooses\ntheir battles wisely",
            "Mad": "A man some call mad, but\nwhat secrets has he seen?"
        ]
        
        characterIV.image = UIImage(named: character.lowercaseString)
        classLbl.text = character
        descriptionLbl.text = dict[character]!
        classLbl.sizeToFit()
        descriptionLbl.sizeToFit()
        self.sizeToFit()
    }
}
