//
//  ViewController.m
//  googlefan
//
//  Created by Rena Wang on 2017/6/18.
//  Copyright © 2017年 Rena Wang. All rights reserved.
//

#import "ViewController.h"
#import "UIAlertView+Blocks.h"


@interface ViewController ()

@property (strong, nonatomic) NSString *currentStr;

@property (strong, nonatomic) NSString *model;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    CGFloat height = CGRectGetMaxY(self.textview2.frame) - CGRectGetMinY(self.textview1.frame);
    CGFloat textviewHeight = floor((height - 60) / 2);
    CGRect frame1 = self.textview1.frame;
    CGRect frame2 = self.textview2.frame;
    frame1.size.height = textviewHeight;
    frame2.origin.y = CGRectGetMaxY(self.textview2.frame) - textviewHeight;
    frame2.size.height = textviewHeight;
    self.textview1.frame = frame1;
    self.textview2.frame = frame2;
    
    CGRect fanFrame = self.fanButton.frame;
    fanFrame.origin.y = floor((CGRectGetMinY(self.textview2.frame) + CGRectGetMaxY(self.textview1.frame) - CGRectGetHeight(self.fanButton.frame)) / 2);
    self.fanButton.frame = fanFrame;
    
    CGRect clearFrame = self.clearButton.frame;
    clearFrame.origin.x = fanFrame.origin.x - 10 - clearFrame.size.width;
    clearFrame.origin.y = fanFrame.origin.y;
    self.clearButton.frame = clearFrame;
    [self textView1Changed];
    
    CGRect promptFrame = self.promptLabel.frame;
    promptFrame.origin.y = floor((CGRectGetMinY(self.textview2.frame) + CGRectGetMaxY(self.textview1.frame) - CGRectGetHeight(self.promptLabel.frame)) / 2);
    self.promptLabel.frame = promptFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)fanyi:(id)sender {
    NSString *str = [self.textview1.text
                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    void (^block)(void) = ^(void){
        [[AppDelegate theAppDelegate] showActivityView:@"查询中..."
                                                inView:self.view];
        [[DataEngine sharedInstance] translateSimple:str
                                             success:^(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMsg) {
                                                 NSDictionary *res = operation.responseObject;
                                                 NSString *errMsg = @"请求出错";
                                                 if ([res isKindOfClass:[NSDictionary class]] && [[res objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[[res objectForKey:@"data"] objectForKey:@"translations"] isKindOfClass:[NSArray class]] && [[[res objectForKey:@"data"] objectForKey:@"translations"] count] > 0) {
                                                     NSArray *trans = [[res objectForKey:@"data"] objectForKey:@"translations"];
                                                     NSDictionary *tranRes = [trans objectAtIndex:0];
                                                     if ([tranRes objectForKey:@"detectedSourceLanguage"] && [tranRes objectForKey:@"model"] && [tranRes objectForKey:@"translatedText"]) {
                                                         errMsg = nil;
                                                         self.model = [tranRes objectForKey:@"model"];
                                                         self.currentStr = str;
                                                         self.textview2.text = [tranRes objectForKey:@"translatedText"];
                                                         self.model = [tranRes objectForKey:@"model"];
                                                         if ([self.model isKindOfClass:[NSString class]] && [[self.model lowercaseString] isEqualToString:@"nmt"]) {
                                                             self.promptLabel.text = @"神经机器翻译(NMT)";
                                                         } else {
                                                             // base
                                                             self.promptLabel.text = @"分词机器翻译(PBMT)";
                                                         }
                                                         [self textView1Changed];
                                                     }
                                                 }
                                                 if (errMsg.length) {
                                                     [[AppDelegate theAppDelegate] showFailedActivityView:errMsg
                                                                                                 interval:1.5
                                                                                                   inView:self.view];
                                                 } else {
                                                     [[AppDelegate theAppDelegate] hideActivityView:self.view];
                                                 }
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSDictionary *res = operation.responseObject;
                                                 NSString *errMsg = @"请求出错：";
                                                 if ([res isKindOfClass:[NSDictionary class]] && [[res objectForKey:@"error"] isKindOfClass:[NSDictionary class]]) {
                                                     NSDictionary *error = [res objectForKey:@"error"];
                                                     if ([error objectForKey:@"code"]) {
                                                         errMsg = [errMsg stringByAppendingFormat:@"%@：",[error objectForKey:@"code"]];
                                                     }
                                                     if ([error objectForKey:@"message"]) {
                                                         errMsg = [errMsg stringByAppendingFormat:@"%@",[error objectForKey:@"message"]];
                                                     }
                                                 }
                                                 [[AppDelegate theAppDelegate] showFailedActivityView:errMsg
                                                                                             interval:1.5
                                                                                               inView:self.view];
                                             }];
    };
    if (str.length > 1000) {
        RIButtonItem *okItem = [RIButtonItem item];
        okItem.label = NSLocalizedString(@"确定", nil);
        okItem.action = ^{
            block();
        };
        RIButtonItem *cancelItem = [RIButtonItem item];
        cancelItem.label = NSLocalizedString(@"取消", nil);
        cancelItem.action = ^{
        };
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"长度大于1000，确定翻译吗？"
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:okItem, nil];
        [alert show];
        
    } else {
        block();
    }
}

- (IBAction)qingkong:(id)sender {
    [self.textview1 setText:@""];
    [self.textview2 setText:@""];
    [self textView1Changed];
}

- (void)textView1Changed
{
    NSString *str = [self.textview1.text
                     stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length == 0 || [str isEqualToString:self.currentStr]) {
        self.fanButton.enabled = NO;
    } else {
        self.fanButton.enabled = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.textview1) {
        [self textView1Changed];
    }
}
@end
