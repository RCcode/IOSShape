//
//  PHO_AppDelegate.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "PHO_AppDelegate.h"

#import "PHO_HomeViewController.h"

#import "UIDevice+DeviceInfo.h"

#import "PHO_DataRequest.h"


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
    //注册通知
    [self registNotification];
    //配置afnetworking
    [self netWorkingSeting];
    
    //检查更新
    [self checkVersion];
    
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
    
    [Flurry startSession:FlurryAPPKey];
    //调试日志
//    [Flurry setLogLevel:FlurryLogLevelDebug];
    //程序退出时上传数据
    [Flurry setSessionReportsOnCloseEnabled:YES];
    
    //程序是否为激活状态
    
//    NSLog(@"%@",[[UIDevice currentDevice]model]);
//    NSLog(@"%@",[[UIDevice currentDevice]localizedModel]);
//    NSLog(@"%@",[[UIDevice currentDevice]name]);
//    NSLog(@"%@",[[UIDevice currentDevice]systemName]);
//    NSLog(@"%@",[[UIDevice currentDevice]systemVersion]);
    
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif)
    {
        [self doNotificationActionWithInfo:remoteNotif];
    }
    
    
    
    return YES;
}

#pragma mark -
#pragma mark 配置AFN
- (void)netWorkingSeting
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
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
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];
    if (token == nil || [token isKindOfClass:[NSNull class]] || ![token isEqualToString:deviceTokenStr]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenStr forKey:DEVICE_TOKEN];
        //注册token
        [self postData:[NSString stringWithFormat:@"%@",deviceTokenStr]];
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Fail to Register For Remote Notificaions With Error :error = %@",error.description);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    NSLog(@"userInfo = %@",userInfo);
    [self doNotificationActionWithInfo:userInfo];
    
}

- (void)doNotificationActionWithInfo:(NSDictionary *)dic
{
    NSDictionary *dictionary = [dic objectForKey:@"aps"];
    NSString *alert = [dictionary objectForKey:@"alert"];
    NSString *type = [dic objectForKey:@"type"];
    NSString *urlStr = [dic objectForKey:@"url"];
    switch (type.intValue) {
        case 0:
        {
            // Ads
            //判断程序是否是由通知打开
            self.UpdateUrlStr = urlStr;

            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                               message:alert
                                                              delegate:self
                                                     cancelButtonTitle:LocalizedString(@"backTipCancel", @"")
                                                     otherButtonTitles:LocalizedString(@"backTipConfirm", @""), nil];
            [alertView show];

        }
            break;
        case 1:
        {
            //Update
            self.UpdateUrlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/hei-tian-e/id%@?l=en&mt=8",appleID];
            //            self.UpdateUrlStr = urlStr;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                           message:LocalizedString(@"newVersion", @"")
                                                          delegate:self
                                                 cancelButtonTitle:LocalizedString(@"remindLater", @"")
                                                 otherButtonTitles:LocalizedString(@"updateNow", @""), nil];
            [alert show];
        }
            break;
        case 2:
            //Font
            //            [self OpenUrl:[NSURL URLWithString:urlStr]];
            break;
        case 3:
            //Tags
            //            [self OpenUrl:[NSURL URLWithString:urlStr]];
            break;
        case 4:
            //Filter
            //            [self OpenUrl:[NSURL URLWithString:urlStr]];
            break;
        default:
            break;
    }
    
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

#pragma mark -
#pragma mark 提交设备信息
- (void)postData:(NSString *)token{
    NSDictionary *infoDic = [self deviceInfomation:token];
    
    PHO_DataRequest *request = [[PHO_DataRequest alloc] initWithDelegate:self];
    [request registerToken:infoDic withTag:11];
    
}

#pragma mark -
#pragma mark 获取设备信息
- (NSDictionary *)deviceInfomation:(NSString *)token
{
    //Bundle Id
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //NSString *macAddress = [UIDevice getMacAddressWithUIDevice];
    NSString *systemVersion = [UIDevice currentVersion];
    NSString *model = [UIDevice currentModel];
    NSString *modelVersion = [UIDevice currentModelVersion];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"Z"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [NSDate date];
    //+0800
    NSString *timeZoneZ = [dateFormatter stringFromDate:date];
    NSRange range = NSMakeRange(0, 3);
    //+08
    NSString *timeZoneInt = [timeZoneZ substringWithRange:range];
    
    //en
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    
    //US
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [[[locale localeIdentifier] componentsSeparatedByString:@"_"] lastObject];
    
    /**
     token           Push用token             String		N
     timeZone	 时区（-12--12）        int            N
     language     语言码                        String		N
     bundleid      bundleid                    String		N
     mac             使用唯一标识符 idfv   String		Y
     pagename	 应用包名                    String		N
     model          手机型号                    String		Y
     model_ver	 手机版本                    String		Y
     sysver          系统版本                    String		Y
     country        国家                           String		Y
     **/
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:token forKeyPath:@"token"];
    [params setValue:timeZoneInt forKeyPath:@"timeZone"];
    [params setValue:language forKey:@"language"];
    [params setValue:bundleIdentifier forKeyPath:@"bundleid"];
    [params setValue:idfv forKeyPath:@"mac"];
    [params setValue:bundleIdentifier forKeyPath:@"pagename"];
    [params setValue:model forKeyPath:@"model"];
    [params setValue:modelVersion forKeyPath:@"model_ver"];
    [params setValue:systemVersion forKeyPath:@"sysver"];
    [params setValue:country forKeyPath:@"country"];
    
    return params;
}

#pragma mark -
#pragma mark 版本检测
- (void)checkVersion
{
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleID];
    PHO_DataRequest *request = [[PHO_DataRequest alloc] initWithDelegate:self];
    [request updateVersion:urlStr withTag:10];
}

#pragma mark -
#pragma mark WebRequestDelegate
- (void)didReceivedData:(NSDictionary *)dic withTag:(NSInteger)tag
{
    NSLog(@"dic........%@",dic);
    switch (tag) {
        case 10:
        {
            //解析数据
            NSArray *results = [dic objectForKey:@"results"];
            if ([results count] == 0) {
                return ;
            }
            
            NSDictionary *dictionary = [results objectAtIndex:0];
            NSString *version = [dictionary objectForKey:@"version"];
            NSString *trackViewUrl = [dictionary objectForKey:@"trackViewUrl"];//地址trackViewUrl
            self.trackURL = trackViewUrl;
            //NSString *trackName = [dictionary objectForKey:@"trackName"];//trackName
            
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            
            if ([currentVersion compare:version options:NSNumericSearch] == NSOrderedAscending)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                        message:LocalizedString(@"newVersion", @"")
                                                        delegate:self
                                                    cancelButtonTitle:LocalizedString(@"remindLater", @"")
                                                    otherButtonTitles:LocalizedString(@"updateNow", @""), nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                               message:LocalizedString(@"newVersion", @"")
                                                              delegate:self
                                                     cancelButtonTitle:LocalizedString(@"remindLater", @"")
                                                     otherButtonTitles:LocalizedString(@"updateNow", @""), nil];
                [alert show];
            }
        }
            break;
        case 11:
        {
            
        }
            break;
        default:
            break;
    }
    hideMBProgressHUD();
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self OpenUrl:self.UpdateUrlStr];
    }
}


- (void)requestFailed:(NSInteger)tag
{
    
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
    [[NSNotificationCenter defaultCenter]postNotificationName:KShareSuccess object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
