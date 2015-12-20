//
//  ViewController.swift
//  CardStackDemo
//
//  Created by Jan Haložan on 16/08/15.
//  Copyright (c) 2015 JanHalozan. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    @IBAction func notificationsTapped(sender: UIButton) {
        CardViewController.viewControllerNumber = 0
        
        let childViewController = CardViewController()
        let viewController = SFCardStackViewController(rootViewController: childViewController)
        
        viewController.present()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

