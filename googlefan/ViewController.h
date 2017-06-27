//
//  ViewController.h
//  googlefan
//
//  Created by Rena Wang on 2017/6/18.
//  Copyright © 2017年 Rena Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textview1;
@property (strong, nonatomic) IBOutlet UITextView *textview2;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *fanButton;

- (IBAction)fanyi:(id)sender;
- (IBAction)qingkong:(id)sender;
@end

