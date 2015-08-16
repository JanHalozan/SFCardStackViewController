//
//  UIViewController+SFCardStackViewController.m
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import "UIViewController+SFCardStackViewController.h"

@implementation UIViewController (SFCardStackViewController)

- (SFCardStackViewController *)cardStackViewController
{
    if ([self.parentViewController isKindOfClass:SFCardStackViewController.class])
        return (SFCardStackViewController *)self.parentViewController;
    
    return nil;
}

- (SFCardStackWrapperView *)cardStackWrapperView
{
    if ([self.view.superview.superview isKindOfClass:SFCardStackWrapperView.class])
        return (SFCardStackWrapperView *)self.view.superview.superview;
    
    return nil;
}

@end
