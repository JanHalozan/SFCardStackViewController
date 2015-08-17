//
//  SFCardStackViewController.h
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SFCardStackViewController : UIViewController

@property (nonatomic, assign) CGRect cardFrame;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

- (void)present;
- (void)dismiss;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewController;

@end
