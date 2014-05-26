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

#import "ColorMatrix.h"

#import "ImageUtil.h"

#import "PHO_ShareViewController.h"


#define KRECT_SHOWCHOOSEVIEW (iPhone5 ? CGRectMake(0, kScreen_Height-50-60-KADHEIGHT, kScreen_Width, 60):CGRectMake(0, kScreen_Height-60-KADHEIGHT, kScreen_Width, 60))

@interface PHO_MainViewController ()

@end

@implementation PHO_MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, TOPORIGIN_Y + 44, 320, 320)];
        //        backView.backgroundColor = [UIColor clearColor];
        backView.layer.masksToBounds = YES;
        [self.view addSubview:backView];
        
        showView = [[PHO_MainShowView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
        [showView getPicture:image];
        [backView addSubview:showView];
        
        shapeImage = [[UIImageView alloc]initWithFrame:backView.frame];
        topImage = [[UIImageView alloc]initWithFrame:backView.frame];
        bottomImage = [[UIImageView alloc]initWithFrame:backView.frame];
        backRealImage = [[UIImage alloc]init];
        
        topImage.image = [UIImage imageNamed:@"Max_shape-1.png"];
        bottomImage.image = [UIImage imageNamed:@"color-1.png"];
        
        shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
        backRealImage = showView.showImageView.image;
        //        topImage.image = shapeImage.image;
        //        bottomImage.image = [UIImage imageNamed:@"33.png"];
        //        bottomImage.alpha = 0.5f;
        //        shapeImage.alpha = 1;
        [self.view addSubview:shapeImage];
        
        shapeMulArray = [[NSMutableArray alloc]init];
        colorMulArray = [[NSMutableArray alloc]init];
        graphMulArray = [[NSMutableArray alloc]init];
        filterMulArray = [[NSMutableArray alloc]init];
        
        
        NSMutableArray *paths = [[[NSBundle mainBundle]
                                  pathsForResourcesOfType:@"png" inDirectory:nil] mutableCopy];
        for (NSString *path in paths)
        {
            if ([[path lastPathComponent]hasPrefix:@"shape-"] &&
                ![[path lastPathComponent]hasSuffix:@"_Max@2x.png"])
            {
                [shapeMulArray addObject:[path lastPathComponent]];
            }
            else if ([[path lastPathComponent] hasPrefix:@"color-"] &&
                     ![[path lastPathComponent]hasSuffix:@"_Max"])
            {
                [colorMulArray addObject:[path lastPathComponent]];
            }
            else if ([[path lastPathComponent] hasPrefix:@"graph-"] &&
                     ![[path lastPathComponent]hasSuffix:@"_Max"])
            {
                [graphMulArray addObject:[path lastPathComponent]];
            }
        }
        
        showChooseView = [[UIView alloc]initWithFrame:KRECT_SHOWCHOOSEVIEW];
        showChooseView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:showChooseView];
        
        if (!iPhone5)
        {
            UIButton *hideShowChooseViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [hideShowChooseViewButton setFrame:CGRectMake(showChooseView.frame.size.width-40, 0, 40, 40)];
            hideShowChooseViewButton.backgroundColor = [UIColor redColor];
            [hideShowChooseViewButton addTarget:self action:@selector(hideShowChooseViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [showChooseView addSubview:hideShowChooseViewButton];
            
        }

        [self initShapeChooseView];

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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:CGRectMake(10, 10, 20, 20)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton setFrame:CGRectMake(280, 10, 20, 20)];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //tabbar
    UIView *tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreen_Height-50-KADHEIGHT, kScreen_Width, 50)];
    tabbarView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:tabbarView];
    
    UIButton *shapeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shapeButton setFrame:CGRectMake(0, 0, tabbarView.frame.size.width/3, tabbarView.frame.size.height)];
    [shapeButton addTarget:self action:@selector(shapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shapeButton setTitle:@"图形" forState:UIControlStateNormal];
    [tabbarView addSubview:shapeButton];
    
    UIButton *backGroundButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backGroundButton setFrame:CGRectMake(tabbarView.frame.size.width/3, 0, tabbarView.frame.size.width/3, tabbarView.frame.size.height)];
    [backGroundButton addTarget:self action:@selector(backGroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundButton setTitle:@"颜色图案" forState:UIControlStateNormal];
    [tabbarView addSubview:backGroundButton];
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [filterButton setFrame:CGRectMake(tabbarView.frame.size.width/3*2, 0, tabbarView.frame.size.width/3, tabbarView.frame.size.height)];
    [filterButton addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    [tabbarView addSubview:filterButton];
    
    // Do any additional setup after loading the view.
}
//隐藏选择view
- (void)hideShowChooseViewButtonPressed:(id)sender
{
    if (!showChooseView.hidden)
    {
        showChooseView.hidden = YES;
    }
}

#pragma mark 初始化图形选择view

- (void)initShapeChooseView
{
    shapeChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    shapeChooseView.backgroundColor = [UIColor clearColor];
    [showChooseView insertSubview:shapeChooseView atIndex:0];
    
    UIScrollView *shapeChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 45)];
    shapeChooseScrollView.contentSize = CGSizeMake(45 * [shapeMulArray count], 40);
    shapeChooseScrollView.backgroundColor = [UIColor grayColor];
    [shapeChooseView addSubview:shapeChooseScrollView];
    
    for (int i = 0; i < [shapeMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseShapeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [chooseShapeButton setFrame:CGRectMake(5*(i+1)+40*i, 2, 40, 40)];
            [chooseShapeButton addTarget:self action:@selector(chooseShapeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseShapeButton setBackgroundImage:[UIImage imageNamed:[shapeMulArray objectAtIndex:i]] forState:UIControlStateNormal];
//            [chooseShapeButton setBackgroundColor:[UIColor whiteColor]];
            chooseShapeButton.layer.borderColor = [UIColor grayColor].CGColor;
            chooseShapeButton.layer.borderWidth = 1;
            chooseShapeButton.tag = i + 10;
            [shapeChooseScrollView addSubview:chooseShapeButton];
        }
    }
}

-(void)chooseShapeButtonPressed:(id)sender
{
    //选择哪个图形
    UIButton *tempButton = (UIButton *)sender;
//    shapeImage.image = [shapeMulArray objectAtIndex:tempButton.tag - 10];
//    realImage = [shapeMulArray objectAtIndex:tempButton.tag - 10];
    
    topImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Max_%@",[shapeMulArray objectAtIndex:tempButton.tag - 10]]];
    
    shapeImage.image = [UIImage shapeMakeWithBottomImage:bottomImage.image andTopImage:topImage.image];
}

#pragma mark 初始化背景选择view

- (void)initBackGroundView
{
    backGroundChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    backGroundChooseView.backgroundColor = [UIColor clearColor];
    
    NSArray *typeNameArray = [NSArray arrayWithObjects:@"颜色", @"图案", @"模糊", @"透明度", nil];
    
    for (int i = 0; i < 4; i ++)
    {
        @autoreleasepool
        {
            UIButton *chooseTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [chooseTypeButton setFrame:CGRectMake(4*(i+1)+75*i, 1, 75, 18)];
            [chooseTypeButton setTitle:[typeNameArray objectAtIndex:i] forState:UIControlStateNormal];
            [chooseTypeButton addTarget:self action:@selector(chooseTypeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseTypeButton setTag:i+1];
            [backGroundChooseView addSubview:chooseTypeButton];
            
        }
    }
    
    colorChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, 40)];
    [colorChooseScrollView setContentSize:CGSizeMake(320*([colorMulArray count]/7+1), 40)];
    for (int i = 0; i < [colorMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseColorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [chooseColorButton setFrame:CGRectMake(5*(i+1)+40*i, 2, 40, 36)];
            [chooseColorButton addTarget:self action:@selector(chooseColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseColorButton setBackgroundImage:[UIImage imageNamed:[colorMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            chooseColorButton.tag = i + 10;
            [colorChooseScrollView addSubview:chooseColorButton];
        }
    }
    [backGroundChooseView addSubview:colorChooseScrollView];
    
    graphChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width, 40)];
    [graphChooseScrollView setContentSize:CGSizeMake(45 * [graphMulArray count], 40)];
    for (int i = 0; i < [graphMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseGraphButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [chooseGraphButton setFrame:CGRectMake(5*(i+1)+40*i, 2, 40, 36)];
            [chooseGraphButton addTarget:self action:@selector(chooseGraphButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseGraphButton setBackgroundImage:[UIImage imageNamed:[graphMulArray objectAtIndex:i]] forState:UIControlStateNormal];
            chooseGraphButton.tag = i + 10;
            [graphChooseScrollView addSubview:chooseGraphButton];
        }
    }
    
    CGRect sliderRect = CGRectMake(40, 40, 240, 10);
    
    
    blurSlider = [[UISlider alloc]initWithFrame:sliderRect];
    [blurSlider addTarget:self action:@selector(blurSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [blurSlider setValue:0.0f];
    [blurSlider setMinimumValue:0.0f];
    [blurSlider setMaximumValue:1.5f];
    
    
    alphaSlider = [[UISlider alloc]initWithFrame:sliderRect];
    [alphaSlider addTarget:self action:@selector(alphaSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [alphaSlider setValue:1.0f];
    [alphaSlider setMinimumValue:0.0f];
    [alphaSlider setMaximumValue:1.0f];
}

- (void)chooseTypeButtonPressed:(id)sender
{
    //选择哪种类型处理
    
    UIView *tempView = [backGroundChooseView.subviews lastObject];
    [tempView removeFromSuperview];
    
    UIButton *tempButton = (UIButton *)sender;
    NSInteger tag = tempButton.tag;
    switch (tag)
    {
        case 1:
            ;
            [backGroundChooseView addSubview:colorChooseScrollView];
            break;
        case 2:
            ;
            [backGroundChooseView addSubview:graphChooseScrollView];
            break;
        case 3:
            ;
            [backGroundChooseView addSubview:blurSlider];
            break;
        case 4:
            ;
            [backGroundChooseView addSubview:alphaSlider];
            break;

        default:
            break;
    }
    
}

- (void)chooseColorButtonPressed:(id)sender
{
    //选择哪个颜色
    UIButton *tempButton = (UIButton *)sender;
    
    UIView *tempView = [[UIView alloc]initWithFrame:showView.showImageView.frame];
    
    tempView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[colorMulArray objectAtIndex:tempButton.tag - 10]]];

    bottomImage.image = [UIImage getImageFromView:tempView];
    
    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:blurSlider.value];
}

- (void)chooseGraphButtonPressed:(id)sender
{
    //选择哪个图案
    UIButton *tempButton = (UIButton *)sender;
    
    bottomImage.image = [self getGraphImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[graphMulArray objectAtIndex:tempButton.tag - 10]]]];
    
    shapeImage.image = [UIImage blurryBottomImage:bottomImage.image andTopImage:topImage.image withBlurLevel:blurSlider.value];
}

- (UIImage *)getGraphImage:(UIImage *)image
{
    UIView *tempView = [[UIView alloc]initWithFrame:showView.showImageView.frame];
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
}

#pragma mark - 初始化滤镜选择view

- (void)initFilterChooseView
{
    filterChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    filterChooseView.backgroundColor = [UIColor clearColor];
    
    UIScrollView *filterChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width, 45)];
    filterChooseScrollView.backgroundColor = [UIColor grayColor];
    filterChooseScrollView.contentSize = CGSizeMake(45*[filterMulArray count], 40);
    [filterChooseView addSubview:filterChooseScrollView];
    
    for (int i = 0; i < [filterMulArray count]; i ++)
    {
        @autoreleasepool {
            UIButton *chooseFilterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [chooseFilterButton setFrame:CGRectMake(5*(i+1)+40*i, 2, 40, 40)];
            [chooseFilterButton addTarget:self action:@selector(chooseFilterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [chooseFilterButton setBackgroundImage:[filterMulArray objectAtIndex:i] forState:UIControlStateNormal];
//            [chooseFilterButton setTitle:[filterMulArray objectAtIndex:i] forState:UIControlStateNormal];
            chooseFilterButton.tag = i + 10;
            [filterChooseScrollView addSubview:chooseFilterButton];
        }
    }

}

- (void)chooseFilterButtonPressed:(id)sender
{
    //选择滤镜效果
    UIButton *tempButton = (UIButton *)sender;
    showView.showImageView.image = [ImageUtil imageWithImage:backRealImage withColorMatrix:filterTyeps[tempButton.tag - 10]];
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
    [self.navigationController popViewControllerAnimated:YES];
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
    UIImage *tempImage = [UIImage getImageFromView:backView];
    UIImage *passImage = [UIImage lastImageMakeWithBottomImage:tempImage andTopImage:shapeImage.image andAlpha:shapeImage.alpha];
    PHO_ShareViewController *shareContrller = [[PHO_ShareViewController alloc]initWithImage:passImage];
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
    
    if (![showChooseView.subviews containsObject:shapeChooseView])
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
    
    if ([filterMulArray count] == 0)
    {
        for (int i = 0; i < sizeof(filterTyeps)/sizeof(float *); i++)
        {
            [filterMulArray addObject:[ImageUtil imageWithImage:[backRealImage rescaleImageToSize:CGSizeMake(200, 200)] withColorMatrix:filterTyeps[i]]];
        }
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
