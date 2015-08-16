//
//  UIViewController+SFCardStackViewController.h
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SFCardStackViewController.h"
#import "SFCardStackWrapperView.h"

@interface UIViewController (SFCardStackViewController)

@property (nonatomic, weak, readonly) SFCardStackViewController *cardStackViewController;
@property (nonatomic, weak, readonly) SFCardStackWrapperView *cardStackWrapperView;

@end
