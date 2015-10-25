//
//  SpringAnimationViewController.swift
//  Animations-in-iOS
//
//  Created by Eduard Panasiuk on 10/25/15.
//  Copyright © 2015 Eduard Panasiuk. All rights reserved.
//

import UIKit

class SpringAnimationViewController: UIViewController {

    private let kAnimationKey = "kAnimationKey"
    
    @IBOutlet weak var redView: UIView!
    @IBAction func runAnimation(sender: AnyObject) {
        addAnimationToRedView()
    }
    
    //MARK: - Utils
    func addAnimationToRedView() {
        redView.layer.removeAllAnimations()
        
        let animation = CASpringAnimation()
        animation.damping = 5
        animation.keyPath = "transform.scale"
        animation.duration = animation.settlingDuration
        animation.fromValue = NSValue(CATransform3D:CATransform3DMakeScale(1.6, 1.6, 1.0))
        redView.layer.addAnimation(animation, forKey: kAnimationKey)
    }
}
