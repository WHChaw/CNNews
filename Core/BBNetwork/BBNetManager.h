//
//  BBNetManager.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBNetTask.h"


FOUNDATION_EXPORT NSString *const BBNetworkErrorDomain;

//请求回调代理
@protocol NetTaskDelegate <NSObject>

@optional

//是否开始任务
- (BOOL)taskShouldStart:(BBNetTask *)task;

//是否结束任务
- (BOOL)taskShouldEnd:(BBNetTask *)task;

//可以在此代理方法中做一些请求前的准备工作，例如对请求报文进行加密
- (BBRequest *)taskWillStart:(BBNetTask *)task;

- (void)taskWillEnd:(BBNetTask *)task;

- (void)taskDidEnd:(BBNetTask *)task;

- (void)taskWillCancel:(BBNetTask *)task;

- (void)taskDidCancel:(BBNetTask *)task;

@end


@interface BBNetManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong) BBNetConfig *config;

//设置回调代理类
- (void)setNetTaskDelegate:(id <NetTaskDelegate>)delegate;

//添加请求任务
- (void)appendTask:(BBNetTask *)task;

//取消请求任务
- (void)cancelTask:(BBNetTask *)task;

//取消所有请求
- (void)cancelAllTasks;

@end
