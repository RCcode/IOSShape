//
//  PHO_HomeViewController.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_HomeViewController.h"

#import "PHO_MainViewController.h"

#import "PHO_AboutUsViewController.h"

#import "GADBannerView.h"
#import "GADRequest.h"
#import <AdSupport/AdSupport.h>

#import "MBProgressHUD+Add.h"

#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

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
    [infoButton setFrame:CGRectMake(274, TOPORIGIN_Y + 12, 40, 40)];
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"InfoButtonImage.png"] forState:UIControlStateNormal];
    [self.view addSubview:infoButton];
    
    UIImageView *nameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 157, 52)];
    nameImageView.image = [UIImage imageNamed:@"Shape.png"];
    nameImageView.center = CGPointMake(self.view.center.x, 170);
    [self.view addSubview:nameImageView];
//

    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectZero];
    if (iPhone5)
    {
        buttonView.frame = CGRectMake(0, kScreen_Height-217, 320, 140);
    }
    else
    {
        buttonView.frame = CGRectMake(0, kScreen_Height-190, 320, 140);
        nameImageView.center = CGPointMake(self.view.center.x, 150);
    }
    buttonView.backgroundColor = colorWithHexString(@"#ffffff");
//    buttonView.layer.borderColor = colorWithHexString(@"dcdcdc").CGColor;
//    buttonView.layer.borderWidth = 1;
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
    if (aboutUs == nil)
    {
        aboutUs = [[PHO_AboutUsViewController alloc]init];
    }
    UINavigationController *aboutNav = [[UINavigationController alloc]initWithRootViewController:aboutUs];
    [aboutNav.navigationBar setBarTintColor:colorWithHexString(@"#fe8c3f")];
    [self presentViewController:aboutNav animated:YES completion:nil];
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
        [self sendMessage:@"home_gallery" and:@"Home"];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES
                         completion:^{//设置overlayview
                         }];
        
    }
    else if (tag == 101)
    {
        //打开相机
        [self sendMessage:@"home_camera" and:@"Home"];
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
//    NSLog(@"cameraPic.imageOrientation == %ld",cameraPic.imageOrientation);
    
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
    [self sendMessage:@"home_NoCrop" and:@"Home"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"rcApp://com.rcplatform.IOSNoCrop"]];
    if (!canOpen)
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"noCrop下载地址"]];
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"rcApp://com.rcplatform.IOSNoCrop"]];
    }
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
