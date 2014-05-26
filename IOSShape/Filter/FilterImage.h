//
//  FilterImage.h
//  FilterTest
//
//  Created by rcplatform on 24/4/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterImage : UIImage


@property (nonatomic, assign) void *pBitMapData;

+ (instancetype)filterImageWithImage:(UIImage *)image BitMapData:(void *)bitMapData;

@end
