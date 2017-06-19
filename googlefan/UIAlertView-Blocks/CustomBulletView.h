//
//  CustomAlertView.h
//  Pocket flea market
//
//  Created by guoxue
//  Copyright (c) 2012 MobileWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

@interface CustomBulletView : UIView
{
    UIView *_panelView;
    
    UIInterfaceOrientation previousOrientation;
    
    UIView *_parentView;
    
    BOOL _isAnimating;
}

-(id)initWithTitle:(NSString *)inTitle
           message:(NSString *)inMessage
        parentView:(UIView*)parentView
  cancelButtonItem:(RIButtonItem *)inCancelButtonItem
  otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
