//
//  SFCardStackWrapperView.h
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCardStackWrapperView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, copy) void (^dismissHandler)();

+ (CGFloat)headerHeight;
+ (void)setHeaderHeight:(CGFloat)height;

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController;

@property (nonatomic, strong) UIColor *tintColor;

@end
