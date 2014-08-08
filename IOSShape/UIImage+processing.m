//
//  UIImage+processing.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "UIImage+processing.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

#import "PHO_AppDelegate.h"

@implementation UIImage (processing)


//截图方法
- (UIImage *)subImageWithRect:(CGRect)rect
{
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

//压缩图片
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect]; // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

//UIView转化为UIImage
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  改变前景颜色
 *
 *  @param tintColor 要改变的前景颜色
 *
 *  @return 改变前景色后的图片
 */
- (UIImage *)changeTintColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    UIRectFill(bounds);

    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
/**
 *  改变前景图案
 *
 *  @param image 要改变的前景图案
 *
 *  @return 改变完成后的图片
 */
- (UIImage *)changeGraph:(UIImage *)image
{

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    [image drawInRect:bounds];
    
    //    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *graphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return graphImage;
}
/**
 *  转变shape的显示模式
 *
 *  @param image 当前图片的背景图
 *
 *  @return 改变模式后的图片
 */
- (UIImage *)turnShapeWithImage:(UIImage *)image
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320), NO, 0.0f);
    CGRect bounds = CGRectMake(0, 0, 320, 320);
    [image drawInRect:bounds];
    
    //    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationOut alpha:1.0f];
    
    UIImage *graphImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return graphImage;
}

/**
 *  根据不同的混合模式合成形状图形
 *
 *  @param _bottomImage 合成所选底图
 *  @param _topImage    合成所选顶图
 *  @param blendMode    混合方式
 *
 *  @return 合成完成后图片
 */
+ (UIImage *)shapeMakeWithBottomImage:(UIImage *)_bottomImage andTopImage:(UIImage *)_topImage andBlendMode:(CGBlendMode)blendMode
{
    
    UIImage *bottomImage = _bottomImage;
    UIImage *topImage = _topImage;
    
    CGSize newSize =CGSizeMake(1080, 1080);
    
    UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Apply supplied opacity
    [topImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:blendMode alpha:1];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    CGImageRelease(_topImage.CGImage);
//    CGImageRelease(_bottomImage.CGImage);
    
    return newImage;
}


/**
 *  为保证图片质量保存时重绘的图片
 *
 *  @param backView 屏幕显示的出来的view
 *  @param size     保存图片大小
 *
 *  @return 制做完成的图片
 */
+ (UIImage *)getEditFinishedImageWithView:(UIView *)backView andContextSize:(CGSize)size
{

    CGSize newSize = size;
    UIGraphicsBeginImageContext( newSize );
    // Use existing opacity as is
    [backView drawViewHierarchyInRect:CGRectMake(0, 0, newSize.width, newSize.height) afterScreenUpdates:YES];

    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)addwaterMarkOrnotWithImage:(UIImage *)image
{
    CGSize size = CGSizeMake(1080, 1080);
    
    UIGraphicsBeginImageContext(size);
    
    PHO_AppDelegate *app = (PHO_AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [image drawInRect:CGRectMake(0, 0, 1080, 1080)];
    [app.bigImage drawInRect:CGRectMake(size.width-CGImageGetWidth(app.bigImage.CGImage), size.height-CGImageGetHeight(app.bigImage.CGImage), CGImageGetWidth(app.bigImage.CGImage)-4, CGImageGetHeight(app.bigImage.CGImage)-4)];
    
    UIImage *newImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


//+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
//{
//    
//    if ((blur < 0.05f) || (blur > 2.0f)) {
//        return image;
//    }
//    
//    //boxSize必须大于0
//    int boxSize = (int)(blur * 50);
//    boxSize -= (boxSize % 2) + 1;
//    NSLog(@"boxSize:%i",boxSize);
//    //图像处理
//    CGImageRef img = image.CGImage;
//    //需要引入#import <Accelerate/Accelerate.h>
//    /*
//     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
//     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
//     */
//    
//    //图像缓存,输入缓存，输出缓存
//    vImage_Buffer inBuffer, outBuffer;
//    vImage_Error error;
//    //像素缓存
//    void *pixelBuffer;
//    
//    //数据源提供者，Defines an opaque type that supplies Quartz with data.
//    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
//    // provider’s data.
//    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
//    
//    //宽，高，字节/行，data
//    inBuffer.width = CGImageGetWidth(img);
//    inBuffer.height = CGImageGetHeight(img);
//    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
//    
//    //像数缓存，字节行*图片高
//    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    
//    outBuffer.data = pixelBuffer;
//    outBuffer.width = CGImageGetWidth(img);
//    outBuffer.height = CGImageGetHeight(img);
//    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    
//    
//    // 第三个中间的缓存区,抗锯齿的效果
//    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    vImage_Buffer outBuffer2;
//    outBuffer2.data = pixelBuffer2;
//    outBuffer2.width = CGImageGetWidth(img);
//    outBuffer2.height = CGImageGetHeight(img);
//    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
//    
//    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    //    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    //    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    //
//    
//    if (error) {
//        NSLog(@"error from convolution %ld", error);
//    }
//    
//    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
//    //颜色空间DeviceRGB
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
//    CGContextRef ctx = CGBitmapContextCreate(
//                                             outBuffer.data,
//                                             outBuffer.width,
//                                             outBuffer.height,
//                                             8,
//                                             outBuffer.rowBytes,
//                                             colorSpace,
//                                             CGImageGetBitmapInfo(image.CGImage));
//    
//    //根据上下文，处理过的图片，重新组件
//    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
//    
//    //clean up
//    CGContextRelease(ctx);
//    //    CGColorSpaceRelease(colorSpace);
//    
//    free(pixelBuffer);
//    free(pixelBuffer2);
//    CFRelease(inBitmapData);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(imageRef);
//    
//    return returnImage;
//}

////加模糊效果，image是图片，blur是模糊度
//+ (UIImage *)blurryBottomImage:(UIImage *)bottomImage andTopImage:(UIImage *)topImage withBlurLevel:(CGFloat)blur
//{
//    
//    //模糊度,
//    if ((blur < 0.05f) || (blur > 2.0f)) {
//        blur = 0.05f;
//    }
//    
//    //boxSize必须大于0
//    int boxSize = (int)(blur * 50);
//    boxSize -= (boxSize % 2) + 1;
//    NSLog(@"boxSize:%i",boxSize);
//    //图像处理
//    CGImageRef img = bottomImage.CGImage;
//    //需要引入#import <Accelerate/Accelerate.h>
//    /*
//     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
//     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
//     */
//    
//    //图像缓存,输入缓存，输出缓存
//    vImage_Buffer inBuffer, outBuffer;
//    vImage_Error error;
//    //像素缓存
//    void *pixelBuffer;
//    
//    //数据源提供者，Defines an opaque type that supplies Quartz with data.
//    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
//    // provider’s data.
//    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
//    
//    //宽，高，字节/行，data
//    inBuffer.width = CGImageGetWidth(img);
//    inBuffer.height = CGImageGetHeight(img);
//    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
//    
//    //像数缓存，字节行*图片高
//    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    
//    outBuffer.data = pixelBuffer;
//    outBuffer.width = CGImageGetWidth(img);
//    outBuffer.height = CGImageGetHeight(img);
//    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
//    
//    
//    // 第三个中间的缓存区,抗锯齿的效果
//    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
//    vImage_Buffer outBuffer2;
//    outBuffer2.data = pixelBuffer2;
//    outBuffer2.width = CGImageGetWidth(img);
//    outBuffer2.height = CGImageGetHeight(img);
//    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
//    
//    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
//    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    //    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    //    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
//    //
//    
//    if (error) {
//        NSLog(@"error from convolution %ld", error);
//    }
//    
//    //    NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
//    //颜色空间DeviceRGB
////    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
////    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
////    CGContextRef ctx = CGBitmapContextCreate(
////                                             outBuffer.data,
////                                             outBuffer.width,
////                                             outBuffer.height,
////                                             8,
////                                             outBuffer.rowBytes,
////                                             colorSpace,
////                                             CGImageGetBitmapInfo(bottomImage.CGImage));
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
//                                             outBuffer.width,
//                                             outBuffer.height,
//                                             8,
//                                             outBuffer.rowBytes,
//                                             colorSpace,
//                                             CGImageGetBitmapInfo(bottomImage.CGImage));
//    
//    //根据上下文，处理过的图片，重新组件
//    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
//    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
//    
//    //clean up
//    CGContextRelease(ctx);
//    //    CGColorSpaceRelease(colorSpace);
//    
//    free(pixelBuffer);
//    free(pixelBuffer2);
//    CFRelease(inBitmapData);
//    
//    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(imageRef);
//    
//    
//    
//    return returnImage;
//    
//}


@end
