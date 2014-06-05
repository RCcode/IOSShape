//
//  PHO_AppDelegate.h
//  IOSShape
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "AFHTTPRequestOperationManager.h"
#import "PRJ_ProtocolClass.h"


@class PHO_HomeViewController;

@interface PHO_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PHO_HomeViewController *homeViewController;

@property(nonatomic, strong) id<GAITracker> tracker;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (nonatomic, copy) NSString *UpdateUrlStr;
@property (nonatomic, strong) NSString *trackURL;//apple的iTunes地址

@end
