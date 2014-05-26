//
//  PHO_ShareViewController.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-22.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_ShareViewController.h"

#import "MBProgressHUD+Add.h"

#define kTheBestImagePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"theBestImage.igo"]

@interface PHO_ShareViewController ()<UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *_documetnInteractionController;
}
@end

@implementation PHO_ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        theBestImage = image;
        // Custom initialization
    }
    return self;
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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:CGRectMake(10, 10, 20, 20)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *popToHomeViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popToHomeViewButton setFrame:CGRectMake(280, 10, 20, 20)];
    [popToHomeViewButton addTarget:self action:@selector(popToHomeViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [popToHomeViewButton setTitle:@"分享" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:popToHomeViewButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //分享到instagram按扭
    UIButton *shareInstagramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareInstagramButton setFrame:CGRectMake(10, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 10, 120, 120)];
    shareInstagramButton.layer.borderColor = [UIColor grayColor].CGColor;
    shareInstagramButton.layer.borderWidth = 1;
    [shareInstagramButton setTitle:@"分享到instagram" forState:UIControlStateNormal];
    [shareInstagramButton addTarget:self action:@selector(shareInstagramButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareInstagramButton];
    
    //保存到相册按扭
    UIButton *saveToPhotosAlbumButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveToPhotosAlbumButton setFrame:CGRectMake(140, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 10, 120, 120)];
    saveToPhotosAlbumButton.layer.borderColor = [UIColor grayColor].CGColor;
    saveToPhotosAlbumButton.layer.borderWidth = 1;
    [saveToPhotosAlbumButton setTitle:@"保存到相册" forState:UIControlStateNormal];
    [saveToPhotosAlbumButton addTarget:self action:@selector(saveToPhototsAlbumButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveToPhotosAlbumButton];
    // Do any additional setup after loading the view.
}

#pragma mark 导航按扭方法

//返回上一层
- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//返回到主页
- (void)popToHomeViewButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//分享到instagram按扭方法
- (void)shareInstagramButtonPressed:(id)sender
{
    if([[NSFileManager defaultManager] fileExistsAtPath:kTheBestImagePath]){
        [[NSFileManager defaultManager] removeItemAtPath:kTheBestImagePath error:nil];
    }
    
    NSData *imageData = UIImagePNGRepresentation(theBestImage);
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有可打开的程序" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//保存到相册
- (void)saveToPhototsAlbumButtonPressed:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(theBestImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
#pragma mark 保存至本地相册 结果反馈
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil) {
        [MBProgressHUD showSuccess:NSLocalizedString(@"saved_in_album", nil)
                            toView:[UIApplication sharedApplication].keyWindow];
        
    }else {
        [MBProgressHUD showError:@"保存失败"
                          toView:[UIApplication sharedApplication].keyWindow];
    }
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
