//
//  PHO_MainShowView.h
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHO_MainShowView : UIView<UIGestureRecognizerDelegate>
{
    UIImageView *showImageView;
    CGFloat beginangel;
    CGFloat beginDistance;
    CGPoint pointnow;
    
    float _firstX;
    float _firstY;
    //标记变量（解决旋转、翻转等效果叠加时出的问题）
    BOOL _mirFlag;
    BOOL _rotFlag;
    
    CGFloat lastScale;
    CGFloat _lastRotation;
}

@property (strong, nonatomic) UIImageView *showImageView;

- (void)getPicture:(UIImage *)picture;
@end
