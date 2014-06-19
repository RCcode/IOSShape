//
//  UIImage+processing.h
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (processing)


- (UIImage *)changeTintColor:(UIColor *)tintColor;

- (UIImage *)changeGraph:(UIImage *)image;

- (UIImage *)subImageWithRect:(CGRect)rect;

+ (UIImage *)shapeMakeWithBottomImage:(UIImage *)_bottomImage andTopImage:(UIImage *)_topImage andBlendMode:(CGBlendMode)blendMode;

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

+ (UIImage *)getImageFromView:(UIView *)view;

+ (UIImage *)getEditFinishedImageWithView:(UIView *)backView andContextSize:(CGSize)size;

+ (UIImage *)blurryBottomImage:(UIImage *)bottomImage andTopImage:(UIImage *)topImage withBlurLevel:(CGFloat)blur;

- (UIImage *)rescaleImageToSize:(CGSize)size;

- (UIImage *)turnShapeWithImage:(UIImage *)image;

@end
