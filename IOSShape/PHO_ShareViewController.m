//
//  PHO_ShareViewController.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-22.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_ShareViewController.h"

#import "MBProgressHUD+Add.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"


#define kTheBestImagePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shareImage.igo"]
#define kToMorePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"shareImage.jpg"]


@interface PHO_ShareViewController ()
@end

@implementation PHO_ShareViewController
@synthesize isSaved;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = LocalizedString(@"shareView_share", @"");
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
        self.navigationItem.titleView = titleLabel;
        
        // Custom initialization
    }
    return self;
}

- (void)getImage:(UIImage *)image
{
    theBestImage = image;
    isSaved = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航
//    UIView *customNavgationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y, 320, 44)];
//    NSLog(@"%d",TOPORIGIN_Y);
//    customNavgationView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:customNavgationView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 10, 12, 20)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *popToHomeViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popToHomeViewButton setFrame:CGRectMake(280, 10, 20, 20)];
    [popToHomeViewButton addTarget:self action:@selector(popToHomeViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [popToHomeViewButton setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:popToHomeViewButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSArray *shareToArray = [NSArray arrayWithObjects:@"相册.png", @"share-to-insta.png", @"fb.png", @"更多.png",nil];
//    NSArray *shareToNameArray = [NSArray arrayWithObjects:@"save", @"instagram", @"faceBook", @"more", nil];
    NSArray *shareToNameArray = @[LocalizedString(@"shareView_save", @""),
                                  @"instagram",@"faceBook",
                                  LocalizedString(@"shareView_more", @"")];
    
    for (int i = 0; i < 4; i ++)
    {
        @autoreleasepool
        {
            UIButton *shareToButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareToButton setBackgroundImage:[UIImage imageNamed:[shareToArray objectAtIndex:i]] forState:UIControlStateNormal];
            shareToButton.frame = CGRectMake(10+25*i+56*i, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 20, 56, 56);
            shareToButton.tag = i + 10;
            [shareToButton setTitle:[shareToNameArray objectAtIndex:i] forState:UIControlStateNormal];
            [shareToButton setTitleColor:colorWithHexString(@"#7e7e7e") forState:UIControlStateNormal];
            [shareToButton setTitleEdgeInsets:UIEdgeInsetsMake(80, 0, 0, 0)];
            shareToButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            shareToButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            [shareToButton addTarget:self action:@selector(shareToButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shareToButton];
        }
    }
    
//    UILabel *shareToLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height+116, 60, 44)];
//    shareToLabel.text = @"";
//    shareToLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
//    [self.view addSubview:shareToLabel];
    
    // Do any additional setup after loading the view.
}

#pragma mark 导航按扭方法

//返回上一层
- (void)backButtonPressed:(id)sender
{
    if (isSaved)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"backTipMessage", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipCancel", @"") otherButtonTitles:LocalizedString(@"backTipConfirm", @""), nil];
        alert.tag = 100;
        [alert show];
    }
}

//返回到主页
- (void)popToHomeViewButtonPressed:(id)sender
{
    if (isSaved)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"backTipMessage", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipCancel", @"") otherButtonTitles:LocalizedString(@"backTipConfirm", @""), nil];
        alert.tag = 100;
        [alert show];
    }
    
}

#pragma mark 分享按扭方法

- (void)shareToButtonPressed:(id)sender
{
    
    UIButton *tempButton = (UIButton *)sender;
    NSInteger tag = tempButton.tag - 10;
    switch (tag)
    {
        case 0:
            //保存到相册
            {
                if (isSaved)
                {
                    [MBProgressHUD showSuccess:LocalizedString(@"shareView_saveSuccess", @"")
                                        toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                else
                {
                    [self sendMessage:@"share_save" and:@"Share"];
                    UIImageWriteToSavedPhotosAlbum(theBestImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                }
                
            }
            break;
        case 1:
            //分享到instagram
            {
                [self sendMessage:@"share_instagram" and:@"Share"];
                if([[NSFileManager defaultManager] fileExistsAtPath:kTheBestImagePath]){
                    [[NSFileManager defaultManager] removeItemAtPath:kTheBestImagePath error:nil];
                }
                
                NSData *imageData = UIImageJPEGRepresentation(theBestImage, 0.8);
                [imageData writeToFile:kTheBestImagePath atomically:YES];
                
                //分享
                NSURL *fileURL = [NSURL fileURLWithPath:kTheBestImagePath];
                _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
                _documetnInteractionController.delegate = self;
                _documetnInteractionController.UTI = @"com.instagram.photo";
                //    _documetnInteractionController.UTI = @"public.png";
                //    _documetnInteractionController.annotation = @{@"InstagramCaption":@"来自NoCrop"};
                BOOL canOpne = [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
                if (canOpne == NO)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"shareView_NoInstagram", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipConfirm", @"") otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            break;
        case 2:
            //分享到faceBook
            {
                if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
                {
                    slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//                    [slComposerSheet setInitialText:self.sharingText];
                    if([[NSFileManager defaultManager] fileExistsAtPath:kTheBestImagePath]){
                        [[NSFileManager defaultManager] removeItemAtPath:kTheBestImagePath error:nil];
                    }
                    
                    NSData *imageData = UIImageJPEGRepresentation(theBestImage, 0.8);
                    [imageData writeToFile:kTheBestImagePath atomically:YES];
                    UIImage *image = [UIImage imageWithContentsOfFile:kTheBestImagePath];
                    
                    [slComposerSheet addImage:image];
                    [slComposerSheet addURL:[NSURL URLWithString:@"http://www.facebook.com/"]];
                    [self presentViewController:slComposerSheet animated:YES completion:nil];
                }
                else
                {
                    [MBProgressHUD showError:LocalizedString(@"shareView_shareFaile", @"")
                                        toView:[UIApplication sharedApplication].keyWindow];
                    return;
                }
                __block PHO_ShareViewController *controller = self;
                __block UIImage *blockImage = theBestImage;
                [slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result)
                {
                    
                    NSLog(@"start completion block");
                    NSString *output;
                    switch (result) {
                        case SLComposeViewControllerResultCancelled:
                            output = @"Action Cancelled";
                            break;
                        case SLComposeViewControllerResultDone:
                            
                            output = @"Post Successfull";
                            break;
                        default:
                            break;
                    }
                    if (result != SLComposeViewControllerResultCancelled)
                    {
                        [MBProgressHUD showSuccess:LocalizedString(@"shareView_shareSuccess", @"")
                                            toView:[UIApplication sharedApplication].keyWindow];
                        [controller isPopTipToRateus];
                        UIImageWriteToSavedPhotosAlbum(blockImage, controller, nil, nil);
                    }
                }];

            }
            break;
        case 3:
            //更多
            {
                [self sendMessage:@"share_more" and:@"Share"];
                //保存本地 如果已存在，则删除
                if([[NSFileManager defaultManager] fileExistsAtPath:kToMorePath]){
                    [[NSFileManager defaultManager] removeItemAtPath:kToMorePath error:nil];
                }
                
                NSData *imageData = UIImageJPEGRepresentation(theBestImage, 0.8);
                [imageData writeToFile:kToMorePath atomically:YES];
                
                NSURL *fileURL = [NSURL fileURLWithPath:kToMorePath];
                _documetnInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
                _documetnInteractionController.delegate = self;
                _documetnInteractionController.UTI = @"com.instagram.photo";
//                _documetnInteractionController.annotation = @{@"InstagramCaption":@"来自NoCrop"};
                [_documetnInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark 保存至本地相册 结果反馈
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil)
    {
        [MBProgressHUD showSuccess:LocalizedString(@"shareView_saveSuccess", @"")
                            toView:[UIApplication sharedApplication].keyWindow];
        [self performSelector:@selector(isPopTipToRateus) withObject:nil afterDelay:1];
//        [self isPopTipToRateus];
        
    }
    else
    {
        [MBProgressHUD showError:LocalizedString(@"shareView_saveFaile", @"")
                          toView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark 获得是否弹出提示评价

- (void)isPopTipToRateus
{
    NSMutableDictionary *rateusDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:editCountPath];
    NSLog(@"%@",editCountPath);
    if (rateusDictionary)
    {
        NSLog(@"%@",rateusDictionary);
        if ([[rateusDictionary objectForKey:@"status"] isEqualToString:@"rateusNoMore"] ||
            [[rateusDictionary objectForKey:@"status"] isEqualToString:@"rateusted"])
        {
            self.isSaved = YES;
            return;
        }
        else if ([[rateusDictionary objectForKey:@"status"] isEqualToString:@"rateusLater"])
        {
            if ([[rateusDictionary objectForKey:@"count"] intValue] >= 3 && [[rateusDictionary objectForKey:@"count"] intValue]%2 != 0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"shareView_rateMessage", @"") delegate:self cancelButtonTitle:LocalizedString(@"shareView_remaindLater", @"") otherButtonTitles:LocalizedString(@"shareView_NoMoreTip", @""), LocalizedString(@"shareView_rateNow", @""), nil];
                [alert show];
            }
            
        }
        NSString *countString = [rateusDictionary objectForKey:@"count"];
        countString = [NSString stringWithFormat:@"%d",countString.intValue + 1];
        [rateusDictionary setObject:countString forKey:@"count"];
        [rateusDictionary writeToFile:editCountPath atomically:YES];
    }
    else
    {
        rateusDictionary = [[NSMutableDictionary alloc]init];
        [rateusDictionary setObject:@"1" forKey:@"count"];
        [rateusDictionary setObject:@"rateusLater" forKey:@"status"];
        [rateusDictionary writeToFile:editCountPath atomically:YES];
    }
    
    self.isSaved = YES;
}

- (void)shareIsPopTipToRateus
{
//    [MBProgressHUD showSuccess:LocalizedString(@"shareView_shareSuccess", @"")
//                        toView:[UIApplication sharedApplication].keyWindow];
    UIImageWriteToSavedPhotosAlbum(theBestImage, self, nil, nil);
    [self performSelector:@selector(isPopTipToRateus) withObject:nil afterDelay:1];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else if (buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        NSMutableDictionary *rateusDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:editCountPath];
        if (rateusDictionary)
        {
            if (buttonIndex == 0)
            {
                [rateusDictionary setObject:@"rateusLater" forKey:@"status"];
            }
            else if (buttonIndex == 1)
            {
                [rateusDictionary setObject:@"rateusNoMore" forKey:@"status"];
                
            }
            else if (buttonIndex == 2)
            {
                [rateusDictionary setObject:@"rateusted" forKey:@"status"];
                
                [self sendMessage:@"home_menu_rateus" and:@"Home"];
                
                NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
            }
        }
        [rateusDictionary writeToFile:editCountPath atomically:YES];
    }
    
    
    
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareIsPopTipToRateus) name:KShareSuccess object:nil];
}

#pragma mark 发送统计

- (void)sendMessage:(NSString *)event and:(NSString *)label
{
    //友盟统计
    [MobClick event:event label:nil];
    
    //GoogleAnalytics
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:event
                                                           value:nil] build]];
    //flurryAnalytics
    [Flurry logEvent:event];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
