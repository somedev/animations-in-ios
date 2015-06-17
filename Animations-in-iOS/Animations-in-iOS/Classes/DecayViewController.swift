//
//  DecayViewController.swift
//  Animations-in-iOS
//
//  Created by Eduard Panasiuk on 1/13/15.
//  Copyright (c) 2015 Eduard Panasiuk. All rights reserved.
//

import UIKit

class DecayViewController: UIViewController {

    //MARK: - constants
    let kAnimationName = "decay animation"
    
    //MARK: - outlets
    @IBOutlet weak var deceleration: UILabel!
    @IBOutlet weak var decelerationSlider: UISlider!
    @IBOutlet weak var horisontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var presentationnView: UIView!
    
    //MARK: - actions
    @IBAction func valueChanged(sender: AnyObject) {
        deceleration.text = String(format: "%.2f", decelerationSlider.value)

    }
    
    //MARK: - UIViewController stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        valueChanged(self)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        presentationnView.addGestureRecognizer(pan)
    }
    
    //MARK: - Gesture recognizer
    func handlePan(recognizer: UIPanGestureRecognizer){
        
        let location = recognizer.locationInView(presentationnView)
        let velocity = recognizer.velocityInView(presentationnView)
        struct StaticContainer {
            static var movingEnabled:Bool = false
        }

        switch(recognizer.state)
        {
        case .Began:
            
            let pillPressed = (circle == presentationnView.hitTest(location, withEvent: nil))
            StaticContainer.movingEnabled = pillPressed
            break
            
        case .Changed:
            if(StaticContainer.movingEnabled){
                
                if let animation = (pop_animationForKey(kAnimationName) as? POPDecayAnimation){
                    animation.velocity = NSValue(CGPoint: velocity)
                }
                else{
                    horisontalConstraint.constant = presentationnView.frame.width/2 - location.x
                    verticalConstraint.constant = presentationnView.frame.height/2 - location.y
                    view.layoutIfNeeded()
                }
            }
            break
            
        case .Ended:
            //update velocity if animation is running
            if let animation = (pop_animationForKey(kAnimationName) as? POPDecayAnimation){
                animation.velocity = NSValue(CGPoint: velocity)
            }
            else{
                moveCircle(velocity)
            }
            break
            
            
        default:
            break
        }
    }

    
    //MARK: - utils
    func moveCircle(velocity:CGPoint) {
        let animation = POPDecayAnimation()
        
        let customProperty: POPAnimatableProperty = POPAnimatableProperty.propertyWithName(
            "com.property.circlr.center",
            initializer: { property in
                property.readBlock = {
                    object, values in
                    if let viewController = object as? DecayViewController {
                        values[0] = -(viewController).horisontalConstraint.constant
                        values[1] = -(viewController).verticalConstraint.constant
                    }
                }
                property.writeBlock = {
                    object, values in
                    if let viewController = object as? DecayViewController {
                        (viewController).horisontalConstraint.constant = -values[0]
                        (viewController).verticalConstraint.constant = -values[1]
                    }
                }
                property.threshold = 0.01
        }) as! POPAnimatableProperty
        
        animation.property = customProperty
        animation.velocity = NSValue(CGPoint: velocity)
        animation.deceleration = CGFloat(decelerationSlider.value)
        animation.removedOnCompletion = true
        pop_addAnimation(animation, forKey: kAnimationName)
    }
    
}
