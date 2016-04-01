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
    
    @IBOutlet weak var panierLine: UIImageView!
    
    var progBasketball: Ball!
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    var elasticity: UIDynamicItemBehavior!
    var push: UIPushBehavior!
    
    var lastBasketballY: CGFloat!
    var isCollide = false
    var gameEnded = false
    
    var touchPointEnd: CGPoint!
    var touchPointBegin: CGPoint!
    
    var bestScore: Int!
    var actualScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        spawnBall()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.locationInView(view)
            touchPointBegin = location
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInView(view)
            touchPointEnd = location
        }
        super.touchesEnded(touches, withEvent: event)
        shoot()
    }
    
    func createDynamicProperties() {
        if animator != nil {
            animator.removeAllBehaviors()
            animator = nil
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior(items: [progBasketball])
        
        elasticity = UIDynamicItemBehavior(items: [progBasketball])
        elasticity.elasticity = 0.7
        
        collision = UICollisionBehavior(items: [progBasketball])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundaryWithIdentifier("leftPanier", fromPoint: CGPointMake(135, 268), toPoint: CGPointMake(140, 268))
        collision.addBoundaryWithIdentifier("rightPanier", fromPoint: CGPointMake(231, 268), toPoint: CGPointMake(237, 268))
    }
    
    func spawnBall() {
        if progBasketball != nil {
            progBasketball.removeFromSuperview()
            progBasketball = nil
        }
        
        progBasketball = Ball(image: UIImage(named: "basketball"))
        
        let randMax: Int = Int(self.view.frame.size.width - 80)
        
        let xPosition = random() % randMax
        
        let xPositionFloat : CGFloat = CGFloat(xPosition)
        
        print("Random position : \(xPosition)")
        
        let newFrame = CGRectMake(xPositionFloat, 567.0, 80.0, 80.0)
        progBasketball.frame = newFrame
        view.addSubview(progBasketball)
        
        createDynamicProperties()
        resetGameProperties()
    }
    
    func resetGameProperties() {
        bestScore = actualScore
        actualScore = 0
        isCollide = false
        gameEnded = false
        lastBasketballY = 0
    }
    
    func endGame() {
        UIView.animateWithDuration(0.3, animations: {
            self.progBasketball.alpha = 0
            }, completion: {
                (value: Bool) in
                self.spawnBall()
        })
    }
    
    func shoot() {
        animator.addBehavior(pushForPosition(CGPointZero))
        animator.addBehavior(elasticity)
        animator.addBehavior(gravity)
    }
    
    func pushForPosition(position: CGPoint) -> UIPushBehavior {
        push = UIPushBehavior(items: [progBasketball], mode: .Instantaneous)
        push.action = {
            
            if self.lastBasketballY == 0 {
                self.lastBasketballY = self.progBasketball.frame.origin.y + 1
            }
            if self.lastBasketballY == self.progBasketball.frame.origin.y {
                if !self.isCollide {
                    self.animator.addBehavior(self.collision)
                    self.panierLine.hidden = false;
                    self.isCollide = true
                }
            }
            if self.progBasketball.frame.origin.y > 250 {
                if self.isCollide {
                    if !self.gameEnded {
                        self.gameEnded = true
                        self.endGame()
                    }
                }
            }
            self.lastBasketballY = self.progBasketball.frame.origin.y
        }
        
        let f = atan2(self.touchPointEnd.y - self.touchPointBegin.y, self.touchPointEnd.x - self.touchPointBegin.x)
        
        push.angle = f
        push.magnitude = 5
        return push
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

