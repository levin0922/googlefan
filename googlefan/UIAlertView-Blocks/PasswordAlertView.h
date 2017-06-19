//
//  CustomAlertView.h
//  ComicLover
//
//  Created by levin wei on 8/29/12.
//  Copyright (c) 2012 MobileWoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIPasswordButtonItem.h"

@interface PasswordAlertView : UIAlertView <UITextFieldDelegate>

- (id)initWithTitle:(NSString *)inTitle
            message:(NSString *)inMessage
   cancelButtonItem:(RIPasswordButtonItem *)inCancelButtonItem
   otherButtonItems:(RIPasswordButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

@property (strong, nonatomic) NSString *plainText;

- (void)addTypePlain;
@end
