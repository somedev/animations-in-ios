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
        self.bouncinessLabel.text = "\(Int(self.bouncinessSlider.value))"
        self.speedLabel.text = "\(Int(self.speedSlider.value))"
    }
    
    //MARK: - UIViewController stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        self.valueChanged(self)
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.presentationView.addGestureRecognizer(pan)
    }
    
    //MARK: - Gesture recognizer
    func handlePan(recognizer: UIPanGestureRecognizer){
        
        if let animation = (self.pop_animationForKey(self.kAnimationName) as? POPDecayAnimation){
            return
        }
        
        let location = recognizer.locationInView(self.presentationView)
        let velocity = recognizer.velocityInView(self.presentationView)
        struct StaticContainer {
            static var movingEnabled:Bool = false
        }
        
        switch(recognizer.state)
        {
        case .Began:
            
            let pillPressed = (self.circle == self.presentationView.hitTest(location, withEvent: nil))
            StaticContainer.movingEnabled = pillPressed
            break
            
        case .Changed:
            if(StaticContainer.movingEnabled){
                self.horisontalConstraint.constant = self.presentationView.frame.width/2 - location.x
                self.verticalConstraint.constant = self.presentationView.frame.height/2 - location.y
                self.view.layoutIfNeeded()
            }
            break
            
        case .Ended:
            self.moveCircleToCenterAnimated()
            
            break
            
        default:
            break
        }
    }
    
    
    //MARK: - utils
    func moveCircleToCenterAnimated() {
        var animation = POPSpringAnimation()
        
        let customProperty: POPAnimatableProperty = POPAnimatableProperty.propertyWithName(
            "com.property.circlr.center",
            initializer: { property in
                property.readBlock = {
                    object, values in
                    values[0] = -(object as SpringViewController).horisontalConstraint.constant
                    values[1] = -(object as SpringViewController).verticalConstraint.constant
                }
                property.writeBlock = {
                    object, values in
                    (object as SpringViewController).horisontalConstraint.constant = -values[0]
                    (object as SpringViewController).verticalConstraint.constant = -values[1]
                }
                property.threshold = 0.01
        }) as POPAnimatableProperty
        
        animation.property = customProperty
        animation.springSpeed = CGFloat(self.speedSlider.value)
        animation.springBounciness = CGFloat(self.bouncinessSlider.value)
        animation.toValue = NSValue(CGPoint:CGPointZero)
        animation.removedOnCompletion = true
        self.pop_addAnimation(animation, forKey: self.kAnimationName)
    }
}
