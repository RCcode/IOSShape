//
//  PHO_AboutUsViewController.m
//  IOSShape
//
//  Created by wsq-wlq on 14-5-29.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_AboutUsViewController.h"
#import "PHO_AboutUsTableViewCell.h"
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface PHO_AboutUsViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray *_imageNames;
    NSArray *_titles;
}

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PHO_AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    _imageNames = @[@"更新",@"评分",@"反馈",@"分享",@"关注我们"];
    
//    _titles = @[LocalizedString(@"update", nil),
//                LocalizedString(@"score", nil),
//                LocalizedString(@"feedback", nil),
//                LocalizedString(@"share", nil),
//                LocalizedString(@"follow_us", nil)];
    
    _titles = @[@"更新", @"评分", @"反馈", @"分享", @"关注我们"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"Share";
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 10, 12, 20)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //title
//    _versionLabel.text = [NSString stringWithFormat:@"version: %@", appVersion()];
    
    
    //tabelView
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
}

- (void)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableVeiwDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _imageNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PHO_AboutUsTableViewCell *cell = [PHO_AboutUsTableViewCell moreTabelViewCellWithTableView:tableView IndexPath:indexPath];
    
    //设置数据
    NSUInteger index = indexPath.row;
    [cell setImageName:_imageNames[index] AndTitle:_titles[index]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //隐藏moreTable
    [self touchesBegan:nil withEvent:nil];
    
    switch (indexPath.row) {
        case 0://更新
        {
            [MobClick event:@"home_menu_update" label:@"Home"];
            [self GetUpdate];
        }
            
            break;
        case 1://评分
        {
            [MobClick event:@"home_menu_rateus" label:@"Home"];
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kiTunesID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
            break;
        case 2://反馈
        {
            [MobClick event:@"home_menu_feedback" label:@"Home"];
            //直接发邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate =self;
            NSString *subject = @"-Photo Collage Feedback";
            [picker setSubject:subject];
            [picker setToRecipients:@[kFeedbackEmail]];
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 3://分享
        {
            [MobClick event:@"home_menu_share" label:@"Home"];
            //需要分享的内容
            NSString *shareContent = @"share content";
            NSArray *activityItems = @[shareContent];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            __weak UIActivityViewController *blockActivityVC = activityVC;
            
            activityVC.completionHandler = ^(NSString *activityType,BOOL completed){
                if(completed){
                    MBProgressHUD *hud = showMBProgressHUD(@"share success", NO);
                    [hud performSelector:@selector(hide:) withObject:nil afterDelay:1.5];
                }
                [blockActivityVC dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:activityVC animated:YES completion:nil];
        }
            
            break;
        case 4://关注我
            [MobClick event:@"home_menu_followus" label:@"Home"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFollwUsURL]];
            break;
        default:
            break;
    }
}

//版本更新
-(void)GetUpdate
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",kiTunesID]];
    
    NSString * file =  [NSString stringWithContentsOfURL:url];
    //    NSLog(file);
    //"version":"1.0"
    NSRange substr = [file rangeOfString:@"\"version\":\""];
    NSRange substr2 =[file rangeOfString:@"\"" options:NULL range: NSMakeRange(substr.location+substr.length, 10)];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123)
    {
        if(buttonIndex==0)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/qun-xiang-dao/id%@?ls=1&mt=8",kiTunesID ]];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
    
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{
        if(MFMailComposeResultSent == result){
            MBProgressHUD *hud = showMBProgressHUD(@"success", NO);
            [hud performSelector:@selector(hide:) withObject:nil afterDelay:1.5];
        }
    }];
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