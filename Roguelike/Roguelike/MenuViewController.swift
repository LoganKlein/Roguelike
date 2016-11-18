//
//  MenuViewController.swift
//  Roguelike
//
//  Created by Logan Klein on 11/7/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var newGameBtn: UIButton!
    @IBOutlet var continueBtn: UIButton!
    @IBOutlet var optionsBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    
    @IBAction func newGamePressed(sender: UIButton) {
        self.performSegueWithIdentifier("pushCharacterSelect", sender: nil)
    }
    
    @IBAction func continuePressed(sender: UIButton) {
        print("continue pressed")
    }
    
    @IBAction func optionsPressed(sender: UIButton) {
        print("options pressed")
    }
}
