//
//  HeartViewController.swift
//  Animations-in-iOS
//
//  Created by Eduard Panasiuk on 6/1/15.
//  Copyright (c) 2015 Eduard Panasiuk. All rights reserved.
//

import UIKit

class HeartViewController: UIViewController {
    
    private lazy var heartLayer:CAEmitterLayer = {
        var emitterLayer = CAEmitterLayer()
        emitterLayer.frame = self.view.bounds
        emitterLayer.emitterPosition = self.view.center
        emitterLayer.emitterZPosition = 0
        emitterLayer.emitterSize = self.view.frame.size
        emitterLayer.emitterShape = kCAEmitterLayerPoint
        emitterLayer.emitterCells = [self.heartEmitterCell()]
        return emitterLayer
        }()
    
    private var animating:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func heartPressed(sender: UIButton) {
        if(animating){
            return
        }
        animateHeart()
    }
    
    //MARK: - Animation
    func animateHeart() -> () {
        animating = true
        heartLayer.opacity = 0
        view.layer.addSublayer(heartLayer)
        heartLayer.addAnimation(createFadeAnimation(), forKey: "fade")
    }
    
    func createFadeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.duration = 2.0
        animation.removedOnCompletion = false
        animation.delegate = self
        return animation
    }
    
    func heartEmitterCell() -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.2
        emitterCell.emissionRange = 1.2
        emitterCell.lifetime = 0.8
        emitterCell.birthRate = 3
        emitterCell.velocity = 80
        emitterCell.yAcceleration = -220
        emitterCell.scale = emitterCell.scale / UIScreen.mainScreen().scale
        emitterCell.contents = UIImage(named: "heart")?.CGImage
        return emitterCell
    }
    
    
    //MARK: - Animation delegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        heartLayer.removeFromSuperlayer()
        heartLayer.removeAllAnimations()
        heartLayer.opacity = 1
        animating = false
    }
}
