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
#import "GADBannerViewDelegate.h"

@class GADBannerView;
@class GADRequest;
@class PHO_HomeViewController;

@interface PHO_AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,GADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *rootNav;
@property (strong, nonatomic) PHO_HomeViewController *homeViewController;


@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (nonatomic, copy) NSString *UpdateUrlStr;

@property (nonatomic, strong) NSString *trackURL;//apple的iTunes地址

@property (strong, nonatomic) GADBannerView *adBanner;

@property (nonatomic ,strong) NSMutableArray *appsArray;
@property (nonatomic ,assign) BOOL isOn;//水印开关
@property (nonatomic ,strong) UIImage *bigImage;//水印图

- (void)checkVersion;

@end
