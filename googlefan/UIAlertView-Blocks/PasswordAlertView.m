//
//  CustomAlertView.m
//  ComicLover
//
//  Created by levin wei on 8/29/12.
//  Copyright (c) 2012 MobileWoo. All rights reserved.
//

#import "PasswordAlertView.h"
#import <objc/runtime.h>

static NSString *RI_PASSWORD_BUTTON_ASS_KEY = @"com.random-ideas.PASSWORDBUTTONS";

@interface PasswordAlertView ()
@property(nonatomic, strong) UITextField *plainTextField;
@property(nonatomic, strong) UIView *passwordAccessoryView;
@end

@implementation PasswordAlertView

- (id)initWithTitle:(NSString *)inTitle
            message:(NSString *)inMessage
   cancelButtonItem:(RIPasswordButtonItem *)inCancelButtonItem
   otherButtonItems:(RIPasswordButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION
{
    if ((self = [self initWithTitle:inTitle
                            message:inMessage
                           delegate:self
                  cancelButtonTitle:inCancelButtonItem.label otherButtonTitles:nil])) {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        RIPasswordButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems) {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while ((eachItem = va_arg(argumentList, RIPasswordButtonItem *))) {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for (RIPasswordButtonItem *item in buttonsArray) {
            [self addButtonWithTitle:item.label];
        }
        
        if(inCancelButtonItem) {
            [buttonsArray insertObject:inCancelButtonItem atIndex:0];
        }
        
        objc_setAssociatedObject(self, (__bridge const void *)RI_PASSWORD_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setDelegate:self];
        
        [self addTypePlain];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)RI_PASSWORD_BUTTON_ASS_KEY);
    RIPasswordButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
    if(item.action)
        item.action(self.plainTextField.text);
    objc_setAssociatedObject(self, (__bridge const void *)RI_PASSWORD_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat maxY = CGRectGetMaxY(self.passwordAccessoryView.frame);
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UILabel class]] && [[[subView class] description] isEqualToString:@"UILabel"]) {
            maxY = CGRectGetMaxY(subView.frame);
        }
    }
    self.passwordAccessoryView.frame = CGRectMake(CGRectGetMinX(self.passwordAccessoryView.frame), maxY - CGRectGetHeight(self.passwordAccessoryView.frame) + 5, CGRectGetWidth(self.passwordAccessoryView.frame), CGRectGetHeight(self.passwordAccessoryView.frame));
}

#pragma mark Accessors

- (UITextField *)plainTextField
{
    if (!_plainTextField) {
        _plainTextField = [[UITextField alloc] initWithFrame:CGRectMake(14.0, 45.0, 256.0, 25.0)];
        _plainTextField.delegate = self;
        _plainTextField.backgroundColor = [UIColor whiteColor];
        _plainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _plainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _plainTextField;
}

- (UIView *)passwordAccessoryView
{
    if (!_passwordAccessoryView) {
        _passwordAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(14.0, 45.0, 256.0, 35.0)];
        _passwordAccessoryView.backgroundColor = [UIColor clearColor];
        [_passwordAccessoryView addSubview:self.plainTextField];
        self.plainTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.plainTextField.frame = CGRectMake(14, 0, _passwordAccessoryView.bounds.size.width - 28, _passwordAccessoryView.bounds.size.height - 10);
    }
    return _passwordAccessoryView;
}

- (NSString *)plainText
{
    return self.plainTextField.text;
}

- (void)addTypePlain
{
    [self setValue:self.passwordAccessoryView forKey:@"accessoryView"];
    [self.plainTextField becomeFirstResponder];
}

@end
