//
//  PHO_HomeViewController.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_HomeViewController.h"

#import "PHO_MainViewController.h"

#import "GADBannerView.h"
#import "GADRequest.h"
#import <AdSupport/AdSupport.h>

#import "MBProgressHUD+Add.h"

@interface PHO_HomeViewController ()

@end

@implementation PHO_HomeViewController

@synthesize adBanner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
        // Custom initialization
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGPoint origin = CGPointMake(0.0,
                                 self.view.frame.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:origin];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = AdmobAPPKey;
    self.adBanner.delegate = self;
    self.adBanner.backgroundColor = [UIColor blackColor];
    self.adBanner.rootViewController = self.navigationController;
    [self.navigationController.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[self request]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:pngImagePath(@"wallbase")];
    
//    UIView *customNavgationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y, 320, 44)];
//    NSLog(@"%d",TOPORIGIN_Y);
//    customNavgationView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:customNavgationView];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [infoButton setFrame:CGRectMake(280, TOPORIGIN_Y + 12, 20, 20)];
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [self.view addSubview:infoButton];
//
    //应用程序选项
    moreView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-140, self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y, 140, 200)];
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.hidden = YES;
    [self.view addSubview:moreView];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"更新", @"评分", @"反馈", @"分享", @"关注我们", nil];
    
    for (int i = 0; i < 5 ; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        [button setFrame:CGRectMake(0, 40*i, moreView.frame.size.width, 40)];
        [button addTarget:self action:@selector(moreSubButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+10;
        [button setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [moreView addSubview:button];
    }
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(-1, 351, 322, 140)];
    buttonView.backgroundColor = colorWithHexString(@"#ffffff");
    buttonView.layer.borderColor = colorWithHexString(@"dcdcdc").CGColor;
    buttonView.layer.borderWidth = 1;
    buttonView.alpha = 0.8;
    [self.view addSubview:buttonView];
    
    UIButton *openlibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    [openlibrary setBackgroundImage:[UIImage imageNamed:@"gallery.png"] forState:UIControlStateNormal];
    [openlibrary setFrame:CGRectMake(49, 0, 65, 65)];
    openlibrary.center = CGPointMake(openlibrary.frame.origin.x, buttonView.center.y);
    openlibrary.tag = 100;
    [openlibrary addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openlibrary];
    
    UIButton *openCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [openCamera setBackgroundImage:[UIImage imageNamed:@"Camera.png"] forState:UIControlStateNormal];
    [openCamera setFrame:CGRectMake(160, 160, 65, 65)];
    openCamera.center = CGPointMake(openCamera.frame.origin.x, buttonView.center.y);
    openCamera.tag = 101;
    [openCamera addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openCamera];
    
    UIButton *openNoCropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openNoCropButton setBackgroundImage:[UIImage imageNamed:@"Nocrop.png"] forState:UIControlStateNormal];
    [openNoCropButton setFrame:CGRectMake(271, 220, 65, 65)];
    openNoCropButton.center = CGPointMake(openNoCropButton.frame.origin.x, buttonView.center.y);
    [openNoCropButton addTarget:self action:@selector(openNoCropButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openNoCropButton];
    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.allowsEditing = NO;
    //    imagePicker.showsCameraControls = NO;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    //    [self setOverLayView];
    //    imagePicker.cameraOverlayView = takePictureView;
    
    // Do any additional setup after loading the view.
}

#pragma mark GADRequest generation

- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
      request.testDevices = @[
    //    // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
    //    // the console when the app is launched.
    ////    GAD_SIMULATOR_ID,
        [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    return request;
}

#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}


#pragma 弹出菜单按扭方法

- (void)infoButtonPressed:(id)sender
{
    if (moreView.hidden)
    {
        moreView.hidden = NO;
    }
    else
    {
        moreView.hidden = YES;
    }
}

- (void)moreSubButtonPressed:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    NSInteger tag = tempButton.tag;
    
    switch (tag)
    {
        case 10:
            ;//更新
            [self GetUpdate];
            break;
        case 11:
            ;//评分
        {
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"appid"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
            break;
        case 12:
        {
            //直接发邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate =self;
            NSString *subject = [NSString stringWithFormat:@"shape %@ (iOS)", NSLocalizedString(@"feedback", nil)];
            [picker setSubject:subject];
//            [picker setToRecipients:@[kFeedbackEmail]];
            [picker setToRecipients:@[@"wangshaoqi@rcplatformhk.com"]];
            [self presentViewController:picker animated:YES completion:nil];
        }
            

            break;
        case 13:
            ;//分享
        {
//            NSString *shareContent = NSLocalizedString(@"share_msg", nil);
            NSString *shareContent = [NSString stringWithFormat:@"www.baidu.com"];
            NSArray *activityItems = @[shareContent];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            __weak UIActivityViewController *blockActivityVC = activityVC;
            
            activityVC.completionHandler = ^(NSString *activityType,BOOL completed){
            if(completed)
            {
                [MBProgressHUD showMessage:@"分享成功" toView:[UIApplication sharedApplication].keyWindow];
            }
               [blockActivityVC dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:activityVC animated:YES completion:nil];
        }
            
            break;
        case 14:
            ;//关注我们
            break;
            
        default:
            break;
    }
}

- (void)GetUpdate
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=668498872"];
    NSString * file =  [NSString stringWithContentsOfURL:url];
    //    NSLog(file);
    //"version":"1.0"
    NSRange substr = [file rangeOfString:@"\"version\":\""];
    NSRange substr2 =[file rangeOfString:@"\"" options: Nil range: NSMakeRange(substr.location+substr.length, 10)];
    NSRange range = {substr.location+substr.length,substr2.location-substr.location-substr.length};
    NSString *newVersion =[file substringWithRange:range];
    if([nowVersion isEqualToString:newVersion]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"版本有更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
        alert.tag = 123;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 122;
        [alert show];
    }
    
}



/**********************************************************
 函数名称：-(void)choosePhoto:(id)sender
 函数描述：打开相册或相机
 输入参数：(id)sender：用户点击事件
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)choosePhoto:(id)sender
{
    UIButton *tembtn = (UIButton *)sender;
    NSInteger tag = tembtn.tag;
    if (tag == 100)
    {
        //打开相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES
                         completion:^{//设置overlayview
                         }];
        
    }
    else if (tag == 101)
    {
        //打开相机
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES
                         completion:^{//设置overlayview
                         }];
    }
    
}
/**********************************************************
 函数名称：-(void)imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info
 函数描述：获得用户使用相机或相册所选中的照片
 输入参数：(UIImagePickerController *)picker：相机，相册控制器
 (NSDictoinary *)info:用户所选相片数据信息
 输出参数：(UIImage *)img :用户所选图片
 返回值：  无
 **********************************************************/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    
    UIImage *cameraPic = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"cameraPic.imageOrientation == %d",cameraPic.imageOrientation);
    
    if (cameraPic.imageOrientation != UIImageOrientationUp)
    {
        
        int mi = cameraPic.imageOrientation;
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (mi)
        {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.width, cameraPic.size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, cameraPic.size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
        }
        
        switch (mi)
        {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, cameraPic.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        CGContextRef ctx = CGBitmapContextCreate(NULL, cameraPic.size.width, cameraPic.size.height,
                                                 CGImageGetBitsPerComponent(cameraPic.CGImage), 0,
                                                 CGImageGetColorSpace(cameraPic.CGImage),
                                                 CGImageGetBitmapInfo(cameraPic.CGImage));
        CGContextConcatCTM(ctx, transform);
        switch (mi)
        {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,cameraPic.size.height,cameraPic.size.width), cameraPic.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,cameraPic.size.width,cameraPic.size.height), cameraPic.CGImage);
                break;
        }
        
        // And now we just create a new UIImage from the drawing context
        CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
        chooseImage = [UIImage imageWithCGImage:cgimg];
        CGContextRelease(ctx);
        CGImageRelease(cgimg);
    }
    
    if (chooseImage)
    {
        PHO_MainViewController *mainViewController = [[PHO_MainViewController alloc]initWithImage:chooseImage];
        [self.navigationController pushViewController:mainViewController animated:YES];
    }
    
    [self performSelector:@selector(dismissPicker) withObject:self afterDelay:0.3f];
    
}

/**********************************************************
 函数名称：-(void)dismissPicker
 函数描述：退出相册或相机
 输入参数：无
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)dismissPicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openNoCropButtonPressed:(id)sender
{
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"noCropurl"]];
    if (!canOpen)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"noCrop下载地址"]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    adBanner.delegate = nil;
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
