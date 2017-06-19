//
//  UIImage+Additional.m
//  ComicLover~iPad
//
//  Created by Rena Wong on 14-2-18.
//  Copyright (c) 2014年 Levin Wei. All rights reserved.
//

#import "UIImage+Additional.h"

@implementation UIImage (Additional)

+ (UIImage *)cropedImageWithRect:(CGRect)rect
                         inImage:(UIImage *)image
{
    if (image.images) {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 rect.size.width,
                                                 rect.size.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) {
        CGImageRelease(imageRef);
        return image;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

+ (UIImage *)imageWithEdgeInsets:(UIEdgeInsets)insets
                         inImage:(UIImage *)image
{
    CGSize imageSize = CGSizeMake(image.size.width * image.scale, image.size.height * image.scale);
    CGPoint ltP = CGPointMake(insets.left * imageSize.width, insets.top * imageSize.height);
    CGSize realSize = CGSizeMake(MAX(imageSize.width * (1 - insets.left - insets.right), 1), MAX(1, imageSize.height * (1 - insets.top - insets.bottom)));
    return [self cropedImageWithRect:CGRectMake(ltP.x, ltP.y, realSize.width, realSize.height)
                             inImage:image];
}

+ (UIImage *)leftImageInImage:(UIImage *)image
{
    return [self leftImageInImage:image
                   withEdgeInsets:UIEdgeInsetsZero];
}

+ (UIImage *)leftImageInImage:(UIImage *)image
               withEdgeInsets:(UIEdgeInsets)insets
{
    CGSize imageSize = CGSizeMake(floorf(image.size.width * image.scale / 2), image.size.height * image.scale);
    CGPoint ltP = CGPointMake(insets.left * imageSize.width, insets.top * imageSize.height);
    CGSize realSize = CGSizeMake(MAX(imageSize.width * (1 - insets.left - insets.right), 1), MAX(1, imageSize.height * (1 - insets.top - insets.bottom)));
    return [self cropedImageWithRect:CGRectMake(ltP.x, ltP.y, realSize.width, realSize.height)
                             inImage:image];
}

+ (UIImage *)rightImageInImage:(UIImage *)image
{
    return [self rightImageInImage:image
                    withEdgeInsets:UIEdgeInsetsZero];
}

+ (UIImage *)rightImageInImage:(UIImage *)image
                withEdgeInsets:(UIEdgeInsets)insets
{
    CGSize imageSize = CGSizeMake(floorf(image.size.width * image.scale / 2), image.size.height * image.scale);
    CGPoint ltP = CGPointMake(insets.left * imageSize.width, insets.top * imageSize.height);
    CGSize realSize = CGSizeMake(MAX(imageSize.width * (1 - insets.left - insets.right), 1), MAX(1, imageSize.height * (1 - insets.top - insets.bottom)));
    return [self cropedImageWithRect:CGRectMake(imageSize.width + ltP.x, ltP.y, realSize.width, realSize.height)
                             inImage:image];
}

@end
