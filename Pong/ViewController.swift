//
//  ViewController.swift
//  Pong
//
//  Created by Nick Chen on 8/19/15.
//  Copyright © 2015 TalentSpark. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let DIAMETER = CGFloat(50.0)
    let PADDLE_WIDTH = CGFloat(100.0)
    let PADDLE_HEIGHT = CGFloat(25.0)
    
    var orangeBall: UIView!
    var paddle: UIView!
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        orangeBall = UIView(frame: CGRectMake(0.0, 0.0, DIAMETER, DIAMETER))
        orangeBall.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, 100)
        orangeBall.backgroundColor = UIColor.orangeColor()
        orangeBall.layer.cornerRadius = 25.0;
        view.addSubview(orangeBall)
        
        paddle = UIView(frame:CGRectMake(0.0, 0.0, PADDLE_WIDTH, PADDLE_HEIGHT))
        paddle.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height - PADDLE_HEIGHT / 2)
        paddle.backgroundColor = UIColor.grayColor()
        view.addSubview(paddle)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initBehaviors()
    }
    
    func initBehaviors() {
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // Add gravity
        let gravityBehavior = UIGravityBehavior(items: [orangeBall])
        animator.addBehavior(gravityBehavior)
        
        // Add collision
        let collisionBoundsBehavior = UICollisionBehavior(items: [orangeBall])
        collisionBoundsBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBoundsBehavior)
        
        // Add elasticity
        let elasticityBehavior = UIDynamicItemBehavior(items: [orangeBall])
        elasticityBehavior.elasticity = 1.0
//        animator.addBehavior(elasticityBehavior)
    }
    
}

