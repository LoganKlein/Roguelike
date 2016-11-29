//
//  DialogueView.swift
//  Roguelike
//
//  Created by Logan Klein on 11/29/16.
//  Copyright © 2016 Soular. All rights reserved.
//

import UIKit

class DialogueView: UIView {

    @IBOutlet var leftIV: UIImageView!
    @IBOutlet var rightIV: UIImageView!
    @IBOutlet var holderView: UIView!
    @IBOutlet var textBackerIV: UIImageView!
    @IBOutlet var mainTextView: UITextView!
    
    var gameVC: GameViewController!
    
    var dialogueChain: [DialogueInfo] = []
    var currentDialogue = 0
    
    //MARK: - Display Methods
    
    class func generateInView(gameView: GameViewController, dialogue: [DialogueInfo]) {
        let xib = NSBundle.mainBundle().loadNibNamed("DialogueView", owner: self, options: nil)
        let dialogueView = xib[0] as! DialogueView
        dialogueView.gameVC = gameView
        dialogueView.dialogueChain = dialogue
        dialogueView.setupGestureRecognizers()
        dialogueView.alpha = 0
        gameView.view.addSubview(dialogueView)
        dialogueView.frame = gameView.view.frame
        dialogueView.showDialogueView()
        gameView.changeSwipeEnabled(false)
    }
    
    func showDialogueInfo(info: DialogueInfo) {
        let animation: CATransition = CATransition()
        animation.duration = 0.35
        animation.type = kCATransitionMoveIn
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        if info.leftIVName != nil {
            animation.subtype = kCATransitionFromLeft
            leftIV.image = UIImage(named: info.leftIVName!)
            leftIV.sizeToFit()
            
            UIView.animateWithDuration(0.35, animations: {
                self.leftIV.alpha = 1
            })
        }
            
        else {
            UIView.animateWithDuration(0.35, animations: {
                self.leftIV.alpha = 0
            })
        }
        
        if info.rightIVName != nil {
            animation.subtype = kCATransitionFromRight
            rightIV.image = UIImage(named: info.rightIVName!)
            rightIV.sizeToFit()
            
            UIView.animateWithDuration(0.35, animations: { 
                self.rightIV.alpha = 1
            })
        }
        
        else {
            UIView.animateWithDuration(0.35, animations: {
                self.rightIV.alpha = 0
            })
        }
        
        let font = UIFont(name: "Futura", size: 21.0)
        let attributes: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font!]
        mainTextView.layer.addAnimation(animation, forKey: "changeTextTransition")
        let attText = NSAttributedString(string: info.displayText!, attributes: attributes)
        mainTextView.attributedText = attText
    }
    
    func showDialogueView() {
        showDialogueInfo(dialogueChain[0])
        UIView.animateWithDuration(0.35) { 
            self.alpha = 1
        }
    }
    
    func dismissDialogueView() {
        gameVC.changeSwipeEnabled(true)
        UIView.animateWithDuration(0.35) {
            self.alpha = 0
        }
    }
    
    func advanceDialogue() {
        currentDialogue += 1
        
        if currentDialogue >= dialogueChain.count {
            dismissDialogueView()
        }
        
        else {
            showDialogueInfo(dialogueChain[currentDialogue])
        }
    }

    //MARK: - Gesture Recognition Methods
    
    func leftSwipe(recognizer: UISwipeGestureRecognizer) {
        advanceDialogue()
    }
    
    func rightSwipe(recognizer: UISwipeGestureRecognizer) {
        currentDialogue -= 1
        
        if currentDialogue >= 0 {
            showDialogueInfo(dialogueChain[currentDialogue])
        }
        
        else {
            currentDialogue = 0
        }
    }
    
    func tap(recognizer: UITapGestureRecognizer) {
        advanceDialogue()
    }
    
    func longPress(recognizer: UITapGestureRecognizer) {
        dismissDialogueView()
    }
    
    func setupGestureRecognizers() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DialogueView.leftSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DialogueView.rightSwipe(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(DialogueView.tap(_:)))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DialogueView.longPress(_:)))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        longPress.minimumPressDuration = 0.5
        
        self.addGestureRecognizer(leftSwipe)
        self.addGestureRecognizer(rightSwipe)
        self.addGestureRecognizer(tap)
        self.addGestureRecognizer(longPress)
    }
}
