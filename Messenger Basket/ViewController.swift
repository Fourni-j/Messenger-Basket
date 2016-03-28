//
//  ViewController.swift
//  Messenger Basket
//
//  Created by Charles-Adrien Fournier on 28/03/16.
//  Copyright © 2016 Charles-Adrien Fournier. All rights reserved.
//

import UIKit

class Ball : UIImageView {
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var basketball: Ball!
    @IBOutlet weak var panierLine: UIImageView!
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    var elasticity: UIDynamicItemBehavior!
    
    var lastBasketballY: CGFloat!
    var isCollide = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastBasketballY = 0
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [basketball])
        elasticity = UIDynamicItemBehavior(items: [basketball])
        
        elasticity.elasticity = 0.7
        
        collision = UICollisionBehavior(items: [basketball])
        collision.translatesReferenceBoundsIntoBoundary = true
        
        collision.addBoundaryWithIdentifier("leftPanier", fromPoint: CGPointMake(135, 268), toPoint: CGPointMake(140, 268))
        collision.addBoundaryWithIdentifier("rightPanier", fromPoint: CGPointMake(231, 268), toPoint: CGPointMake(237, 268))
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        shoot()
        animator.addBehavior(elasticity)
        animator.addBehavior(gravity)
    }
    
    func endGame() {
        UIView.animateWithDuration(1, animations: {
            self.basketball.alpha = 0
            }, completion: {
                (value: Bool) in
//                self.animator.removeAllBehaviors()
//                self.basketball.hidden = false
//                let newFrame = CGRectMake(113, 500, 80, 80)
//                self.basketball.frame = newFrame
                print("tatito")
        })

//        UIView.animateWithDuration(0.5, animations: {
//            self.basketball.alpha = 0
//        })
        
    }
    
    func shoot() {
        animator?.addBehavior(pushForPosition(CGPointZero))
    }
    
    func pushForPosition(position: CGPoint) -> UIPushBehavior {
        let push = UIPushBehavior(items: [basketball], mode: .Instantaneous)
        
        push.action = {
            
            if self.lastBasketballY == 0 {
                self.lastBasketballY = self.basketball.frame.origin.y + 1
            }
            
            if self.lastBasketballY == self.basketball.frame.origin.y {
                if !self.isCollide {
                    self.animator.addBehavior(self.collision)
                    self.panierLine.hidden = false;
                    self.isCollide = true
                }
            }
            
            if self.basketball.frame.origin.y > 250 {
                if self.isCollide {
                    self.endGame()
                }
            }
            
            self.lastBasketballY = self.basketball.frame.origin.y
        }
        
        push.angle = -1.42
        push.magnitude = 5
        return push
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

