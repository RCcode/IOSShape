//
//  PHO_MainViewController.m
//  photoprocessing
//
//  Created by wsq-wlq on 14-5-21.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import "PHO_MainViewController.h"

#import "PHO_MainShowView.h"

#import "UIImage+processing.h"

#import "PHO_ShareViewController.h"


#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

#import "Filter_GPU/NCImage/NCVideoCamera.h"


#define KRECT_SHOWCHOOSEVIEW (iPhone5 ? CGRectMake(0, kScreen_Height-50-79-KADHEIGHT, kScreen_Width, 79):CGRectMake(0, kScreen_Height-79-KADHEIGHT, kScreen_Width, 79))


@interface PHO_MainViewController ()

@end

@implementation PHO_MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = colorWithHexString(@"#f5f5f5");
//        NSLog(@"%@",[UIFont familyNames]);
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"Shape";
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:22];
        self.navigationItem.titleView = titleLabel;
        // Custom initialization
    }
    return self;
}

/**********************************************************
 函数名称：-(id)initWithImage:(UIImage *)image
 函数描述：初始化修饰图片
 输入参数：(UIImage *)image:用户选中图片
 输出参数：(UIImage *)chooseImage:待处理图片
 返回值：  self
 **********************************************************/

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        shapeGroupName = @"shape";
        shapeSelectedGroup = @"shape";
        uMengEditType = @"edit_shape";
        filterSelectedIndex = 0;
        
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

        backView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y + 44, 320, 320)];
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
        
        shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
        shapeImage.alpha = 0.7f;
        backRealImage = image;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            CGFloat scale = backRealImage.size.width/backRealImage.size.height;
            
            if (backRealImage.size.width >= backRealImage.size.height)
            {
                if (backRealImage.size.height < 1080 )
                {
                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(backRealImage.size.height*scale, backRealImage.size.height)];
                }
                else if (backRealImage.size.height > 1080)
                {
                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(1080*scale, 1080)];
                }
                filterMinImage = [backRealImage subImageWithRect:CGRectMake((backRealImage.size.width-backRealImage.size.height)/2, 0, backRealImage.size.height, backRealImage.size.height)];
            }
            else if (backRealImage.size.width < backRealImage.size.height)
            {
                if (backRealImage.size.width < 1080)
                {
                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(backRealImage.size.width, backRealImage.size.width/scale)];
                }
                else if (backRealImage.size.width > 1080)
                {
                    filterMaxImage = [backRealImage rescaleImageToSize:CGSizeMake(1080, 1080/scale)];
                }
                filterMinImage = [backRealImage subImageWithRect:CGRectMake(0, (backRealImage.size.height-backRealImage.size.width)/2, backRealImage.size.width, backRealImage.size.width)];
            }
            filterMinImage = [filterMinImage rescaleImageToSize:CGSizeMake(200, 200)];
            
        });
       
        [backView addSubview:shapeImage];
        
        showChooseView = [[UIView alloc]initWithFrame:KRECT_SHOWCHOOSEVIEW];
//        showChooseView.backgroundColor = colorWithHexString(@"#ededed");
        showChooseView.backgroundColor = [UIColor clearColor];
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
    return self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return YES;
    }
    return NO;
}

- (void)dismissShowChooseView
{
    showChooseView.hidden = YES;
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
    [backButton setFrame:CGRectMake(10, 10, 12, 20)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(280, 10, 19, 26)];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share-icon.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tabbar
    tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-49-KADHEIGHT, kScreen_Width, 49)];
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
    shapeChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 82)];
    shapeChooseView.backgroundColor = colorWithHexString(@"#ededed");
    [showChooseView insertSubview:shapeChooseView atIndex:0];
    
    UIView *groupBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, shapeChooseView.frame.size.width, 30)];
    groupBackView.tag = 10;
    [shapeChooseView addSubview:groupBackView];
    
    NSArray *groupNameArray = [NSArray arrayWithObjects:@"shape", @"love", @"flower", @"nature", @"grocery",nil];
    
    for (int i = 0; i < [groupNameArray count]; i ++)
    {
        UIButton *chooseGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseGroupButton setFrame:CGRectMake((groupBackView.frame.size.width/groupNameArray.count)*i, 0, groupBackView.frame.size.width/groupNameArray.count, 30)];
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
        [groupBackView addSubview:chooseGroupButton];
    }
    
    shapeChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 52)];
    shapeChooseScrollView.contentSize = CGSizeMake(46 * [shapeMulArray count], 52);
    shapeChooseScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    shapeChooseScrollView.showsHorizontalScrollIndicator = NO;
    shapeChooseScrollView.showsVerticalScrollIndicator = NO;
    [shapeChooseView addSubview:shapeChooseScrollView];
    
    shapeSelectedView = [[UIImageView alloc]initWithFrame:CGRectZero];
    shapeSelectedView.layer.borderColor = colorWithHexString(@"#636363").CGColor;
    shapeSelectedView.layer.borderWidth = 2;
    
    for (int i = 0; i < [shapeMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseShapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseShapeButton setFrame:CGRectMake(6*(i+1)+40*i, 6, 40, 40)];
            [chooseShapeButton addTarget:self action:@selector(chooseShapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseShapeButton setBackgroundImage:[UIImage imageWithContentsOfFile:[shapeMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            if (i == 0)
            {
                shapeSelectedView.frame = chooseShapeButton.frame;
            }
            chooseShapeButton.tag = i + 10;
            [shapeChooseScrollView insertSubview:chooseShapeButton atIndex:0];
        }
    }
    [shapeChooseScrollView addSubview:shapeSelectedView];
}

-(void)chooseShapeButtonPressed:(id)sender
{
    //选择哪个图形
    UIButton *tempButton = (UIButton *)sender;
    
    shapeSelectedView.frame = tempButton.frame;
    shapeSelectedView.hidden = NO;
    
    shapeSelectedGroup = shapeGroupName;
    
    NSString *tempStr = [NSString stringWithFormat:@"edit_shape_category%d_%d",[self getGroupNum],tempButton.tag - 10];
    [self sendMessage:tempStr and:@"edit_shape"];
    
    NSString *pathStr = [shapeMulArray objectAtIndex:tempButton.tag - 10];
    topImage.image = getImageFromDirectory([[pathStr lastPathComponent] stringByDeletingPathExtension] , [NSString stringWithFormat:@"Max_%@",shapeGroupName]);
    
    
//    topImage.image = [UIImage imageWithContentsOfFile:pathStr];
    
    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
}

- (void)chooseGroupButtonPressed:(id)sender
{
    
    //选择哪个组
    UIView *tempView = [shapeChooseView viewWithTag:10];
    for (UIButton *tempBtn in tempView.subviews)
    {
        tempBtn.selected = NO;
    }
    
    UIButton *tempButton = (UIButton *)sender;
    tempButton.selected = YES;
    
    [shapeMulArray removeAllObjects];
    
    
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
    
    NSString *tempStr = [NSString stringWithFormat:@"edit_shape_category%d",[self getGroupNum]];
    [self sendMessage:tempStr and:@"edit_shape"];
    
    shapeMulArray = [getImagesArray(shapeGroupName,@"png") mutableCopy];
    
    for (UIView *tempView in shapeChooseScrollView.subviews)
    {
        if ([tempView isKindOfClass:[UIButton class]])
        {
            [tempView removeFromSuperview];
        }
    }
    
    shapeChooseScrollView.contentSize = CGSizeMake(46 * [shapeMulArray count], 52);
    shapeChooseScrollView.contentOffset = CGPointMake(0, 0);
    for (int i = 0; i < [shapeMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseShapeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseShapeButton setFrame:CGRectMake(6*(i+1)+40*i, 6, 40, 40)];
            [chooseShapeButton addTarget:self action:@selector(chooseShapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseShapeButton setBackgroundImage:[UIImage imageWithContentsOfFile:[shapeMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            chooseShapeButton.tag = i + 10;
            [shapeChooseScrollView insertSubview:chooseShapeButton atIndex:0];
        }
    }
    
    
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
    backGroundChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 82)];
    backGroundChooseView.backgroundColor = colorWithHexString(@"#ededed");
    
    backGroundSelectedView = [[UIImageView alloc]initWithFrame:CGRectZero];
    backGroundSelectedView.layer.borderColor = colorWithHexString(@"#636363").CGColor;
    backGroundSelectedView.layer.borderWidth = 2;
    
    NSArray *typeNameArray = [NSArray arrayWithObjects:@"颜色", @"图案", @"透明度", nil];
    
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
    [alphaSlider setValue:0.7f];
    [alphaSlider setMinimumValue:0.0f];
    [alphaSlider setMaximumValue:1.0f];
    [alphaSliderView addSubview:alphaSlider];
    
    valuePercentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 16, 46, 20)];
    valuePercentLabel.textAlignment = NSTextAlignmentCenter;
    valuePercentLabel.text = [NSString stringWithFormat:@"%d%%",(int)((1-alphaSlider.value/alphaSlider.maximumValue)*100)];
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
            [self sendMessage:@"edit_background_color" and:@"edit_background"];
            [backGroundChooseView addSubview:colorChooseScrollView];
            break;
        case 2:
            ;
            //友盟统计
            [self sendMessage:@"edit_background_pattern" and:@"edit_background"];
            [backGroundChooseView addSubview:graphChooseScrollView];
            break;
//        case 3:
//            ;
//            [backGroundChooseView addSubview:blurSlider];
//            break;
        case 3:
            ;
            //友盟统计
            [self sendMessage:@"edit_background_opacity" and:@"edit_background"];
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
    [self sendMessage:tempStr and:@"edit_background_color"];
    
    if (![colorChooseScrollView.subviews containsObject:backGroundSelectedView])
    {
        [backGroundSelectedView removeFromSuperview];
        [colorChooseScrollView addSubview:backGroundSelectedView];
    }
    backGroundSelectedView.frame = tempButton.frame;
    
    UIView *tempView = [[UIView alloc]initWithFrame:showView.showImageView.frame];
    
    tempView.backgroundColor = colorWithHexString([colorMulArray objectAtIndex:tempButton.tag - 10]);

    bottomImage.image = [UIImage getImageFromView:tempView];
    
//    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:blurSlider.value];
    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
}

- (void)chooseGraphButtonPressed:(id)sender
{
    //选择哪个图案
    UIButton *tempButton = (UIButton *)sender;
    //友盟统计
    
    NSString *tempStr = [NSString stringWithFormat:@"edit_background_pattern_%d",tempButton.tag-10];
    [self sendMessage:tempStr and:@"edit_background_pattern"];
    
    if (![graphChooseScrollView.subviews containsObject:backGroundSelectedView])
    {
        [backGroundSelectedView removeFromSuperview];
        [graphChooseScrollView addSubview:backGroundSelectedView];
    }

    backGroundSelectedView.frame = tempButton.frame;
    
    bottomImage.image = [self getGraphImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[graphMulArray objectAtIndex:tempButton.tag - 10]]]];
    
//    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:blurSlider.value];
    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
}

- (UIImage *)getGraphImage:(UIImage *)image
{
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1080, 1080)];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    UIGraphicsBeginImageContext(tempView.bounds.size);
    
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
    
    shapeImage.alpha = tempslider.value;
    
    valuePercentLabel.text = [NSString stringWithFormat:@"%d%%",(int)((1-tempslider.value/alphaSlider.maximumValue)*100)];
}

#pragma mark - 初始化滤镜选择view

- (void)initFilterChooseView
{
    filterChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, kScreen_Width, 52)];
    
    filterSelectedView = [[UIImageView alloc]initWithFrame:CGRectZero];
    filterSelectedView.layer.borderColor = colorWithHexString(@"#636363").CGColor;
    filterSelectedView.layer.borderWidth = 2;
    
    UIScrollView *filterChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 52)];
    filterChooseScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"形状背景带上下细线.png"]];
    filterChooseScrollView.contentSize = CGSizeMake(45*[filterMulArray count], 52);
    [filterChooseView addSubview:filterChooseScrollView];
    
//    NSArray *itemTitles = @[@"Origin", @"Lomo", @"Sunset",
//                            @"Warm", @"Ice", @"Grayscale",
//                            @"Blues", @"Shadows", @"Yesterday",
//                            @"Glow", @"B/W", @"Pencil",
//                            @"Chroma", @"Neon", @"Pinhole"];
    
    for (int i = 0; i < [filterMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chooseFilterButton setFrame:CGRectMake(6*(i+1)+40*i, 6, 40, 40)];
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
    filterSelectedView.frame = tempButton.frame;
    NSString *tempStr = [NSString stringWithFormat:@"edit_filter_%d",tempButton.tag-10];
    [self sendMessage:tempStr and:@"edit_filter"];
    filterSelectedView.frame = tempButton.frame;
    
    [showView.filterView switchFilter:tempButton.tag-10];
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"照片未保存，是否返回" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
        [alert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1)
    {
        return;
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
    
    CGSize bottomSize = CGSizeMake(CGImageGetWidth(filterMaxImage.CGImage), CGImageGetHeight(filterMaxImage.CGImage));
    
    UIImage *passImage = [UIImage getEditFinishedImageWithView:backView];
    
    if (shareContrller == nil)
    {
        shareContrller = [[PHO_ShareViewController alloc]initWithImage:passImage];
    }
    
    [self.navigationController pushViewController:shareContrller animated:YES];
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
