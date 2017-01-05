//
//  CharacterSelectViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class CharacterSelectViewController: UIViewController {
    @IBOutlet var maskView: UIView!
    @IBOutlet var resilientBtn: UIButton!
    @IBOutlet var deadlyBtn: UIButton!
    @IBOutlet var persistentBtn: UIButton!
    @IBOutlet var madBtn: UIButton!
    @IBOutlet var goBtn: UIButton!
    var selectedType = 0
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let radius:CGFloat = 10.0
        let width: CGFloat = 3.0
        resilientBtn.layer.cornerRadius = radius
        resilientBtn.layer.borderWidth = width
        resilientBtn.layer.borderColor = UIColor.clear.cgColor
        
        deadlyBtn.layer.cornerRadius = radius
        deadlyBtn.layer.borderWidth = width
        deadlyBtn.layer.borderColor = UIColor.clear.cgColor
        
        persistentBtn.layer.cornerRadius = radius
        persistentBtn.layer.borderWidth = width
        persistentBtn.layer.borderColor = UIColor.clear.cgColor
        
        madBtn.layer.cornerRadius = radius
        madBtn.layer.borderWidth = width
        madBtn.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "pushPortal") {
            (segue.destination as! PortalViewController).characterType = CharacterClass(rawValue: selectedType)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func classPressed(_ sender: UIButton) {
        resilientBtn.layer.borderColor = UIColor.clear.cgColor
        deadlyBtn.layer.borderColor = UIColor.clear.cgColor
        persistentBtn.layer.borderColor = UIColor.clear.cgColor
        madBtn.layer.borderColor = UIColor.clear.cgColor
        
        sender.layer.borderColor = UIColor.white.cgColor
        selectedType = sender.tag
        goBtn.alpha = 1
        goBtn.isEnabled = true
    }
    
    @IBAction func goPressed(_ sender: UIButton) {
        fadeToBlack()
    }
    
    //MARK: - Animation Methods
    
    func fadeToBlack() {
        UIView.animate(withDuration: 3.0, animations: {
            self.maskView.alpha = 1
            }, completion: { (Bool) in
                self.performSegue(withIdentifier: "pushPortal", sender: nil)
        }) 
    }
}
