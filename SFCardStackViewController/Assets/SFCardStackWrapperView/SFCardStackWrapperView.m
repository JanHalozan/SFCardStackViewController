//
//  SFCardStackWrapperView.m
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import "SFCardStackWrapperView.h"

CGFloat headerHeight = 75.0f;

@interface SFCardStackWrapperView()
{
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UIImageView *_imageView;

    UIColor *_titleColor;
}

@property (nonatomic, strong) CALayer *separatorLayer;

@end

@implementation SFCardStackWrapperView

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize imageView = _imageView;

@synthesize titleColor = _titleColor;

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
    return [self initWithFrame:frame viewController:viewController showsHeader:YES];
}

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)viewController showsHeader:(BOOL)header
{
    if (!(self = [super initWithFrame:frame]))
        return nil;

    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];

    self.showsHeader = header;
    self.showsTopSeparator = YES;
    self.viewController = viewController;

    _titleLabel = nil;
    _subtitleLabel = nil;
    _imageView = nil;

    _titleColor = nil;

    self.layer.cornerRadius = 12.5f;
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    self.layer.shadowOpacity = 0.25f;

    if (self.showsHeader)
        [self.layer addSublayer:self.separatorLayer];

    return self;
}

- (void)dismiss:(id)sender
{
    if (self.dismissHandler)
        self.dismissHandler();
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.separatorLayer.frame = CGRectMake(0.0f, headerHeight - 0.5f, CGRectGetWidth(self.bounds), 0.5f);

    CGFloat originX = 15.5f;
    CGFloat midY = headerHeight * 0.5f;

    if (self->_imageView)
    {
        _imageView.frame = CGRectMake(originX, headerHeight * 0.5f - 16.0f, 39.0f, 39.0f);
        _imageView.layer.cornerRadius = CGRectGetWidth(_imageView.frame) * 0.5f;
        originX += 39.0f + 11.25f;
    }

    if (self->_subtitleLabel)
    {
        self.subtitleLabel.frame = CGRectMake(originX, midY + 7.0f, CGRectGetWidth(self.bounds) * 0.66f - 18.0f, self.subtitleLabel.font.lineHeight);
        midY -= 7.25f;
    }

    if (self->_titleLabel)
    {
        self.titleLabel.frame = CGRectMake(originX, midY - self.titleLabel.font.lineHeight * 0.5f - 0.5f, CGRectGetWidth(self.bounds) * 0.66f - 18.0f, self.titleLabel.font.lineHeight);
    }

    if (self->_accessoryView)
    {
        self.accessoryView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 48.0f, headerHeight * 0.5f - 23.5f, 50.0f, 50.0f);
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
        _titleLabel.textColor = self.titleColor;

        [self addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
        _subtitleLabel.textColor = [UIColor colorWithWhite:0.65f alpha:1.0f];

        [self addSubview:_subtitleLabel];
    }

    return _subtitleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.layer.masksToBounds = YES;

        [self addSubview:_imageView];
    }

    return _imageView;
}

- (void)setViewController:(UIViewController *)viewController
{
    NSAssert(viewController != nil, @"ViewController must not be nil");

    _viewController = viewController;

    if (_viewController.title)
        self.titleLabel.text = _viewController.title;

    [_viewController addObserver:self forKeyPath:@"title" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:NULL];

    if (self.showsHeader)
    {
        UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0.0f, headerHeight - 12.5f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - headerHeight + 12.5f)];
        wrapper.layer.cornerRadius = 12.5f;
        wrapper.layer.masksToBounds = YES;
        _viewController.view.frame = CGRectMake(0.0f, 12.5f, CGRectGetWidth(wrapper.bounds), CGRectGetHeight(wrapper.bounds) - 12.5f);
        [wrapper addSubview:_viewController.view];
        [self addSubview:wrapper];
    }
    else
    {
        _viewController.view.frame = self.bounds;
        [self addSubview:_viewController.view];
    }
}

- (CALayer *)separatorLayer
{
    if (!_separatorLayer)
    {
        _separatorLayer = [CALayer layer];
        _separatorLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.2f] CGColor];

        if (!self.showsTopSeparator)
            _separatorLayer.hidden = YES;
    }

    return _separatorLayer;
}

- (void)setShowsTopSeparator:(BOOL)showsTopSeparator
{
    _showsTopSeparator = showsTopSeparator;

    if (_separatorLayer)
        self.separatorLayer.hidden = !_showsTopSeparator;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if ([tintColor isEqual:_tintColor] || !tintColor)
        return;

    _tintColor = tintColor;
    self.backgroundColor = _tintColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;

    if (_titleLabel)
        self.titleLabel.textColor = _titleColor;
}

- (UIColor *)titleColor
{
    if (!_titleColor)
        _titleColor = [UIColor blackColor];

    return _titleColor;
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    if (_accessoryView)
        [_accessoryView removeFromSuperview];

    _accessoryView = accessoryView;

    if (_accessoryView)
        [self addSubview:_accessoryView];
}

- (void)dealloc
{
    [self.viewController willMoveToParentViewController:nil];
    [self.viewController removeObserver:self forKeyPath:@"title"];
    [self.viewController.view removeFromSuperview];
    [self.viewController removeFromParentViewController];
    [self.viewController didMoveToParentViewController:nil];

    _viewController = nil;
}

@end
