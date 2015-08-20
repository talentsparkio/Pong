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
    var orangeBall: UIView!
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        orangeBall = UIView(frame: CGRectMake(0.0, 0.0, DIAMETER, DIAMETER))
        orangeBall.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, 100)
        orangeBall.backgroundColor = UIColor.orangeColor()
        orangeBall.layer.cornerRadius = 25.0;
        view.addSubview(orangeBall)
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
    }
    
}

