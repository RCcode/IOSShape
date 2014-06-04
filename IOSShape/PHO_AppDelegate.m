//
//  PHO_AppDelegate.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "PHO_AppDelegate.h"

#import "PHO_HomeViewController.h"


@implementation PHO_AppDelegate

@synthesize homeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    homeViewController = [[PHO_HomeViewController alloc]init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    [rootNav.navigationBar setBarTintColor:colorWithHexString(@"#fe8c3f")];
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    
    /** 友盟相关设置 **/
    
    //打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setLogEnabled:YES];
    [MobClick startWithAppkey:UmengAPPKey reportPolicy:SEND_ON_EXIT   channelId:@"App Store"];
    //在线参数配置
    [MobClick updateOnlineConfig];
    
    
    
    /** google analytics **/
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
//    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    // Create tracker instance.
    _tracker = [[GAI sharedInstance] trackerWithTrackingId:GAAPPKey];
    
    
    /** flurry相关设置 **/
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [Flurry startSession:@"YOUR_API_KEY"];
    //调试日志
    [Flurry setLogLevel:FlurryLogLevelDebug];
    //程序退出时上传数据
    [Flurry setSessionReportsOnCloseEnabled:NO];
    [Flurry setSessionReportsOnPauseEnabled:YES];
    
    
    return YES;
}

#pragma mark flurry 推荐设置添加一个未捕获的异常监听器
void uncaughtExceptionHandler(NSException *exception)
{
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark 注册通知

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSRange range = NSMakeRange(1,[[deviceToken description] length]-2);
    NSString *deviceTokenStr = [[deviceToken description] substringWithRange:range];
    NSLog(@"deviceTokenStr==%@",deviceTokenStr);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Fail to Register For Remote Notificaions With Error :error = %@",error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo = %@",userInfo);
    
    //    NSDictionary *dictionary = [userInfo objectForKey:@"aps"];
    //    NSString *alert = [dictionary objectForKey:@"alert"];
    //    NSString *type = [userInfo objectForKey:@"type"];
    //    NSString *urlStr = [userInfo objectForKey:@"url"];
    //    switch (type.intValue) {
    //        case 0:
    //        {
    //            // Ads
    //            [self OpenUrl:urlStr];
    //        }
    //            break;
    //        case 1:
    //        {
    //            //Update
    //            self.UpdateUrlStr = urlStr;
    //            [[[UIAlertView alloc] initWithTitle:@"通知" message: alert delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前去升级", nil] show];
    //        }
    //            break;
    //        case 2:
    //            //Font
    //            break;
    //        case 3:
    //            //Tags
    //            break;
    //        case 4:
    //            //Filter
    //            break;
    //        default:
    //            break;
    //    }
    [self cancelNotification];
}

- (void)registNotification{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)cancelNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)OpenUrl:(NSString *)urlString{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
