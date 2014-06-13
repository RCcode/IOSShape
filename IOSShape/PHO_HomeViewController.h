//
//  PHO_HomeViewController.h
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>



@class PHO_AboutUsViewController;

@interface PHO_HomeViewController : UIViewController<UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *chooseImage;
    UIView *moreView;
    PHO_AboutUsViewController *aboutUs;
}


@end
