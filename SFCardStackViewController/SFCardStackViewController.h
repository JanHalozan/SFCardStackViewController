//
//  SFCardStackViewController.h
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SFCardStackWrapperView.h"

@interface SFCardStackViewController : UIViewController

@property (nonatomic, assign) CGRect cardFrame;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) BOOL allowsPanningOnlyOnBezel;
@property (nonatomic, assign) BOOL showsHeaderOnRootViewController;

+ (BOOL)isCardStackPresented;
+ (instancetype)presentedCardStackViewController;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

- (void)present;
- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushCardStackWrapperView:(SFCardStackWrapperView *)view animated:(BOOL)animated;
- (void)popViewController;

@end
