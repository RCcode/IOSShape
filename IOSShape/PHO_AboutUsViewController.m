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

#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

#import "PHO_DataRequest.h"


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
    
    _titles = @[@"更新", @"评分", @"反馈", @"分享应用", @"关注我们"];
    
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
    _versionLabel.text = [NSString stringWithFormat:@"version: %@", appVersion()];
    
    
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
            [self sendMessage:@"home_menu_update" and:@"Home"];
            [self checkVersion];
        }
            
            break;
        case 1://评分
        {
            [self sendMessage:@"home_menu_tateus" and:@"Home"];
            NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", kiTunesID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
            break;
        case 2://反馈
        {
            
            [self sendMessage:@"home_menu_feedback" and:@"Home"];
            
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
            
            [self sendMessage:@"home_menu_share" and:@"Home"];
            //需要分享的内容
            NSString *shareContent = @"我正在用的Shape for instagram,可以为照片添加110多种漂亮有趣的形状，还有100多种背景和滤镜选择，你也来试试吧!";
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

#pragma mark -
#pragma mark 版本检测
- (void)checkVersion
{
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleID];
    PHO_DataRequest *request = [[PHO_DataRequest alloc] initWithDelegate:self];
    [request updateVersion:urlStr withTag:10];
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
