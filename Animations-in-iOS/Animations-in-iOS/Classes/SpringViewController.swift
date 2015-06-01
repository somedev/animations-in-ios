//
//  SpringViewController.swift
//  Animations-in-iOS
//
//  Created by Eduard Panasiuk on 1/13/15.
//  Copyright (c) 2015 Eduard Panasiuk. All rights reserved.
//

import UIKit

class SpringViewController: UIViewController {
    
    //MARK: - constants
    let kAnimationName = "spring animation"
    
    //MARK: - outlets
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var bouncinessSlider: UISlider!
    @IBOutlet weak var bouncinessLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var horisontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var presentationView: UIView!
    //MARK: - actions
    @IBAction func valueChanged(sender: AnyObject) {
        bouncinessLabel.text = "\(Int(bouncinessSlider.value))"
        speedLabel.text = "\(Int(speedSlider.value))"
    }
    
    //MARK: - UIViewController stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        valueChanged(self)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        presentationView.addGestureRecognizer(pan)
    }
    
    //MARK: - Gesture recognizer
    func handlePan(recognizer: UIPanGestureRecognizer){
        
        if let animation = (pop_animationForKey(kAnimationName) as? POPDecayAnimation){
            return
        }
        
        let location = recognizer.locationInView(presentationView)
        let velocity = recognizer.velocityInView(presentationView)
        struct StaticContainer {
            static var movingEnabled:Bool = false
        }
        
        switch(recognizer.state)
        {
        case .Began:
            
            let pillPressed = (circle == presentationView.hitTest(location, withEvent: nil))
            StaticContainer.movingEnabled = pillPressed
            break
            
        case .Changed:
            if(StaticContainer.movingEnabled){
                horisontalConstraint.constant = presentationView.frame.width/2 - location.x
                verticalConstraint.constant = presentationView.frame.height/2 - location.y
                view.layoutIfNeeded()
            }
            break
            
        case .Ended:
            moveCircleToCenterAnimated()
            
            break
            
        default:
            break
        }
    }
    
    
    //MARK: - utils
    func moveCircleToCenterAnimated() {
        var animation = POPSpringAnimation()
        
        let customProperty: POPAnimatableProperty = POPAnimatableProperty.propertyWithName(
            "com.property.circle.center",
            initializer: { property in
                property.readBlock = {
                    object, values in
                    if let controller = object as? SpringViewController {
                        values[0] = -(controller).horisontalConstraint.constant
                        values[1] = -(controller).verticalConstraint.constant
                        
                    }
                }
                property.writeBlock = {
                    object, values in
                    if let controller = object as? SpringViewController {

                    (controller).horisontalConstraint.constant = -values[0]
                    (controller).verticalConstraint.constant = -values[1]
                    }
                }
                property.threshold = 0.01
        }) as! POPAnimatableProperty
        
        animation.property = customProperty
        animation.springSpeed = CGFloat(speedSlider.value)
        animation.springBounciness = CGFloat(bouncinessSlider.value)
        animation.toValue = NSValue(CGPoint:CGPointZero)
        animation.removedOnCompletion = true
        pop_addAnimation(animation, forKey: kAnimationName)
    }
}
