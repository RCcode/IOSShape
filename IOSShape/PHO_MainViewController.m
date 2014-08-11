//
//  PHO_MainViewController.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_MainViewController.h"

#import "PHO_AppDelegate.h"

#import "PHO_MainShowView.h"

#import "UIImage+processing.h"

#import "PHO_ShareViewController.h"

#import "Filter_GPU/NCImage/NCVideoCamera.h"

#import "MBProgressHUD+Add.h"


#define KRECT_SHOWCHOOSEVIEW (iPhone5 ? CGRectMake(0, kScreen_Height-50-105-KADHEIGHT, kScreen_Width, 105):CGRectMake(0, kScreen_Height-67-50, kScreen_Width, 67))


@interface PHO_MainViewController ()

@end

@implementation PHO_MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = colorWithHexString(@"#f5f5f5");
//        NSLog(@"%@",[UIFont familyNames]);
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 44)];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.textColor = [UIColor whiteColor];
//        titleLabel.text = @"Shape";
//        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
//        self.navigationItem.titleView = titleLabel;
//        
        UIButton *turnShapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [turnShapeButton setTitle:@"转" forState:UIControlStateNormal];
        //    turnShapeButton.backgroundColor = [UIColor blueColor];
        [turnShapeButton setBackgroundImage:[UIImage imageNamed:@"切换.png"] forState:UIControlStateNormal];
        [turnShapeButton setBackgroundImage:[UIImage imageNamed:@"切换-选中.png"] forState:UIControlStateSelected];
        turnShapeButton.frame = CGRectMake(kScreen_Width-46, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height+74, 30 , 30);
        [turnShapeButton addTarget:self action:@selector(turnButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.titleView = turnShapeButton;
        // Custom initialization
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    
    shapeGroupName = @"shape";
    shapeSelectedGroup = @"shape";
    uMengEditType = @"edit_shape";
    filterSelectedIndex = 0;
    blendMode = kCGBlendModeDestinationOut;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       shapeMulArray = [[NSMutableArray alloc]init];
                       shapeMulArray = [getImagesArray(shapeGroupName,@"png") mutableCopy];
                       
                       colorMulArray = [[NSMutableArray alloc]
                                        initWithObjects:@"#ffffff",
                                        @"#000000",
                                        @"#fff1f1",
                                        @"#f6e5c2",
                                        @"#f7f4c2",
                                        @"#f3705c",
                                        @"#f4ee64",
                                        @"#e55958",
                                        @"#2b5ca9",
                                        @"#f073ab",
                                        @"#fdb934",
                                        @"#75a454",
                                        @"#6f589c",
                                        @"#90d7eb",
                                        @"#ee5c71",
                                        @"#f48221",
                                        @"#9c95c9",
                                        @"#ffc20f",
                                        @"#bfd743",
                                        @"#65c295",
                                        @"#f8aaa6",
                                        @"#dbc4f6",
                                        @"#eec3f6",
                                        @"#f7c3d7",
                                        @"#663dae",
                                        @"#85418b",
                                        @"#9a6bea",
                                        @"#cc6fd4",
                                        @"#f589b5",
                                        @"#e46a7c",
                                        @"#4b4a4a",
                                        @"#777777",
                                        @"#acacac",
                                        @"#6d3938",
                                        @"#53402d",
                                        @"#6e5844", nil];
                       
                       graphMulArray = [[NSMutableArray alloc]init];
                       graphMulArray = [getImagesArray(@"graph",@"jpg") mutableCopy];
                       filterMulArray = [[NSMutableArray alloc]init];
                       
                   });
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 320)];
    backView.backgroundColor = [UIColor clearColor];
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    showView = [[PHO_MainShowView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    [showView getPicture:image];
    [backView addSubview:showView];
    
    shapeImage = [[UIImageView alloc]initWithFrame:showView.frame];
    topImage = [[UIImageView alloc]initWithFrame:backView.frame];
    bottomImage = [[UIImageView alloc]initWithFrame:backView.frame];
    backRealImage = [[UIImage alloc]init];
    filterMaxImage = [[UIImage alloc]init];
    filterMinImage = [[UIImage alloc]init];
    
    topImage.image = getImageFromDirectory([[[shapeMulArray objectAtIndex:0] lastPathComponent] stringByDeletingPathExtension], [NSString stringWithFormat:@"Max_%@",shapeGroupName]);
    bottomImage.image = [UIImage imageNamed:@"color-1.png"];
    
    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image andBlendMode:blendMode];
    shapeImage.alpha = 0.7f;
    backRealImage = image;
    
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
    //        {
    //            CGFloat scale = backRealImage.size.width/backRealImage.size.height;
    //
    //            if (backRealImage.size.width >= backRealImage.size.height)
    //            {
    //                if (backRealImage.size.height < 1080 )
    //                {
    //                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(backRealImage.size.height*scale, backRealImage.size.height)];
    //                }
    //                else if (backRealImage.size.height > 1080)
    //                {
    //                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(1080*scale, 1080)];
    //                }
    //                filterMinImage = [backRealImage subImageWithRect:CGRectMake((backRealImage.size.width-backRealImage.size.height)/2, 0, backRealImage.size.height, backRealImage.size.height)];
    //            }
    //            else if (backRealImage.size.width < backRealImage.size.height)
    //            {
    //                if (backRealImage.size.width < 1080)
    //                {
    //                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(backRealImage.size.width, backRealImage.size.width/scale)];
    //                }
    //                else if (backRealImage.size.width > 1080)
    //                {
    //                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(1080, 1080/scale)];
    //                }
    //                filterMinImage = [backRealImage subImageWithRect:CGRectMake(0, (backRealImage.size.height-backRealImage.size.width)/2, backRealImage.size.width, backRealImage.size.width)];
    //            }
    //            filterMinImage = [filterMinImage rescaleImageToSize:CGSizeMake(200, 200)];
    //
    //        });
    
    [backView addSubview:shapeImage];
    
    showChooseView = [[UIView alloc]initWithFrame:KRECT_SHOWCHOOSEVIEW];
    //        showChooseView.backgroundColor = colorWithHexString(@"#ededed");
    showChooseView.backgroundColor = [UIColor redColor];
    [self.view addSubview:showChooseView];
    if (!iPhone5)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissShowChooseView)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [backView addGestureRecognizer:tap];
        
        //            hideShowChooseViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //            [hideShowChooseViewButton setFrame:CGRectMake(showChooseView.frame.size.width-32, showChooseView.frame.origin.y-18, 22, 22)];
        //            hideShowChooseViewButton.backgroundColor = [UIColor clearColor];
        //            [hideShowChooseViewButton addTarget:self action:@selector(hideShowChooseViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //            [hideShowChooseViewButton setBackgroundImage:[UIImage imageNamed:@"XXX.png"] forState:UIControlStateNormal];
        //            [self.view addSubview:hideShowChooseViewButton];
        
    }
    
    [self initShapeChooseView];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)dismissShowChooseView
{
    showChooseView.hidden = YES;
}

#pragma mark 切换前景显示模式

- (void)turnButtonPressed:(id)sender
{
//    
    if (blendMode == kCGBlendModeDestinationOut)
    {
        blendMode = kCGBlendModeDestinationIn;
    }
    else
    {
        blendMode = kCGBlendModeDestinationOut;
    }
    UIButton *tempButton = (UIButton *)sender;
    if (tempButton.selected)
    {
        tempButton.selected = NO;
    }
    else
    {
        tempButton.selected = YES;
    }
    shapeImage.image = [shapeImage.image turnShapeWithImage:bottomImage.image];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //导航
//    UIView *customNavgationView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y, 320, 44)];
//    NSLog(@"%d",TOPORIGIN_Y);
//    customNavgationView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:customNavgationView];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 0, 12, 20)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(280, 0, 19, 26)];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share-icon.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tabbar
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-49-KADHEIGHT, kScreen_Width, 49)];
    if (iPhone5)
    {
        tabbarView.frame = CGRectMake(0, kScreen_Height-49-KADHEIGHT, kScreen_Width, 49);
    }
    else
    {
        tabbarView.frame = CGRectMake(0, kScreen_Height-49, kScreen_Width, 49);
    }
    
    tabbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tabbarView];
    
    UIButton *shapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shapeButton setFrame:CGRectMake(0, 0, tabbarView.frame.size.width/3, tabbarView.frame.size.height)];
    [shapeButton addTarget:self action:@selector(shapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shapeButton setBackgroundImage:[UIImage imageNamed:@"形状.png"] forState:UIControlStateNormal];
    [shapeButton setBackgroundImage:[UIImage imageNamed:@"形状(选中).png"] forState:UIControlStateSelected];
    [shapeButton setSelected:YES];
    [tabbarView addSubview:shapeButton];
    
    UIButton *backGroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backGroundButton setFrame:CGRectMake(tabbarView.frame.size.width/3, 0, tabbarView.frame.size.width/3, tabbarView.frame.size.height)];
    [backGroundButton addTarget:self action:@selector(backGroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundButton setBackgroundImage:[UIImage imageNamed:@"前景编辑.png"] forState:UIControlStateNormal];
    [backGroundButton setBackgroundImage:[UIImage imageNamed:@"前景编辑(选中).png"] forState:UIControlStateSelected];
    [tabbarView addSubview:backGroundButton];
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setFrame:CGRectMake(tabbarView.frame.size.width/3*2, 0, tabbarView.frame.size.width/3, tabbarView.frame.size.height)];
    [filterButton addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"滤镜.png"] forState:UIControlStateNormal];
    [filterButton setBackgroundImage:[UIImage imageNamed:@"滤镜(选中).png"] forState:UIControlStateSelected];
    [tabbarView addSubview:filterButton];
    
    // Do any additional setup after loading the view.
}
//隐藏选择view
- (void)hideShowChooseViewButtonPressed:(id)sender
{
    
    if (!showChooseView.hidden)
    {
        showChooseView.hidden = YES;
        hideShowChooseViewButton.hidden = YES;
    }
}

#pragma mark 初始化图形选择view

- (void)initShapeChooseView
{
    shapeChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, showChooseView.frame.size.height)];
    shapeChooseView.backgroundColor = colorWithHexString(@"#ededed");
    [showChooseView insertSubview:shapeChooseView atIndex:0];
    
    
    shapeGroupBackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, shapeChooseView.frame.size.height-3-60, shapeChooseView.frame.size.width, shapeChooseView.frame.size.height)];
    shapeGroupBackView.tag = 10;
    shapeGroupBackView.showsVerticalScrollIndicator = NO;
    shapeGroupBackView.showsHorizontalScrollIndicator = NO;
    [shapeChooseView addSubview:shapeGroupBackView];
    
//    NSArray *groupNameArray = [NSArray arrayWithObjects:@"shape", @"love", @"flower", @"nature", @"grocery",nil];
    NSArray *groupNameArray = @[LocalizedString(@"editView_shape", @""),
                                LocalizedString(@"editView_love", @""),
                                LocalizedString(@"editView_flower", @""),
                                LocalizedString(@"editView_nature", @""),
                                LocalizedString(@"editView_grocery", @"")];
//
//    CGFloat buttonX = 20;
    for (int i = 0; i < [groupNameArray count]; i ++)
    {
//        NSString *titleString = [groupNameArray objectAtIndex:i];
//        CGSize buttonSize = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]}];
    
        UIButton *chooseGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseGroupButton setFrame:CGRectMake(4*i + 60*i, 0, 60, 60)];
        [chooseGroupButton addTarget:self action:@selector(chooseGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        chooseGroupButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        [chooseGroupButton setTitleColor:colorWithHexString(@"#a2a2a2") forState:UIControlStateNormal];
        [chooseGroupButton setTitleColor:colorWithHexString(@"#fe8c4f") forState:UIControlStateSelected];
        if (i == 0)
        {
            chooseGroupButton.selected = YES;
        }
        chooseGroupButton.tag = i + 10;
        [chooseGroupButton setTitle:[groupNameArray objectAtIndex:i] forState:UIControlStateNormal];
        chooseGroupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        chooseGroupButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [shapeGroupBackView addSubview:chooseGroupButton];
        shapeGroupBackView.contentSize = CGSizeMake(chooseGroupButton.frame.origin.x + chooseGroupButton.frame.size.width, 0);
    }
//    if (groupBackView.contentSize.width < kScreen_Width)
//    {
//        CGFloat adjustWidth = (kScreen_Width-groupBackView.contentSize.width)/[groupNameArray count];
//        for (int j = 0; j < [groupNameArray count]; j++)
//        {
//            UIButton *tempButton = (UIButton *)[groupBackView viewWithTag:10 + j];
//            tempButton.frame = CGRectMake(tempButton.frame.origin.x + adjustWidth * j, tempButton.frame.origin.y, tempButton.frame.size.width + adjustWidth, tempButton.frame.size.height);
//        }
//        
//    }

    shapeChooseBackView = [[UIView alloc]initWithFrame:CGRectMake(0, shapeChooseView.frame.size.height-3-68, shapeChooseView.frame.size.width, shapeChooseView.frame.size.height+8)];
    shapeChooseBackView.backgroundColor = [UIColor clearColor];
//    [showChooseView insertSubview:shapeChooseBackView belowSubview:shapeGroupBackView];

    UIButton *shapeGroupBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shapeGroupBackButton.frame = CGRectMake(4, 4, 60, 60);
    [shapeGroupBackButton setTitle:@"返回" forState:UIControlStateNormal];
    [shapeGroupBackButton addTarget:self action:@selector(shapeGroupBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shapeChooseBackView addSubview:shapeGroupBackButton];

    shapeChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(64, 0, kScreen_Width-64, 68)];
    shapeChooseScrollView.contentSize = CGSizeMake(64 * [shapeMulArray count], 68);
    shapeChooseScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    shapeChooseScrollView.showsHorizontalScrollIndicator = NO;
    shapeChooseScrollView.showsVerticalScrollIndicator = NO;
    [shapeChooseBackView addSubview:shapeChooseScrollView];

    shapeSelectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    shapeSelectedView.layer.borderColor = colorWithHexString(@"#636363").CGColor;
    shapeSelectedView.layer.borderWidth = 2;
    shapeSelectedView.userInteractionEnabled = NO;
    [shapeChooseScrollView addSubview:shapeSelectedView];
    
    for (int i = 0; i < [shapeMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseShapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseShapeButton setFrame:CGRectMake(4*(i+1)+60*i, 4, 60, 60)];
            [chooseShapeButton addTarget:self action:@selector(chooseShapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseShapeButton setBackgroundImage:[UIImage imageWithContentsOfFile:[shapeMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            if (i == 0)
            {
                shapeSelectedView.center = chooseShapeButton.center;
            }
            chooseShapeButton.tag = i + 10;
            [shapeChooseScrollView addSubview:chooseShapeButton];
        }
    }
    
}

-(void)chooseShapeButtonPressed:(id)sender
{
    //选择哪个图形
    
    UIButton *tempButton = (UIButton *)sender;
    
    if (shapeSelectedView.hidden == NO && shapeSelectedView.center.x == tempButton.center.x && shapeSelectedView.center.y == tempButton.center.y)
    {
        return;
    }
    
    shapeSelectedView.hidden = NO;
    
    shapeSelectedGroup = shapeGroupName;
    
    NSString *tempStr = [NSString stringWithFormat:@"edit_shape_category%ld_%d",(long)[self getGroupNum],tempButton.tag - 10];
    
    [self sendMessage:tempStr and:@"edit"];
    
    shapeSelectedView.center = tempButton.center;
    
    NSString *pathStr = [shapeMulArray objectAtIndex:tempButton.tag - 10];
    
    topImage.image = getImageFromDirectory([[pathStr lastPathComponent] stringByDeletingPathExtension] , [NSString stringWithFormat:@"Max_%@",shapeGroupName]);
    
//    topImage.image = [UIImage imageWithContentsOfFile:pathStr];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1);
    dispatch_after(time, dispatch_get_main_queue(), ^
    {
        
        shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image andBlendMode:blendMode];
});
}

- (void)chooseGroupButtonPressed:(id)sender
{
    
    //选择哪个组
    UIButton *tempButton = (UIButton *)sender;
    
    [shapeMulArray removeAllObjects];
    
    [shapeChooseView addSubview:shapeChooseBackView];
    [shapeGroupBackView removeFromSuperview];
    
    
    switch (tempButton.tag - 10)
    {
        case 0:
            ;
            shapeGroupName = @"shape";
            break;
        case 1:
            ;
            shapeGroupName = @"love";
            break;
        case 2:
            ;
            shapeGroupName = @"flower";
            break;
        case 3:
            ;
            shapeGroupName = @"nature";
            break;
        case 4:
            ;
            shapeGroupName = @"grocery";
            break;
        default:
            break;
    }
    
    shapeSelectedView.hidden = YES;
    
    if (shapeSelectedGroup == shapeGroupName)
    {
        shapeSelectedView.hidden = NO;
    }
    
    NSString *tempStr = [NSString stringWithFormat:@"edit_shape_category%ld",(long)[self getGroupNum]];
    [self sendMessage:tempStr and:@"edit"];
    
    shapeMulArray = [getImagesArray(shapeGroupName,@"png") mutableCopy];
    
    for (UIView *tempView in shapeChooseScrollView.subviews)
    {
        if ([tempView isKindOfClass:[UIButton class]])
        {
            [tempView removeFromSuperview];
        }
    }
    
    shapeChooseScrollView.contentSize = CGSizeMake(64 * [shapeMulArray count], 68);
    shapeChooseScrollView.contentOffset = CGPointMake(0, 0);
    for (int i = 0; i < [shapeMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseShapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseShapeButton setFrame:CGRectMake(+4*(i+1)+60*i, 4, 60, 60)];
            [chooseShapeButton addTarget:self action:@selector(chooseShapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseShapeButton setBackgroundImage:[UIImage imageWithContentsOfFile:[shapeMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            chooseShapeButton.tag = i + 10;
            [shapeChooseScrollView addSubview:chooseShapeButton];
        }
    }
    
}

- (void)shapeGroupBackButtonPressed:(id)sender
{
    [shapeChooseView addSubview:shapeGroupBackView];
    [shapeChooseBackView removeFromSuperview];
}

- (NSInteger)getGroupNum
{
    NSInteger returnGroupNum = 0;
    if ([shapeGroupName isEqualToString:@"shape"])
    {
        returnGroupNum = 1;
    }
    else if ([shapeGroupName isEqualToString:@"love"])
    {
        returnGroupNum = 2;
    }
    else if ([shapeGroupName isEqualToString:@"flower"])
    {
        returnGroupNum = 3;
    }
    else if ([shapeGroupName isEqualToString:@"nature"])
    {
        returnGroupNum = 4;
    }
    else if ([shapeGroupName isEqualToString:@"grocery"])
    {
        returnGroupNum = 5;
    }
    return returnGroupNum;
}

#pragma mark 初始化背景选择view

- (void)initBackGroundView
{
    backGroundChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, showChooseView.frame.size.height)];
    backGroundChooseView.backgroundColor = colorWithHexString(@"#ededed");
    
    backGroundSelectedView = [[UIImageView alloc]initWithFrame:CGRectZero];
    backGroundSelectedView.layer.borderColor = colorWithHexString(@"#636363").CGColor;
    backGroundSelectedView.layer.borderWidth = 2;
    
    
    
    UIScrollView *backgroundGroupBackView = [[UIScrollView alloc]initWithFrame:CGRectMake(60, shapeChooseView.frame.size.height-3-60, shapeChooseView.frame.size.width-60, shapeChooseView.frame.size.height)];
    backgroundGroupBackView.tag = 10;
    backgroundGroupBackView.showsVerticalScrollIndicator = NO;
    backgroundGroupBackView.showsHorizontalScrollIndicator = NO;
    [shapeChooseView addSubview:backgroundGroupBackView];
    
    UIButton *backgroundGroupBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundGroupBackButton.frame = CGRectMake(0, 0, 60, 60);
    [backgroundGroupBackButton setTitle:@"返回" forState:UIControlStateNormal];
    [backgroundGroupBackButton addTarget:self action:@selector(groupBackButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundGroupBackView addSubview:backgroundGroupBackButton];
    
//    NSArray *typeNameArray = [NSArray arrayWithObjects:@"颜色", @"图案", @"透明度", nil];
    NSArray *typeNameArray = @[LocalizedString(@"editView_Colur", @""),
                               LocalizedString(@"editView_Pattern", @""),
                               LocalizedString(@"editView_Opacity", @""),];

    for (int i = 0; i < [typeNameArray count]; i ++)
    {
        @autoreleasepool
        {
            UIButton *chooseTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseTypeButton setFrame:CGRectMake((backGroundChooseView.frame.size.width/[typeNameArray count])*i, 1, backGroundChooseView.frame.size.width/typeNameArray.count , 30)];
            [chooseTypeButton setTitle:[typeNameArray objectAtIndex:i] forState:UIControlStateNormal];
            [chooseTypeButton addTarget:self action:@selector(chooseTypeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseTypeButton setTag:i+1];
            chooseTypeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
            if (i == 0)
            {
                chooseTypeButton.selected = YES;
            }
            [chooseTypeButton setTitleColor:colorWithHexString(@"#a2a2a2") forState:UIControlStateNormal];
            [chooseTypeButton setTitleColor:colorWithHexString(@"#fe8c4f") forState:UIControlStateSelected];
            [backGroundChooseView addSubview:chooseTypeButton];
            
        }
    }
    
    colorChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 52)];
    colorChooseScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    colorChooseScrollView.showsHorizontalScrollIndicator = NO;
    colorChooseScrollView.showsVerticalScrollIndicator = NO;
    [colorChooseScrollView setContentSize:CGSizeMake(46*[colorMulArray count], 52)];
    for (int i = 0; i < [colorMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseColorButton setFrame:CGRectMake(6*(i+1)+40*i, 6, 40, 40)];
            [chooseColorButton addTarget:self action:@selector(chooseColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseColorButton setBackgroundColor:colorWithHexString([colorMulArray objectAtIndex:i])];
            chooseColorButton.tag = i + 10;
            [colorChooseScrollView addSubview:chooseColorButton];
        }
    }
    [backGroundChooseView addSubview:colorChooseScrollView];
    
    graphChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 52)];
    graphChooseScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    graphChooseScrollView.showsVerticalScrollIndicator = NO;
    graphChooseScrollView.showsHorizontalScrollIndicator = NO;
    [graphChooseScrollView setContentSize:CGSizeMake(46 * [graphMulArray count], 52)];
    for (int i = 0; i < [graphMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseGraphButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseGraphButton setFrame:CGRectMake(6*(i+1)+40*i, 6, 40, 40)];
            [chooseGraphButton addTarget:self action:@selector(chooseGraphButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseGraphButton setBackgroundImage:[UIImage imageWithContentsOfFile:[graphMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            chooseGraphButton.tag = i + 10;
            [graphChooseScrollView addSubview:chooseGraphButton];
        }
    }
    
    CGRect sliderRect = CGRectMake(65, 16, 244, 20);
    
    
    blurSlider = [[UISlider alloc]initWithFrame:sliderRect];
    [blurSlider addTarget:self action:@selector(blurSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [blurSlider setValue:0.0f];
    [blurSlider setMinimumValue:0.0f];
    [blurSlider setMaximumValue:1.5f];
    
    alphaSliderView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 52)];
    alphaSliderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    
    alphaSlider = [[UISlider alloc]initWithFrame:sliderRect];
    [alphaSlider addTarget:self action:@selector(alphaSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [alphaSlider setMinimumTrackTintColor:colorWithHexString(@"#fe8c3f")];
    [alphaSlider setValue:0.2f];
    [alphaSlider setMinimumValue:0.0f];
    [alphaSlider setMaximumValue:1.0f];
    [alphaSliderView addSubview:alphaSlider];
    
    valuePercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 20)];
    valuePercentLabel.textAlignment = NSTextAlignmentCenter;
    valuePercentLabel.text = [NSString stringWithFormat:@"%d%%",(int)((alphaSlider.value/alphaSlider.maximumValue)*100)];
    [alphaSliderView addSubview:valuePercentLabel];
}

- (void)chooseTypeButtonPressed:(id)sender
{
    //选择哪种类型处理
    
    for (UIView *tempView in backGroundChooseView.subviews)
    {
        if (![tempView isKindOfClass:[UIButton class]])
        {
            [tempView removeFromSuperview];
        }
        else
        {
            UIButton *tempButton = (UIButton *)tempView;
            tempButton.selected = NO;
        }
    }
    
    UIButton *tempButton = (UIButton *)sender;
    tempButton.selected = YES;
    NSInteger tag = tempButton.tag;
    switch (tag)
    {
        case 1:
            ;
            //友盟统计
            [self sendMessage:@"edit_background_color" and:@"edit"];
            [backGroundChooseView addSubview:colorChooseScrollView];
            break;
        case 2:
            ;
            //友盟统计
            [self sendMessage:@"edit_background_pattern" and:@"edit"];
            [backGroundChooseView addSubview:graphChooseScrollView];
            break;
//        case 3:
//            ;
//            [backGroundChooseView addSubview:blurSlider];
//            break;
        case 3:
            ;
            //友盟统计
            [self sendMessage:@"edit_background_opacity" and:@"edit"];
            [backGroundChooseView addSubview:alphaSliderView];
            break;

        default:
            break;
    }
    
}

- (void)chooseColorButtonPressed:(id)sender
{
    //选择哪个颜色
    UIButton *tempButton = (UIButton *)sender;
    //友盟统计
    NSString *tempStr = [NSString stringWithFormat:@"edit_background_color_%d",tempButton.tag-10];
    [self sendMessage:tempStr and:@"edit"];
    
    if (![colorChooseScrollView.subviews containsObject:backGroundSelectedView])
    {
        [backGroundSelectedView removeFromSuperview];
        [colorChooseScrollView addSubview:backGroundSelectedView];
    }
    else if (backGroundSelectedView.center.x == tempButton.center.x && backGroundSelectedView.center.y == tempButton.center.y)
    {
        return;
    }
    backGroundSelectedView.frame = tempButton.frame;
    if (backColorView == nil)
    {
        backColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1080, 1080)];
    }
    backColorView.backgroundColor = colorWithHexString([colorMulArray objectAtIndex:tempButton.tag-10]);

    
    
//    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:blurSlider.value];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
    {
        bottomImage.image = [UIImage getImageFromView:backColorView];
    });
    
    shapeImage.image = [shapeImage.image changeTintColor:colorWithHexString([colorMulArray objectAtIndex:tempButton.tag-10])];
    
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0);
//    dispatch_after(time, dispatch_get_main_queue(), ^{ NSLog(@"waited at least three seconds.");
//    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];});
    
}

- (void)chooseGraphButtonPressed:(id)sender
{
    //选择哪个图案
    UIButton *tempButton = (UIButton *)sender;
    //友盟统计
    
    NSString *tempStr = [NSString stringWithFormat:@"edit_background_pattern_%d",tempButton.tag-10];
    [self sendMessage:tempStr and:@"edit"];
    
    if (![graphChooseScrollView.subviews containsObject:backGroundSelectedView])
    {
        [backGroundSelectedView removeFromSuperview];
        [graphChooseScrollView addSubview:backGroundSelectedView];
    }
    else if (backGroundSelectedView.center.x == tempButton.center.x && backGroundSelectedView.center.y == tempButton.center.y)
    {
        return;
    }
    backGroundSelectedView.frame = tempButton.frame;
    
    UIImage *tempImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[graphMulArray objectAtIndex:tempButton.tag - 10]]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                   {
                       bottomImage.image = [self getGraphImage:tempImage];
                       
//                       dispatch_aft(dispatch_get_main_queue(), ^
//                       {
//                           UIImage *tempShapeImage = [shapeImage.image changeGraph:bottomImage.image];
//                           shapeImage.image = tempShapeImage;
//                       });
                       dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0 );
                       dispatch_after(time, dispatch_get_main_queue(), ^
                       {
//                           NSLog(@"waited at least three seconds.");
                           shapeImage.image = [shapeImage.image changeGraph:bottomImage.image];
                       });
                   });


//    UIImage *tempChooseImage1 = [self getGraphImage:tempChooseImage];
//    UIImage *tempChooseImage = [bottomImage.image rescaleImageToSize:shapeImage.frame.size];
//    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:blurSlider.value];
//    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
    
    

    
}

- (UIImage *)getGraphImage:(UIImage *)image
{
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1080, 1080)];
    tempView.alpha = 1;
    tempView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIGraphicsBeginImageContext(tempView.frame.size);
    
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return returnImage;
}


-(void)blurSliderValueChange:(id)sender
{
    UISlider *tempslider = (UISlider *)sender;
    
    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:tempslider.value];
}

-(void)alphaSliderValueChange:(id)sender
{
    UISlider *tempslider = (UISlider *)sender;
    
    shapeImage.alpha = 1-tempslider.value;
    
    valuePercentLabel.text = [NSString stringWithFormat:@"%d%%",(int)((tempslider.value/alphaSlider.maximumValue)*100)];
}

#pragma mark - 初始化滤镜选择view

- (void)initFilterChooseView
{
    filterChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 82)];
    filterSelectedView = [[UIImageView alloc]initWithFrame:CGRectZero];
    filterSelectedView.layer.borderColor = colorWithHexString(@"#636363").CGColor;
    filterSelectedView.layer.borderWidth = 2;
    
    UIScrollView *filterChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 82)];
    filterChooseScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    filterChooseScrollView.contentSize = CGSizeMake(65*[filterMulArray count], 82);
    filterChooseScrollView.showsHorizontalScrollIndicator = NO;
    filterChooseScrollView.showsVerticalScrollIndicator = NO;
    [filterChooseView addSubview:filterChooseScrollView];
    
    CGSize buttonSize ;
    if (iPhone5)
    {
        filterChooseView.frame = CGRectMake(0, 0, kScreen_Width, 82);
        filterChooseScrollView.frame = CGRectMake(0, 0, kScreen_Width, 82);
        filterChooseScrollView.contentSize = CGSizeMake(65*[filterMulArray count], 82);
        buttonSize = CGSizeMake(59, 59);
    }
    else
    {
        filterChooseView.frame = CGRectMake(0, 30, kScreen_Width, 52);
        filterChooseScrollView.frame = CGRectMake(0, 0, kScreen_Width, 52);
        CGSizeMake(46*[filterMulArray count], 52);
        buttonSize = CGSizeMake(40, 40);

    }
//    NSArray *itemTitles = @[@"Origin", @"Lomo", @"Sunset",
//                            @"Warm", @"Ice", @"Grayscale",
//                            @"Blues", @"Shadows", @"Yesterday",
//                            @"Glow", @"B/W", @"Pencil",
//                            @"Chroma", @"Neon", @"Pinhole"];
    
    for (int i = 0; i < [filterMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseFilterButton setFrame:CGRectMake(6*(i+1)+buttonSize.width*i, (filterChooseView.frame.size.height-buttonSize.height)/2, buttonSize.width, buttonSize.height)];
            [chooseFilterButton addTarget:self action:@selector(chooseFilterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [chooseFilterButton setTitle:[itemTitles objectAtIndex:i] forState:UIControlStateNormal];
//            chooseFilterButton.titleLabel.backgroundColor = [UIColor blackColor];
//            chooseFilterButton.titleLabel.alpha = 0.7;
//            chooseFilterButton.titleLabel.textColor = [UIColor whiteColor];
//            chooseFilterButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
//            [chooseFilterButton setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
            
            [chooseFilterButton setBackgroundImage:[UIImage imageWithContentsOfFile:[filterMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            if (i == 0)
            {
                filterSelectedView.frame = chooseFilterButton.frame;
                [chooseFilterButton setTitle:@"Origin" forState:UIControlStateNormal];
                [chooseFilterButton setTitleEdgeInsets:UIEdgeInsetsMake(22, 0, 0, 0)];
                chooseFilterButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
                chooseFilterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            chooseFilterButton.tag = i + 10;
            [filterChooseScrollView addSubview:chooseFilterButton];
        }
    }
    [filterChooseScrollView addSubview:filterSelectedView];
}

- (void)chooseFilterButtonPressed:(id)sender
{
//    
//    NSArray *itemTitles = @[@"Origin", @"Lomo", @"Sunset",
//                            @"Warm", @"Ice", @"Grayscale",
//                            @"Blues", @"Shadows", @"Yesterday",
//                            @"Glow", @"B/W", @"Pencil",
//                            @"Chroma", @"Neon", @"Pinhole"];

    //选择滤镜效果
    UIButton *tempButton = (UIButton *)sender;
    filterSelectedIndex = tempButton.tag-10;
    if (filterSelectedView.center.x == tempButton.center.x && filterSelectedView.center.y == tempButton.center.y)
    {
        return;
    }
    filterSelectedView.frame = tempButton.frame;
    NSString *tempStr = [NSString stringWithFormat:@"edit_filter_%d",tempButton.tag-10];
    [self sendMessage:tempStr and:@"edit"];
    filterSelectedView.frame = tempButton.frame;
    
    [showView.filterView switchFilter:(NCFilterType)tempButton.tag-10];
}

#pragma mark - 导航按扭方法

/**********************************************************
 函数名称：-(void)backButtonPressed:(id)sender
 函数描述：返回按扭的点击方法
 输入参数：(id)sender:返回按扭的点击事件
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)backButtonPressed:(id)sender
{
    if (shareContrller.isSaved)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:LocalizedString(@"backTipMessage", @"") delegate:self cancelButtonTitle:LocalizedString(@"backTipCancel", @"") otherButtonTitles:LocalizedString(@"backTipConfirm", @""), nil];
        
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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

/**********************************************************
 函数名称：-(void)shareButtonPressed:(id)sender
 函数描述：分享按扭的点击方法
 输入参数：(id)sender:分享按扭的点击事件
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)shareButtonPressed:(id)sender
{
    //分享
//    [MBProgressHUD showSuccess:LocalizedString(@"", @"") toView:[UIApplication sharedApplication].keyWindow];

//    [MBProgressHUD showMessage:@"正在处理" toView:[UIApplication sharedApplication].keyWindow];
    
    UIView *passView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1080, 1080)];
    if (backRealImage.size.width >= backRealImage.size.height)
    {
        if (backRealImage.size.height <= 1080)
        {
            passView.frame = CGRectMake(0, 0, backRealImage.size.height, backRealImage.size.height);
        }
        if (backRealImage.size.height > 1080)
        {
            passView.frame = CGRectMake(0, 0, 1080, 1080);
        }
        
    }
    else
    {
        if (backRealImage.size.width <= 1080)
        {
            passView.frame = CGRectMake(0, 0, backRealImage.size.width, backRealImage.size.width);
        }
        if (backRealImage.size.width > 1080)
        {
            passView.frame = CGRectMake(0, 0, 1080, 1080);
        }
    }

    
    UIImageView *passBackImageView = [[UIImageView alloc]initWithFrame:passView.frame];
    passBackImageView.image = [UIImage getEditFinishedImageWithView:showView andContextSize:passView.frame.size];
    [passView addSubview:passBackImageView];
    
    UIImageView *passImageView = [[UIImageView alloc]initWithFrame:passView.frame];
    [passView addSubview:passImageView];
    
    passImageView.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image andBlendMode:blendMode];
    passImageView.alpha = shapeImage.alpha;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull);
    dispatch_after(time, dispatch_get_main_queue(), ^
    {
        UIImage *passImage = [UIImage getEditFinishedImageWithView:passView andContextSize:passView.frame.size];

        if (shareContrller == nil)
        {
            shareContrller = [[PHO_ShareViewController alloc]init];
        }
        [shareContrller getImage:passImage];
        
        [self.navigationController pushViewController:shareContrller animated:YES];
    });
    
//    showView.frame = tempRect;
//    showView.showImageView.frame = tempRect;
}

-(UIImage *)getImageFromView:(UIView *)view
{
    CGSize newSize = CGSizeMake(1080, 1080);
    
    UIGraphicsBeginImageContext(newSize);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - tabbar按扭方法
/**********************************************************
 函数名称：- (void)shapeButtonPressed:(id)sender
 函数描述：选择图形按扭的点击方法
 输入参数：(id)sender:分享按扭的点击事件
 输出参数：无
 返回值：  无
 **********************************************************/
- (void)shapeButtonPressed:(id)sender
{
    showChooseView.hidden = NO;
    hideShowChooseViewButton.hidden = NO;
    
    [self sendMessage:@"edit_shape" and:@"edit"];
    
    [self selectChanged:sender];
    
    if (![showChooseView.subviews containsObject:shapeChooseView])
    {
        for (UIView * tempView in showChooseView.subviews)
        {
            if (![tempView isKindOfClass:[UIButton class]])
            {
                [tempView removeFromSuperview];
                [showChooseView insertSubview:shapeChooseView atIndex:0];
            }
        }
    }
}

/**********************************************************
 函数名称：- (void)backGroundButtonPressed:(id)sender
 函数描述：背景选择按扭的点击方法
 输入参数：(id)sender:分享按扭的点击事件
 输出参数：无
 返回值：  无
 **********************************************************/
- (void)backGroundButtonPressed:(id)sender
{
    showChooseView.hidden = NO;
    hideShowChooseViewButton.hidden = NO;
    
    [self sendMessage:@"edit_backgroun" and:@"edit"];
    
    [self selectChanged:sender];
    
    if (![showChooseView.subviews containsObject:backGroundChooseView])
    {
        if (backGroundChooseView == nil)
        {
            [self initBackGroundView];
        }
        for (UIView * tempView in showChooseView.subviews)
        {
            if ([tempView isKindOfClass:[UIButton class]])
            {
                continue;
            }
            else
            {
                [tempView removeFromSuperview];
                [showChooseView insertSubview:backGroundChooseView atIndex:0];
            }
        }
    }

}

/**********************************************************
 函数名称：- (void)filterButtonPressed:(id)sender
 函数描述：滤镜按扭的点击方法
 输入参数：(id)sender:分享按扭的点击事件
 输出参数：无
 返回值：  无
 **********************************************************/

- (void)filterButtonPressed:(id)sender
{
    showChooseView.hidden = NO;
    hideShowChooseViewButton.hidden = NO;
    
    [self sendMessage:@"edit_filter" and:@"edit"];
    
    [self selectChanged:sender];
    
    if ([filterMulArray count] == 0)
    {
        filterMulArray = [getImagesArray(@"滤纸图标", @"png") mutableCopy];
        [self initFilterChooseView];
    }
    
    if (![showChooseView.subviews containsObject:filterChooseView])
    {
        for (UIView * tempView in showChooseView.subviews)
        {
            if ([tempView isKindOfClass:[UIButton class]])
            {
                continue;
            }
            else
            {
                [tempView removeFromSuperview];
                [showChooseView insertSubview:filterChooseView atIndex:0];
            }
        }
    }
}

#pragma mark tabbar按扭状态改变
- (void)selectChanged:(id)sender
{
    UIButton *tempButton = (UIButton *)sender;
    
    for (UIButton *btn in tabbarView.subviews)
    {
        btn.selected = NO;
    }
    tempButton.selected = YES;
}

#pragma mark 发送统计

- (void)sendMessage:(NSString *)label and:(NSString *)event
{
    //友盟统计
    [MobClick event:event label:label];

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
