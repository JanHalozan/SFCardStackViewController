//
//  CardViewController.swift
//  CardStackDemo
//
//  Created by Jan Haložan on 16/08/15.
//  Copyright (c) 2015 JanHalozan. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    static var viewControllerNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup
        
        let randomFloatGenerator: ((Void) -> CGFloat) = {
            let num = Double(arc4random_uniform(255)) / 255.0
            return CGFloat(num)
        }
        
        self.view.backgroundColor = UIColor(red: randomFloatGenerator(), green: randomFloatGenerator(), blue: randomFloatGenerator(), alpha: 1)
        
        self.title = "Card \(++CardViewController.viewControllerNumber)"
        
        //Hack - for now...
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.cardStackWrapperView?.subtitleLabel.text = "SFCardStackViewController"
            
            let button = UIButton(type: .Custom)
            button.setTitleColor(UIColor.blueColor(), forState: .Normal)
            button.setTitle("✓", forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(20)
            button.addTarget(self, action: "popCard:", forControlEvents: .TouchUpInside)
            
            self.cardStackWrapperView?.accessoryView = button
        }
        
        let instructionLabel = UILabel()
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.textColor = UIColor.whiteColor()
        instructionLabel.textAlignment = .Center
        instructionLabel.numberOfLines = 0
        instructionLabel.text = "Tap anywhere to add a card. To dismiss me hold me and toss me off the screen or dismiss me with the ✓ button."
        
        self.view.addSubview(instructionLabel)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[label]-10-|", options: [], metrics: nil, views: ["label": instructionLabel]))
        self.view.addConstraint(NSLayoutConstraint(item: instructionLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 20))
        
        let recoginizer = UITapGestureRecognizer(target: self, action: "pushNewCard:")
        self.view.addGestureRecognizer(recoginizer)
    }
    
    func popCard(sender: AnyObject) {
        self.cardStackViewController?.popViewController()
    }
    
    func pushNewCard(sender: AnyObject) {
        let viewController = CardViewController()
        self.cardStackViewController?.pushViewController(viewController, animated: true)
    }
}
