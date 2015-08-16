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
        
        let viewController = CardViewController()
        let cardStackViewController = SFCardStackViewController(rootViewController: viewController)
        cardStackViewController.present()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

