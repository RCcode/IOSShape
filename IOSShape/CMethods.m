//
//  CMethods.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "CMethods.h"
#import <stdlib.h>
#import <time.h>

@implementation CMethods

//window 高度
CGFloat windowHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

//statusBar隐藏与否的高
CGFloat heightWithStatusBar(){
    return NO==[UIApplication sharedApplication].statusBarHidden ? windowHeight()-20 :windowHeight();
}

//view 高度
CGFloat viewHeight(UIViewController *viewController){
    if (nil==viewController) {
        return heightWithStatusBar();
    }
    return YES==viewController.navigationController.navigationBarHidden ? heightWithStatusBar():heightWithStatusBar()-44;
    
}

NSArray* getImagesArray(NSString *folderName, NSString *type)
{
    NSArray *returnArray = [[NSBundle mainBundle]pathsForResourcesOfType:type inDirectory:folderName];
    return returnArray;
}

UIImage* getImageFromDirectory(NSString *imageName, NSString *folderName)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png" inDirectory:folderName];
    UIImage *returnImage = [UIImage imageWithContentsOfFile:path];
    return returnImage;
}

UIImage* pngImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

UIImage* jpgImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

NSString* stringForInteger(int value)
{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    return str;
}


//當前语言环境
NSString* currentLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *languangeType;
    NSString* preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hant"]){
        languangeType=@"ft";
    }else{
        languangeType=@"jt";
    }
    NSLog(@"Preferred Language:%@", preferredLang);
    return languangeType;
}

//BOOL iPhone5(){
//    if (568==windowHeight()) {
//        return YES;
//    }
//    return NO;
//}

BOOL IOS7_Or_Higher(){
    return [[UIDevice currentDevice].systemVersion floatValue] >= 7.0 ? YES : NO;
}

//数学意义上的随机数在计算机上已被证明不可能实现。通常的随机数是使用随机数发生器在一个有限大的线性空间里取一个数。“随机”甚至不能保证数字的出现是无规律的。使用系统时间作为随机数发生器是常见的选择
NSMutableArray* randrom(int count,int totalCount){
    int x;
    int i;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    time_t t;
    srand((unsigned) time(&t));
    for(i=0; i<count; i++){
        x=rand() % totalCount;
        printf("%d ", x);
        [array addObject:[NSString stringWithFormat:@"%d",x]];
    }
    printf("\n");
    return array;
}

UIColor* colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

NSData* toJSONData(id theData)
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] != 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

MBProgressHUD *mb;
MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView)
{
    //显示LoadView
    if (mb==nil) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        mb = [[MBProgressHUD alloc] initWithView:window];
        mb.mode = showView?MBProgressHUDModeDeterminate:MBProgressHUDModeText;
        [window addSubview:mb];
        //如果设置此属性则当前的view置于后台
        //mb.dimBackground = YES;
        mb.labelText = content;
    }else{
        mb.mode = showView?MBProgressHUDModeDeterminate:MBProgressHUDModeText;
        mb.labelText = content;
    }
    [mb show:YES];
    return mb;
}

void hideMBProgressHUD()
{
    [mb hide:YES];
}

NSString *exchangeTime(NSString *time)
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSInteger timeValues = [time integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeValues];
    NSString *dataStr = [formatter stringFromDate:confromTimesp];
    return dataStr;
}

@end