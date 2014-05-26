//
//  FilterImage.m
//  FilterTest
//
//  Created by rcplatform on 24/4/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FilterImage.h"

@implementation FilterImage

+ (instancetype)filterImageWithImage:(UIImage *)image BitMapData:(void *)bitMapData{

    FilterImage *instance = [[FilterImage alloc] initWithCGImage:image.CGImage];
    instance.pBitMapData = bitMapData;
    return instance;
}

- (void)dealloc{
    //被释放的同时，也释放这个地址
    if(_pBitMapData != NULL){
        free(_pBitMapData);
        _pBitMapData = NULL;
//        NSLog(@"free");
    }
}

@end
