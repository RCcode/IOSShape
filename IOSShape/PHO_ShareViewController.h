//
//  PHO_ShareViewController.h
//  IOSShape
//
//  Created by wsq-wlq on 14-5-22.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLComposeViewController;

@interface PHO_ShareViewController : UIViewController<UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>
{
    UIDocumentInteractionController *_documetnInteractionController;
    UIImage *theBestImage;
    SLComposeViewController *slComposerSheet;
    BOOL isSaved;
}

@property (nonatomic) BOOL isSaved;
- (id)initWithImage:(UIImage *)image;

@end
