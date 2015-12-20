//
//  SFCardStackWrapperView.h
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCardStackWrapperView : UIView

@property (nonatomic, assign) BOOL showsHeader;
@property (nonatomic, assign) BOOL showsTopSeparator;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong) UIView *accessoryView;

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, copy) void (^dismissHandler)();

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *titleColor;

+ (CGFloat)headerHeight;
+ (void)setHeaderHeight:(CGFloat)height;

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController;
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController showsHeader:(BOOL)header;

- (void)dismiss:(id)sender;

@end
