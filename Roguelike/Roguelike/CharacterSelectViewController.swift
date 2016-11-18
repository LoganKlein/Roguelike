//
//  CharacterSelectViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/11/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit
import iCarousel

class CharacterSelectViewController: UIViewController {
    @IBOutlet var carousel: iCarousel!
    @IBOutlet var maskView: UIView!
    let classes: [String] = ["Hunter", "Knight", "Cleric"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carousel.type = .Linear
        carousel.delegate = self
    }
    
    // MARK: - IBActions
    
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

extension CharacterSelectViewController: iCarouselDataSource {
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return classes.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let csView: CharacterSelectView
        let aClass = classes[index]
        
        if view != nil {
            csView = view as! CharacterSelectView
        }
        
        else {
            let xib = NSBundle.mainBundle().loadNibNamed("CharacterSelectView", owner: self, options: nil)
            csView = xib[0] as! CharacterSelectView
        }
        
        csView.populateWithClass(aClass)
        return csView
    }
}

extension CharacterSelectViewController: iCarouselDelegate {
    
}
