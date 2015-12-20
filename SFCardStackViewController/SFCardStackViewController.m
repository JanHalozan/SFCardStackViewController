//
//  SFCardStackViewController.m
//  Databox
//
//  Created by Jan Haložan on 06/08/15.
//  Copyright (c) 2015 Jan Haložan. All rights reserved.
//

#import "SFCardStackViewController.h"

#import "SFCardStackWrapperView.h"
#import "UIImage+ImageEffects.h"

#define kCardStackWindowTag 101
#define kCardStackWindowLayerName @"cardStackWindow"

@interface SFCardStackViewController()
{
    UIColor *_backgroundColor;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIWindow *previousKeyWindow;

@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic, strong) NSMutableArray *wrapperViews;

@property (nonatomic, strong) UIDynamicAnimator *animator;

- (void)popViewControllerWithVelocity:(CGPoint)velocity andMagnitude:(CGFloat)magnitude angularVelocity:(CGFloat)angularVelocity;

- (void)panCallback:(UIPanGestureRecognizer *)sender;
- (void)setupPanRecognizer;

- (CABasicAnimation *)cardAnimationWithStartTransform:(CATransform3D)start endTransform:(CATransform3D)end duration:(NSTimeInterval)duration easingFunctionName:(NSString *)name;

@end

@implementation SFCardStackViewController

@synthesize backgroundColor = _backgroundColor;

+ (BOOL)isCardStackPresented
{
    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    return window.tag == kCardStackWindowTag && [window.layer.name isEqualToString:kCardStackWindowLayerName];
}

+ (instancetype)presentedCardStackViewController
{
    if (![self isCardStackPresented])
        return nil;

    return (SFCardStackViewController *)UIApplication.sharedApplication.keyWindow.rootViewController;
}

- (instancetype)init
{
    NSAssert(NO, @"Use the designated initializer 'initWithRootViewController:'");
    return nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSAssert(NO, @"Use the designated initializer 'initWithRootViewController:'");
    return nil;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.showsHeaderOnRootViewController = YES;
        self.previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
        self.rootViewController = rootViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self setupPanRecognizer];
}

- (void)present
{
//    self.rootViewController = nil;
    [self.window makeKeyAndVisible];
    [self pushViewController:self.rootViewController animated:YES];

    [UIView animateWithDuration:0.25f animations:^{
        self.view.backgroundColor = self.backgroundColor;
    }];

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dismiss
{
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated
{
    __weak typeof(self) weakSelf = self;

    void (^finishBlock)() = ^{
        [weakSelf.animator removeAllBehaviors];
        [weakSelf.previousKeyWindow makeKeyAndVisible];
        weakSelf.window.rootViewController = nil;
        weakSelf.window = nil;
    };

    if (!animated)
    {
        finishBlock();
        return;
    }

    if (self.wrapperViews.count > 0)
    {
        [self.animator removeAllBehaviors];

        __weak SFCardStackWrapperView *rootWrapper = [self.wrapperViews firstObject];
        UIGravityBehavior *behaviour = [[UIGravityBehavior alloc] initWithItems:self.wrapperViews];
        behaviour.magnitude = 7.5f;
        behaviour.action = ^{
            if (!CGRectIntersectsRect(weakSelf.view.bounds, rootWrapper.frame))
                finishBlock();
        };

        [self.animator addBehavior:behaviour];
    }
    else
    {
        finishBlock();
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.animator.behaviors.count > 0)
    {
        NSLog(@"Unable to push a view controller while a presentation is already in progress.");
        return;
    }

    const CGRect frame = animated ? CGRectOffset(self.cardFrame, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.75f) : self.cardFrame;
    SFCardStackWrapperView *wrapper = [[SFCardStackWrapperView alloc] initWithFrame:frame viewController:viewController showsHeader:self.showsHeaderOnRootViewController];

    __weak typeof(self) weakSelf = self;
    wrapper.dismissHandler = ^{
        [weakSelf popViewController];
    };

    [self pushCardStackWrapperView:wrapper animated:animated];
}

- (void)pushCardStackWrapperView:(SFCardStackWrapperView *)view animated:(BOOL)animated
{
    if (self.animator.behaviors.count > 0)
    {
        NSLog(@"Unable to push a view controller while a presentation is already in progress.");
        return;
    }

    view.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:5.0f] CGPath];

    [view.viewController willMoveToParentViewController:self];
    [self addChildViewController:view.viewController];

    [self.view addSubview:view];

    [self.animator removeAllBehaviors];

    if (animated)
    {
        const CGPoint snapPoint = CGPointMake(CGRectGetMidX(self.cardFrame), CGRectGetMidY(self.cardFrame));
        UISnapBehavior *behaviour = [[UISnapBehavior alloc] initWithItem:view snapToPoint:snapPoint];
        behaviour.damping = 1.0f;
        behaviour.action = ^{
            if (CGPointEqualToPoint(view.center, snapPoint))
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.animator removeAllBehaviors];
                });
            }
        };

        [self.animator addBehavior:behaviour];

        UIDynamicItemBehavior *resistance = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
        resistance.resistance = 50.0f;

        [behaviour addChildBehavior:resistance];
    }

    NSUInteger i = 0;
    for (SFCardStackWrapperView *previousWrapper in self.wrapperViews.reverseObjectEnumerator)
    {
        switch (i)
        {
            case 0:
            {
                CATransform3D transform = CATransform3DConcat(CATransform3DMakeTranslation(0.0f, -25.0f, 0.0f), CATransform3DMakeScale(0.95f, 0.95f, 1.0f));
                CABasicAnimation *animation = [self cardAnimationWithStartTransform:CATransform3DIdentity endTransform:transform duration:0.25f easingFunctionName:kCAMediaTimingFunctionEaseOut];

                [previousWrapper.layer addAnimation:animation forKey:@"animation"];
                previousWrapper.layer.transform = transform;
            }
                break;
            case 1:
            {
                CATransform3D transform = CATransform3DConcat(CATransform3DMakeTranslation(0.0f, -47.5f, 0.0f), CATransform3DMakeScale(0.9f, 0.9f, 1.0f));
                CABasicAnimation *animation = [self cardAnimationWithStartTransform:previousWrapper.layer.transform endTransform:transform duration:0.25f easingFunctionName:kCAMediaTimingFunctionEaseOut];

                [previousWrapper.layer addAnimation:animation forKey:@"animation"];
                previousWrapper.layer.transform = transform;
            }
                break;
            default:
            {
                previousWrapper.hidden = YES;
            }
                break;
        }

        ++i;
    }

    [self.wrapperViews addObject:view];
    [view.viewController didMoveToParentViewController:self];
}

- (void)popViewControllerWithVelocity:(CGPoint)velocity andMagnitude:(CGFloat)magnitude angularVelocity:(CGFloat)angularVelocity
{
    [self.animator removeAllBehaviors];

    SFCardStackWrapperView *wrapperView = [self.wrapperViews lastObject];
    __weak SFCardStackWrapperView *weakWrapper = wrapperView;
    __weak typeof(self) weakSelf = self;

    void (^finishBlock)() = ^{
        if (weakSelf.wrapperViews.count - 1 == 0)
        {
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.view.backgroundColor = [UIColor clearColor];
            } completion:nil];
        }

        if (!CGRectIntersectsRect(weakSelf.view.bounds, weakWrapper.frame))
        {
            dispatch_async(dispatch_get_main_queue(), ^{ //Otherwise the animator wont remove the behaviour which called this block
                [weakSelf.animator removeAllBehaviors];
            });

            [weakWrapper removeFromSuperview];
            [weakSelf.wrapperViews removeLastObject];

            if (weakSelf.wrapperViews.count > 0)
            {
                NSUInteger i = 0;
                for (SFCardStackWrapperView *previousWrapper in weakSelf.wrapperViews.reverseObjectEnumerator)
                {
                    switch (i)
                    {
                        case 0:
                        {
                            CABasicAnimation *animation = [self cardAnimationWithStartTransform:previousWrapper.layer.transform endTransform:CATransform3DIdentity duration:0.25f easingFunctionName:kCAMediaTimingFunctionEaseIn];

                            [previousWrapper.layer addAnimation:animation forKey:@"animation"];
                            previousWrapper.layer.transform = CATransform3DIdentity;
                        }
                            break;
                        case 1:
                        {
                            previousWrapper.hidden = NO;

                            CATransform3D transform = CATransform3DConcat(CATransform3DMakeTranslation(0.0f, -25.0f, 0.0f), CATransform3DMakeScale(0.95f, 0.95f, 1.0f));
                            CABasicAnimation *animation = [self cardAnimationWithStartTransform:previousWrapper.layer.transform endTransform:transform duration:0.25f easingFunctionName:kCAMediaTimingFunctionEaseIn];

                            [previousWrapper.layer addAnimation:animation forKey:@"animation"];
                            previousWrapper.layer.transform = transform;
                        }
                            break;
                        default:
                            break;
                    }

                    ++i;
                }
            }
            else
            {
                [weakSelf dismiss];
            }
        }
    };

    if (CGPointEqualToPoint(velocity, CGPointZero) || magnitude == 0.0f)
    {
        UIGravityBehavior *behaviour = [[UIGravityBehavior alloc] initWithItems:@[wrapperView]];
        behaviour.magnitude = 7.5f;
        behaviour.action = ^{
            finishBlock();
        };

        [self.animator addBehavior:behaviour];
    }
    else
    {
        NSArray *items = @[wrapperView];
        UIPushBehavior *behaviour = [[UIPushBehavior alloc] initWithItems:items mode:UIPushBehaviorModeInstantaneous];
        behaviour.pushDirection = CGVectorMake(velocity.x * 0.1f, velocity.y * 0.1f);
        behaviour.magnitude = magnitude / 10.0f;
        behaviour.action = ^{
            finishBlock();
        };

        [self.animator addBehavior:behaviour];

        UIDynamicItemBehavior *spinBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:items];
        spinBehaviour.friction = 0.2f;
        spinBehaviour.allowsRotation = YES;
        [spinBehaviour addAngularVelocity:angularVelocity forItem:wrapperView];

        [self.animator addBehavior:spinBehaviour];
    }
}

- (void)popViewController
{
    [self popViewControllerWithVelocity:CGPointZero andMagnitude:0.0f angularVelocity:0.0f];
}

- (void)panCallback:(UIPanGestureRecognizer *)sender
{
    SFCardStackWrapperView *wrapperView = [self.wrapperViews lastObject];
    const CGPoint location = [sender locationInView:self.view];
    const CGPoint wrapperLocation = [sender locationInView:wrapperView];

    static CFAbsoluteTime lastTime;
    static CGFloat lastAngle;
    static CGFloat angularVelocity;

    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            SFCardStackWrapperView *wrapper = [self.wrapperViews lastObject];

            if ([self.view hitTest:location withEvent:nil] != wrapper && self.allowsPanningOnlyOnBezel)
            {
                sender.enabled = NO;
                sender.enabled = YES;
                return;
            }

            [self.animator removeAllBehaviors];
            UIOffset centerOffset = UIOffsetMake(wrapperLocation.x - CGRectGetMidX(wrapperView.bounds), wrapperLocation.y - CGRectGetMidY(wrapperView.bounds));
            UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:wrapperView offsetFromCenter:centerOffset attachedToAnchor:location];

            lastTime = CFAbsoluteTimeGetCurrent();
            lastAngle = atan2(wrapper.transform.b, wrapper.transform.a);

            behavior.action = ^{
                const CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
                const CGFloat angle = atan2(wrapper.transform.b, wrapper.transform.a);

                if (time > lastTime)
                {
                    angularVelocity = (angle - lastAngle) / (time - lastTime);
                    lastTime = time;
                    lastAngle = angle;
                }
            };

            [self.animator addBehavior:behavior];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            UIAttachmentBehavior *behavior = [self.animator.behaviors firstObject];
            behavior.anchorPoint = location;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.animator removeAllBehaviors];

            const CGPoint velocity = [sender velocityInView:self.view];
            const CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));

            if (magnitude > 1000.0f)
            {
                [self popViewControllerWithVelocity:velocity andMagnitude:magnitude angularVelocity:angularVelocity];
            }
            else
            {
                const CGPoint snapPoint = CGPointMake(CGRectGetMidX(self.cardFrame), CGRectGetMidY(self.cardFrame));
                UISnapBehavior *behaviour = [[UISnapBehavior alloc] initWithItem:wrapperView snapToPoint:snapPoint];
                behaviour.damping = 1.0f;
                behaviour.action = ^{
                    if (CGPointEqualToPoint(wrapperView.center, snapPoint))
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.animator removeAllBehaviors];
                        });
                    }
                };

                [self.animator addBehavior:behaviour];

                UIDynamicItemBehavior *resistance = [[UIDynamicItemBehavior alloc] initWithItems:@[wrapperView]];
                resistance.resistance = 50.0f;

                [self.animator addBehavior:resistance];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setupPanRecognizer
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCallback:)];
    [self.view addGestureRecognizer:recognizer];
}

- (CABasicAnimation *)cardAnimationWithStartTransform:(CATransform3D)start endTransform:(CATransform3D)end duration:(NSTimeInterval)duration easingFunctionName:(NSString *)name
{
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:start];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:end];
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:name];
    transformAnimation.duration = duration;

    return transformAnimation;
}

#pragma Mark - UIViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma Mark - Property loaders

- (UIWindow *)window
{
    if (!_window)
    {
        const CGRect frame = [[UIScreen mainScreen] bounds];
        _window = [[UIWindow alloc] initWithFrame:frame];
        _window.rootViewController = self;
        _window.tag = kCardStackWindowTag;
        _window.layer.name = kCardStackWindowLayerName;
    }

    return _window;
}

- (CGRect)cardFrame
{
    if (CGRectIsEmpty(_cardFrame))
    {
        const CGRect screenBounds = [[UIScreen mainScreen] bounds];
        _cardFrame = CGRectInset(screenBounds, 9.0f, 0.0f);
        _cardFrame.origin.y = 31.0f;
        _cardFrame.size.height = CGRectGetHeight(screenBounds) - 91.0f;
    }

    return _cardFrame;
}

- (UIColor *)backgroundColor
{
    if (!_backgroundColor)
        _backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.85f];

    return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;

    if (self.wrapperViews.count > 0)
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.view.backgroundColor = self.backgroundColor;
        }];
    }
}

- (NSMutableArray *)wrapperViews
{
    if (!_wrapperViews)
        _wrapperViews = [NSMutableArray array];

    return _wrapperViews;
}

- (void)dealloc
{
    NSLog(@"SFCardStackViewController deallocating");
}

@end
