//
//  TransformTableViewController.swift
//  Animations-in-iOS
//
//  Created by Eduard Panasiuk on 1/2/15.
//  Copyright (c) 2015 Eduard Panasiuk. All rights reserved.
//

import UIKit

//implementation is based on this article: http://www.thinkandbuild.it/animating-uitableview-cells

class TransformTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Table cell #\(indexPath.row)"
        return cell
    }
    
     // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        

        //1. Setup the CATransform3D structure
        let angle = CGFloat(90*M_PI/180)
        var rotation = CATransform3DMakeRotation(angle, 0.0, 0.7, 0.4)
        rotation.m34 = 1.0 / -600;
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        cell.layer.anchorPoint = CGPointMake(0, 0.5);
        
        if(cell.layer.position.x != 0){
            cell.layer.position = CGPointMake(0, cell.layer.position.y);
        }
        
        //3. Define the final state (After the animation) and commit the animation
        
        UIView.beginAnimations("some animation", context: nil)
        UIView.setAnimationDuration(0.5)
        
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);

        UIView.commitAnimations()
    }
}
