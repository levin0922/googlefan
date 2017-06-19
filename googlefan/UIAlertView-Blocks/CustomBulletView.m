//
//  CustomAlertView.m
//  Pocket flea market
//
//  Created by guoxue
//  Copyright (c) 2012 MobileWoo. All rights reserved.
//

#import "CustomBulletView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


static NSString *RI_BulletView_ASS_KEY = @"com.random-ideas.BulletView";
static NSString *RI_BulletView_Cancel_ASS_KEY = @"com.random-ideas.BulletView_Cancel";

@interface CustomBulletView ()

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (UIInterfaceOrientation)currentOrientation;
- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;

@end

@implementation CustomBulletView

- (void)dealloc
{
    objc_setAssociatedObject(self, (__bridge const void *)RI_BulletView_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)RI_BulletView_Cancel_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithTitle:(NSString *)inTitle
           message:(NSString *)inMessage
        parentView:(UIView*)parentView
  cancelButtonItem:(RIButtonItem *)inCancelButtonItem
  otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    if (self = [super initWithFrame:parentView.bounds]) {
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.frame = self.bounds;
        bgButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [bgButton addTarget:self
                     action:@selector(onCloseButtonTouched:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, RIButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)RI_BulletView_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, (__bridge const void *)RI_BulletView_Cancel_ASS_KEY, inCancelButtonItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        _parentView = parentView;
        
        // background settings
        [self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"bulletViewBg.png"];
        UIImage *buttonImage = [UIImage imageNamed:@"bulletViewNormal.png"];
        
        // add the panel view
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, backgroundImage.size.width, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowOffset = CGSizeMake(0, 0);
        titleLabel.shadowColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1.0];
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        titleLabel.text = inTitle;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        CGSize opSize = [titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(titleLabel.frame), MAXFLOAT)];
        titleLabel.frame = CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), CGRectGetWidth(titleLabel.frame), opSize.height);
        
        CGFloat height = CGRectGetMaxY(titleLabel.frame) + 20 + buttonsArray.count * buttonImage.size.height + (NSInteger)(buttonsArray.count - 1) * 12.0 + 15 + buttonImage.size.height + 24;
        _panelView = [[UIView alloc] initWithFrame:CGRectMake(floorf((self.frame.size.width - backgroundImage.size.width) / 2), floorf((self.frame.size.height - height) / 2), backgroundImage.size.width, height)];
        _panelView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [[_panelView layer] setMasksToBounds:NO]; // very important
        [[_panelView layer] setCornerRadius:10.0];
        [self addSubview:_panelView];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[backgroundImage stretchableImageWithLeftCapWidth:floorf(backgroundImage.size.width / 2) topCapHeight:110]];
        bgView.frame = _panelView.bounds;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_panelView addSubview:bgView];
        
        [_panelView addSubview:titleLabel];
        
        CGFloat offset = CGRectGetMaxY(titleLabel.frame) + 20;
        for (int ii = 0; ii < buttonsArray.count; ii ++) {
            RIButtonItem *item = [buttonsArray objectAtIndex:ii];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = ii + 1;
            button.frame = CGRectMake(floorf((CGRectGetWidth(_panelView.frame) - buttonImage.size.width) / 2), offset, buttonImage.size.width, buttonImage.size.height);
            [button setBackgroundImage:[[UIImage imageNamed:@"bulletViewNormal.png"] stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width / 2) topCapHeight:floorf(buttonImage.size.height / 2)]
                              forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(onOK:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[[UIImage imageNamed:@"bulletViewNormal_high.png"] stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width / 2) topCapHeight:floorf(buttonImage.size.height / 2)]
                              forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [button setTitleColor:[UIColor colorWithRed:90 / 255.0
                                                  green:90 / 255.0
                                                   blue:90 / 255.0
                                                  alpha:1.0]
                         forState:UIControlStateNormal];
            [button setTitleShadowColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
            [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [button setTitle:item.label
                    forState:UIControlStateNormal];
            [_panelView addSubview:button];
            offset += buttonImage.size.height;
            offset += 12.0;
        }
        
        offset -= 12.0;
        offset += 15;
        if (inCancelButtonItem) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(floorf((CGRectGetWidth(_panelView.frame) - buttonImage.size.width) / 2), offset, buttonImage.size.width, buttonImage.size.height);
            [button setBackgroundImage:[[UIImage imageNamed:@"bulletViewCancel.png"] stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width / 2) topCapHeight:floorf(buttonImage.size.height / 2)]
                              forState:UIControlStateNormal];
            [button setBackgroundImage:[[UIImage imageNamed:@"bulletViewCancel_high.png"] stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width / 2) topCapHeight:floorf(buttonImage.size.height / 2)]
                              forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [button setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
            [button setTitleShadowColor:[UIColor colorWithRed:110 / 255.0
                                                        green:0.0
                                                         blue:0.0
                                                        alpha:1.0]
                               forState:UIControlStateNormal];
            [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [button setTitle:inCancelButtonItem.label
                    forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(onCloseButtonTouched:)
             forControlEvents:UIControlEventTouchUpInside];
            [_panelView addSubview:button];
        }
        
        //        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake((_panelView.frame.size.width - 270) / 2, 50, 270, 18)];
        //        detailLabel.backgroundColor = [UIColor clearColor];
        //        detailLabel.textColor = [UIColor colorWithRed:72 / 255.0 green:72 / 255.0 blue:72 / 255.0 alpha:1.0];
        //        detailLabel.numberOfLines = 0;
        //        detailLabel.font = [UIFont systemFontOfSize:14];
        //        detailLabel.textAlignment = UITextAlignmentCenter;
        //        detailLabel.text = message;
        //        opSize = [detailLabel.text sizeWithFont:detailLabel.font constrainedToSize:CGSizeMake(detailLabel.frame.size.width, MAXFLOAT)];
        //        detailLabel.frame = CGRectMake(detailLabel.frame.origin.x, detailLabel.frame.origin.y, detailLabel.frame.size.width, opSize.height);
        //        [_panelView addSubview:detailLabel];
        
        //        if (actionButton) {
        //            CGSize imageSize = [[actionButton backgroundImageForState:UIControlStateNormal] size];
        //            actionButton.frame = CGRectMake((_panelView.frame.size.width / 2 + (_panelView.frame.size.width / 2 - imageSize.width) / 2), _panelView.frame.size.height - 20 - imageSize.height, imageSize.width, imageSize.height);
        //            [actionButton addTarget:self action:@selector(onOK:) forControlEvents:UIControlEventTouchUpInside];
        //            [_panelView addSubview:actionButton];
        //        }
        //
        //        if (cancelButton) {
        //            CGSize imageSize = [[cancelButton backgroundImageForState:UIControlStateNormal] size];
        //            cancelButton.frame = CGRectMake((_panelView.frame.size.width / 2 - imageSize.width) / 2, _panelView.frame.size.height - 20 - imageSize.height, imageSize.width, imageSize.height);
        //            [cancelButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        //            [_panelView addSubview:cancelButton];
        //        }
        //
        //        // cancel button
        //        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(backgroundImage.size.width - 35, 8, 30, 30)];
        //        [closeButton setImage:[UIImage imageNamed:@"customAlertViewClose.png"] forState:UIControlStateNormal];
        //        [closeButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        //        [_panelView addSubview:closeButton];
        //        [_panelView bringSubviewToFront:closeButton];
    }
    return self;
}

- (void)onCloseButtonTouched:(id)sender
{
    if (!_isAnimating) {
        RIButtonItem *item = objc_getAssociatedObject(self, (__bridge const void *)RI_BulletView_Cancel_ASS_KEY);
        if(item.action)
            item.action();
        [self hide:YES];
    }
}

- (void)onOK:(id)sender
{
    NSArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)RI_BulletView_ASS_KEY);
    if (sender && buttonsArray) {
        UIButton *button = (UIButton *)sender;
        if (button.tag >= 1 && button.tag <= buttonsArray.count) {
            RIButtonItem *item = [buttonsArray objectAtIndex:button.tag - 1];
            if(item.action)
                item.action();
        }
    }
    [self hide:YES];
}

#pragma mark Orientations

- (UIInterfaceOrientation)currentOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
{
    [self setTransform:CGAffineTransformIdentity];
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self setFrame:_parentView.bounds];
    } else {
        [self setFrame:_parentView.bounds];
    }
    CGRect rootFrame = _parentView.bounds;
    //    rootFrame.origin.y = 20;
    //    rootFrame.size.height -= 20;
    
    [self setFrame:rootFrame];
    CGRect panelFrame = _panelView.frame;
    panelFrame.origin.x = (self.frame.size.width - panelFrame.size.width) / 2;
    panelFrame.origin.y = (self.frame.size.height - panelFrame.size.height) / 2;
    _panelView.frame = panelFrame;
    
    //    [self setTransform:[self transformForOrientation:orientation]];
    
    previousOrientation = orientation;
}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == UIInterfaceOrientationLandscapeLeft)
    {
        return CGAffineTransformMakeRotation(-M_PI / 2);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight)
    {
        return CGAffineTransformMakeRotation(M_PI / 2);
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return CGAffineTransformMakeRotation(-M_PI);
    }
    else
    {
        return CGAffineTransformIdentity;
    }
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == previousOrientation) {
        return NO;
    } else {
        return orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight
        || orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown;
    }
    return YES;
}

#pragma mark Obeservers

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}


#pragma mark Animations

- (void)bounceOutAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [_panelView setAlpha:0.8];
    [_panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
    [UIView commitAnimations];
}

- (void)bounceInAnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [_panelView setAlpha:1.0];
    [_panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
    [UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped
{
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped
{
    _isAnimating = NO;
    // nothing shall be done here
}

#pragma mark Dismiss

- (void)hideAndCleanUp
{
    objc_setAssociatedObject(self, (__bridge const void *)RI_BulletView_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void *)RI_BulletView_Cancel_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self removeObservers];
    [self removeFromSuperview];
}

#pragma mark - TaobaoSignupView Public Methods

- (void)show:(BOOL)animated
{
    [self setAlpha:1];
    [self sizeToFitOrientation:[self currentOrientation]];
    [_parentView addSubview:self];
    
    if (animated)
    {
        _isAnimating = YES;
        [_panelView setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
        [_panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [_panelView setAlpha:0.5];
        [_panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
    }
    else
    {
        [_panelView setAlpha:1.0];
        [self allAnimationsStopped];
    }
    
    [self addObservers];
}

- (void)hide:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
        [self setAlpha:0];
        [UIView commitAnimations];
    } else {
        [self hideAndCleanUp];
    }
}

#pragma mark - UIDeviceOrientationDidChangeNotification Methods

- (void)deviceOrientationDidChange:(id)object
{
    UIInterfaceOrientation orientation = [self currentOrientation];
    if ([self shouldRotateToOrientation:orientation])
    {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self sizeToFitOrientation:orientation];
        [UIView commitAnimations];
    }
}
@end
