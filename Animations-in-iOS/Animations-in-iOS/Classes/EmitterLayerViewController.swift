//
//  EmitterLayerViewController.swift
//  Animations-in-iOS
//
//  Created by Eduard Panasiuk on 1/2/15.
//  Copyright (c) 2015 Eduard Panasiuk. All rights reserved.
//

import UIKit
import QuartzCore

class EmitterLayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var emitterLayer = CAEmitterLayer()
        emitterLayer.frame = self.view.bounds
        emitterLayer.emitterPosition = CGPointMake(emitterLayer.bounds.size.width / 2, emitterLayer.frame.origin.y)
        emitterLayer.emitterZPosition = 10
        emitterLayer.emitterSize = CGSizeMake(emitterLayer.bounds.size.width, 0)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        

        
        emitterLayer.emitterCells = [self.emitterCellFromImageName("snow"), self.emitterCellFromImageName("snow1"), self.emitterCellFromImageName("snow2")]
        
        self.view.layer .addSublayer(emitterLayer)
    }
    
    
    //MARK: - Utils
    func emitterCellFromImageName(name:String) -> (CAEmitterCell) {
        var emitterCell = CAEmitterCell()
        emitterCell.scale = 0.1
        emitterCell.scaleRange = 0.2
        emitterCell.emissionRange = 1.2
        emitterCell.lifetime = 5.0
        emitterCell.birthRate = 100
        emitterCell.velocity = 200
        emitterCell.velocityRange = 50
        emitterCell.yAcceleration = 120
        emitterCell.spinRange = 4;
        emitterCell.contents = UIImage(named: name)?.CGImage
        return emitterCell
    }
}
