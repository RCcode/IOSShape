//
//  PHO_DataRequest.h
//  IOSShape
//
//  Created by wsq-wlq on 14-6-4.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "PRJ_ProtocolClass.h"

@interface PHO_DataRequest : UIViewController
{
    NSInteger requestTag;
}
@property (nonatomic ,assign) id <WebRequestDelegate,DownLoadTypeFaceDelegate> delegate;
@property (nonatomic ,strong) NSDictionary *valuesDictionary;//post的数据
@property (nonatomic ,strong) UIProgressView *progressView;

- (id)initWithDelegate:(id<WebRequestDelegate>)request_Delegate;

//注册设备信息
- (void)registerToken:(NSDictionary *)dictionary withTag:(NSInteger)tag;
//版本更新
- (void)updateVersion:(NSString *)url withTag:(NSInteger)tag;
//moreapp
- (void)moreApp:(NSDictionary *)dictionary withTag:(NSInteger)tag;

@end
