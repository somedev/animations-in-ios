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
        self.deceleration.text = NSString(format: "%.2f", self.decelerationSlider.value)

    }
    
    //MARK: - UIViewController stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        self.valueChanged(self)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.presentationnView.addGestureRecognizer(pan)
    }
    
    //MARK: - Gesture recognizer
    func handlePan(recognizer: UIPanGestureRecognizer){
        
        let location = recognizer.locationInView(self.presentationnView)
        let velocity = recognizer.velocityInView(self.presentationnView)
        struct StaticContainer {
            static var movingEnabled:Bool = false
        }

        switch(recognizer.state)
        {
        case .Began:
            
            let pillPressed = (self.circle == self.presentationnView.hitTest(location, withEvent: nil))
            StaticContainer.movingEnabled = pillPressed
            break
            
        case .Changed:
            if(StaticContainer.movingEnabled){
                
                if let animation = (self.pop_animationForKey(self.kAnimationName) as? POPDecayAnimation){
                    animation.velocity = NSValue(CGPoint: velocity)
                }
                else{
                    self.horisontalConstraint.constant = self.presentationnView.frame.width/2 - location.x
                    self.verticalConstraint.constant = self.presentationnView.frame.height/2 - location.y
                    self.view.layoutIfNeeded()
                }
            }
            break
            
        case .Ended:
            //update velocity if animation is running
            if let animation = (self.pop_animationForKey(self.kAnimationName) as? POPDecayAnimation){
                animation.velocity = NSValue(CGPoint: velocity)
            }
            else{
                self.moveCircle(velocity)
            }
            break
            
            
        default:
            break
        }
    }

    
    //MARK: - utils
    func moveCircle(velocity:CGPoint) {
        var animation = POPDecayAnimation()
        
        let customProperty: POPAnimatableProperty = POPAnimatableProperty.propertyWithName(
            "com.property.circlr.center",
            initializer: { property in
                property.readBlock = {
                    object, values in
                    values[0] = -(object as DecayViewController).horisontalConstraint.constant
                    values[1] = -(object as DecayViewController).verticalConstraint.constant
                }
                property.writeBlock = {
                    object, values in
                    (object as DecayViewController).horisontalConstraint.constant = -values[0]
                    (object as DecayViewController).verticalConstraint.constant = -values[1]
                }
                property.threshold = 0.01
        }) as POPAnimatableProperty
        animation.property = customProperty
        animation.velocity = NSValue(CGPoint: velocity)
        animation.deceleration = CGFloat(self.decelerationSlider.value)
        animation.removedOnCompletion = true
        self.pop_addAnimation(animation, forKey: self.kAnimationName)
    }
    
}
