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
        resilientBtn.layer.borderColor = UIColor.clearColor().CGColor
        
        deadlyBtn.layer.cornerRadius = radius
        deadlyBtn.layer.borderWidth = width
        deadlyBtn.layer.borderColor = UIColor.clearColor().CGColor
        
        persistentBtn.layer.cornerRadius = radius
        persistentBtn.layer.borderWidth = width
        persistentBtn.layer.borderColor = UIColor.clearColor().CGColor
        
        madBtn.layer.cornerRadius = radius
        madBtn.layer.borderWidth = width
        madBtn.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "pushPortal") {
            (segue.destinationViewController as! PortalViewController).characterType = CharacterClass(rawValue: selectedType)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func classPressed(sender: UIButton) {
        resilientBtn.layer.borderColor = UIColor.clearColor().CGColor
        deadlyBtn.layer.borderColor = UIColor.clearColor().CGColor
        persistentBtn.layer.borderColor = UIColor.clearColor().CGColor
        madBtn.layer.borderColor = UIColor.clearColor().CGColor
        
        sender.layer.borderColor = UIColor.whiteColor().CGColor
        selectedType = sender.tag
        goBtn.alpha = 1
        goBtn.enabled = true
    }
    
    @IBAction func goPressed(sender: UIButton) {
        fadeToBlack()
    }
    
    //MARK: - Animation Methods
    
    func fadeToBlack() {
        UIView.animateWithDuration(3.0, animations: {
            self.maskView.alpha = 1
            }) { (Bool) in
                self.performSegueWithIdentifier("pushPortal", sender: nil)
        }
    }
}
