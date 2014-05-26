//
//  PHO_MainViewController.h
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _whichTypeUsed
{
    shapeUsed = 1,
    colorUsed = 2,
    graphUsed = 3,
    blurUsed = 4,
    alphaUsed = 5
}whichTypeUsed;


@class PHO_MainShowView;

@interface PHO_MainViewController : UIViewController
{
    UIView *backView;
    PHO_MainShowView *showView;
    
    UIImageView *shapeImage;
    UIImageView *topImage;
    UIImageView *bottomImage;
    UIImage *backRealImage;
    
    NSMutableArray *shapeMulArray;
    NSMutableArray *colorMulArray;
    NSMutableArray *graphMulArray;
    NSMutableArray *filterMulArray;
    
    whichTypeUsed typeUsedStatus;
    
    //选择图形底层View
    UIView *shapeChooseView;
    //选择背景底层View
    UIView *backGroundChooseView;
    //选择滤镜底层view
    UIView *filterChooseView;
    
    UIView *showChooseView;
    
    UIScrollView *colorChooseScrollView;
    UIScrollView *graphChooseScrollView;
    UISlider *blurSlider;
    UISlider *alphaSlider;
}

-(id)initWithImage:(UIImage *)image;

@end
