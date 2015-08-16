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

        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.text = "Card \(++CardViewController.viewControllerNumber)"
        
        self.view.addSubview(label)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[label]-10-|", options: .allZeros, metrics: nil, views: ["label": label]))
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        let instructionLabel = UILabel()
        instructionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        instructionLabel.textColor = UIColor.whiteColor()
        instructionLabel.textAlignment = .Center
        instructionLabel.numberOfLines = 0
        instructionLabel.text = "Tap anywhere to add a card. To dismiss me hold the white header and toss me off the screen or dismiss me with the done button."
        
        self.view.addSubview(instructionLabel)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[label]-10-|", options: .allZeros, metrics: nil, views: ["label": instructionLabel]))
        self.view.addConstraint(NSLayoutConstraint(item: instructionLabel, attribute: .Top, relatedBy: .Equal, toItem: label, attribute: .Bottom, multiplier: 1, constant: 20))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let viewController = CardViewController()
        self.cardStackViewController.pushViewController(viewController, animated: true)
    }
}
