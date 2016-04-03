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
    
    @IBOutlet weak var basket: UIImageView!
    
    var progBasketball: Ball!
    var progBasketLine: UIImageView!
    
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    var basketCollision: UICollisionBehavior!
    var elasticity: UIDynamicItemBehavior!
    var push: UIPushBehavior!
    
    var lastBasketballY: CGFloat!
    var isCollide = false
    var gameEnded = false
    var isShoot = false
    
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
        
        basketCollision = UICollisionBehavior(items: [progBasketball])
        basketCollision.translatesReferenceBoundsIntoBoundary = true
        basketCollision.addBoundaryWithIdentifier("leftPanier", fromPoint: CGPointMake(135, 268), toPoint: CGPointMake(140, 268))
        basketCollision.addBoundaryWithIdentifier("rightPanier", fromPoint: CGPointMake(231, 268), toPoint: CGPointMake(237, 268))
    }
    
    func spawnPanierLine() {
        if progBasketLine != nil {
            progBasketLine.removeFromSuperview()
            progBasketLine = nil
        }
        
        progBasketLine = UIImageView(image: UIImage(named: "line"))
        
        let xPosition = basket.frame.origin.x + basket.frame.width - 154
        let yPosition = basket.frame.origin.y + basket.frame.height - 26.5
        
        let newFrame = CGRectMake(xPosition, yPosition, 97.5, 6)
        
        progBasketLine.frame = newFrame
        view.addSubview(progBasketLine)
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
        isShoot = false
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
        if !isShoot {
            animator.addBehavior(collision)
            animator.addBehavior(pushForPosition(CGPointZero))
            animator.addBehavior(elasticity)
            animator.addBehavior(gravity)
            isShoot = true
        }
    }
    
    func pushForPosition(position: CGPoint) -> UIPushBehavior {
        push = UIPushBehavior(items: [progBasketball], mode: .Instantaneous)
        push.action = {
            
            if self.lastBasketballY == 0 {
                self.lastBasketballY = self.progBasketball.frame.origin.y + 1
            }
            if self.lastBasketballY <= self.progBasketball.frame.origin.y {
                if !self.isCollide {
                    self.animator.addBehavior(self.basketCollision)
                    self.spawnPanierLine()
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
        
        var f = atan2(self.touchPointEnd.y - self.touchPointBegin.y, self.touchPointEnd.x - self.touchPointBegin.x)
        
        if f > -1.40 {
            f = -1.40
        } else if f < -1.70 {
            f = -1.75
        }
        
        push.angle = f
        push.magnitude = 5.25
        return push
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

