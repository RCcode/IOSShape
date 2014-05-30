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
@class PHO_ShareViewController;

@interface PHO_MainViewController : UIViewController<UIAlertViewDelegate>
{
    UIView *backView;
    PHO_MainShowView *showView;
    
    UIImageView *shapeImage;
    UIImageView *topImage;
    UIImageView *bottomImage;
    UIImage *backRealImage;
    UIImage *filterMaxImage;
    UIImage *filterMinImage;
    UIImageView *shapeSelectedView;
    UIImageView *backGroundSelectedView;
    UIImageView *filterSelectedView;
    
    UIView *tabbarView;
    
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
    
    UIScrollView *shapeChooseScrollView;
    UIScrollView *colorChooseScrollView;
    UIScrollView *graphChooseScrollView;
    UISlider *blurSlider;
    UIView *alphaSliderView;
    UILabel *valuePercentLabel;
    UISlider *alphaSlider;
    
    NSString *shapeGroupName;
    NSString *shapeSelectedGroup;
    
    NSString *uMengEditType;
    
    PHO_ShareViewController *shareContrller;
}

-(id)initWithImage:(UIImage *)image;

@end
