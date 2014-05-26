//
//  PHO_MainShowView.h
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHO_MainShowView : UIView
{
    UIImageView *showImageView;
    CGFloat beginangel;
    CGFloat beginDistance;
    CGPoint pointnow;
}

@property (strong, nonatomic) UIImageView *showImageView;

- (void)getPicture:(UIImage *)picture;
@end
