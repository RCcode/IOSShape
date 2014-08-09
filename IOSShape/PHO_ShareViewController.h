//
//  PHO_ShareViewController.h
//  IOSShape
//
//  Created by wsq-wlq on 14-5-22.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLComposeViewController;

@interface PHO_ShareViewController : UIViewController<UIDocumentInteractionControllerDelegate, UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIDocumentInteractionController *_documetnInteractionController;
    UIImage *theBestImage;
    UIImage *saveImage;
    SLComposeViewController *slComposerSheet;
    BOOL isSaved;
    BOOL isSwitchPressed;
    
    UITableView *appMoretableView;
}

@property (nonatomic) BOOL isSaved;
- (void)getImage:(UIImage *)image;

@end
