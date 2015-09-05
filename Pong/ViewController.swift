//
//  ViewController.swift
//  Pong
//
//  Created by Nick Chen on 8/19/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    let DIAMETER = CGFloat(50.0)
    let PADDLE_WIDTH = CGFloat(100.0)
    let PADDLE_HEIGHT = CGFloat(25.0)
    let NUM_BRICKS = 20
    var BRICK_SIZE: CGSize {
        let size = UIScreen.mainScreen().bounds.size.width / CGFloat(NUM_BRICKS)
        return CGSize(width: size, height: size)
    }
    
    var orangeBall: UIView!
    var paddle: UIView!
    var animator: UIDynamicAnimator!
    var bricks = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        orangeBall = UIView(frame: CGRectMake(0.0, 0.0, DIAMETER, DIAMETER))
        orangeBall.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, 300)
        orangeBall.backgroundColor = UIColor.orangeColor()
        orangeBall.layer.cornerRadius = 25.0;
        view.addSubview(orangeBall)
        
        paddle = UIView(frame:CGRectMake(0.0, 0.0, PADDLE_WIDTH, PADDLE_HEIGHT))
        paddle.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height - PADDLE_HEIGHT / 2)
        paddle.backgroundColor = UIColor.grayColor()
        view.addSubview(paddle)
        
        for var i = 0; i < NUM_BRICKS; i++ {
            var frame = CGRect(origin: CGPointZero, size: BRICK_SIZE)
            frame.origin.y = 200
            frame.origin.x = CGFloat(i) * BRICK_SIZE.width
            let dropView = UIView(frame: frame)
            dropView.backgroundColor = UIColor.random
            bricks.append(dropView)
            view.addSubview(dropView)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initBehaviors()
    }
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.locationInView(self.view)
        
        paddle.center = CGPointMake(translationPoint.x, paddle.center.y)
        
        animator.updateItemUsingCurrentState(paddle)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        
        // Collision between ball and paddle
        if(item1 === orangeBall && item2 === paddle) {
            let pushBehavior = UIPushBehavior(items: [orangeBall], mode: .Instantaneous)
            pushBehavior.pushDirection = CGVectorMake(0.0, -1.0)
            pushBehavior.magnitude = 0.75
            
            // Need to remove the behavior without causing circular reference
            pushBehavior.action = { [unowned pushBehavior] in
                if(!pushBehavior.active) {
                    pushBehavior.dynamicAnimator?.removeBehavior(pushBehavior)
                }
            }
            animator.addBehavior(pushBehavior)
        }
    }
    
    func initBehaviors() {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Add gravity for ball
        let gravityBehavior = UIGravityBehavior(items: [orangeBall])
        animator.addBehavior(gravityBehavior)
        
        // Add collision
        let collisionBoundsBehavior = UICollisionBehavior(items: [orangeBall, paddle])
        collisionBoundsBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBoundsBehavior)
        
        // Add physical properties for ball
        let elasticityBehavior = UIDynamicItemBehavior(items: [orangeBall])
        elasticityBehavior.elasticity = 1.0
        animator.addBehavior(elasticityBehavior)
        
        // Add physical properties for bricks
        let brickBehavior = UIDynamicItemBehavior(items: bricks)
        brickBehavior.allowsRotation = false
        animator.addBehavior(brickBehavior)
        
        // Add physical properties for paddle
        let paddleBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleBehavior.density = 100.0
        paddleBehavior.allowsRotation = false
        animator.addBehavior(paddleBehavior)

        // Add collision between ball and bricks (individually so there is no avalanche effect)
        for brick in bricks {
            let ballAndBrick: [UIDynamicItem] = [brick, orangeBall]
            let collisionBallAndBricksBehavior = UICollisionBehavior(items: ballAndBrick)
            animator.addBehavior(collisionBallAndBricksBehavior)
        }
        
        // Add collision between ball and paddle
        let collisionBallAndPaddleBehavior = UICollisionBehavior(items: [orangeBall, paddle])
        collisionBallAndPaddleBehavior.collisionDelegate = self
        animator.addBehavior(collisionBallAndPaddleBehavior)
    }
    
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random() % 5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}

