//
//  UIImage+Additional.h
//  ComicLover~iPad
//
//  Created by Rena Wong on 14-2-18.
//  Copyright (c) 2014年 Levin Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additional)

+ (UIImage *)cropedImageWithRect:(CGRect)rect
                         inImage:(UIImage *)image;

+ (UIImage *)imageWithEdgeInsets:(UIEdgeInsets)insets
                         inImage:(UIImage *)image;

+ (UIImage *)leftImageInImage:(UIImage *)image;
+ (UIImage *)leftImageInImage:(UIImage *)image
               withEdgeInsets:(UIEdgeInsets)insets;
+ (UIImage *)rightImageInImage:(UIImage *)image;
+ (UIImage *)rightImageInImage:(UIImage *)image
                withEdgeInsets:(UIEdgeInsets)insets;

@end
