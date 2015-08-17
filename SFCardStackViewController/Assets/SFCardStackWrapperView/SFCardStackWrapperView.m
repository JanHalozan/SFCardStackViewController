//
//  SFCardStackWrapperView.m
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import "SFCardStackWrapperView.h"

CGFloat headerHeight = 67.5f;

@interface SFCardStackWrapperView()

@property (nonatomic, strong) CALayer *separatorLayer;

- (void)doneTapped:(UIButton *)sender;

@end

@implementation SFCardStackWrapperView

+ (void)setHeaderHeight:(CGFloat)height
{
    headerHeight = height;
}

+ (CGFloat)headerHeight
{
    return headerHeight;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero viewController:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame viewController:nil];
}

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];

        self.viewController = viewController;

        self.layer.cornerRadius = 7.5f;
        self.layer.shadowRadius = 5.0f;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
        self.layer.shadowOpacity = 0.25f;

        [self.layer addSublayer:self.separatorLayer];
    }
    return self;
}

- (void)doneTapped:(UIButton *)sender
{
    if (self.dismissHandler)
        self.dismissHandler();
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.separatorLayer.frame = CGRectMake(0.0f, headerHeight - 0.5f, CGRectGetWidth(self.bounds), 0.5f);

    if (self->_titleLabel)
    {
        self.titleLabel.frame = CGRectMake(18.0f, 5.0f, CGRectGetWidth(self.bounds) * 0.66f - 18.0f, headerHeight - 5.0f);
    }

    if (self->_doneButton)
    {
        const CGFloat width = CGRectGetWidth(self.bounds) * 0.33f - 18.0f;
        self.doneButton.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.66f, 5.0f, width, headerHeight - 5.0f);
    }
}

#pragma Mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.viewController.title)
                self.titleLabel.text = self.viewController.title;
        });
    }
}

#pragma Mark Properties

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0f];

        [self addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (UIButton *)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.5f];
        _doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_doneButton setTitleColor:[UIColor colorWithRed:0.0f green:0.66f blue:0.91f alpha:1.0f] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_doneButton addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_doneButton];
    }

    return _doneButton;
}

- (void)setViewController:(UIViewController *)viewController
{
    NSAssert(viewController != nil, @"ViewController must not be nil");

    _viewController = viewController;

    if (_viewController.title)
        self.titleLabel.text = _viewController.title;

    [_viewController addObserver:self forKeyPath:@"title" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:NULL];

    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerHeight - 7.5f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - headerHeight + 7.5f)];
    wrapper.layer.cornerRadius = 7.5f;
    wrapper.layer.masksToBounds = YES;
    _viewController.view.frame = CGRectMake(0.0f, 7.5f, CGRectGetWidth(wrapper.bounds), CGRectGetHeight(wrapper.bounds) - 7.5f);
    [wrapper addSubview:_viewController.view];
    [self addSubview:wrapper];
}

- (CALayer *)separatorLayer
{
    if (!_separatorLayer)
    {
        _separatorLayer = [CALayer layer];
        _separatorLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.2f] CGColor];
    }

    return _separatorLayer;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if ([tintColor isEqual:_tintColor] || !tintColor)
        return;

    _tintColor = tintColor;
    self.backgroundColor = _tintColor;
}

- (void)setDismissHandler:(void (^)())dismissHandler
{
    if (dismissHandler)
    {
        _dismissHandler = dismissHandler;

        if (!_doneButton)
            [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [self.viewController removeObserver:self forKeyPath:@"title"];
    _viewController = nil;
}

@end
