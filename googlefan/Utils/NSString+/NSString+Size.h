//
//  NSString+Size.h
//  追追漫画
//
//  Created by chenfei on 16/6/16.
//  Copyright © 2016年 Levin Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

@end
