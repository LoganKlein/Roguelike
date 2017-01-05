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
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "pushCharacterSelect", sender: nil)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        print("continue pressed")
        let url = URL(string: "gtybible://bible/01004001")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func optionsPressed(_ sender: UIButton) {
        print("options pressed")
    }
}
