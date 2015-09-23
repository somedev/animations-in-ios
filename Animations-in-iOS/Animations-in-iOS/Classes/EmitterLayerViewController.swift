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
    
    private lazy var emitterLayer:CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = self.view.bounds
        emitterLayer.emitterPosition = CGPointMake(emitterLayer.bounds.size.width / 2, emitterLayer.frame.origin.y)
        emitterLayer.emitterZPosition = 10
        emitterLayer.emitterSize = CGSizeMake(emitterLayer.bounds.size.width, 0)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        emitterLayer.emitterCells = self.emitterCells()
        return emitterLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(emitterLayer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        emitterLayer.removeFromSuperlayer()
    }
    
    //MARK: - Utils
    func emitterCellFromImageName(name:String) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
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
    
    func emitterCells() -> [CAEmitterCell] {
        return [emitterCellFromImageName("snow"),
                emitterCellFromImageName("snow1"),
                emitterCellFromImageName("snow2")]
    }
}
