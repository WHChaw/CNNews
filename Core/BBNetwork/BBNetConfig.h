//
//  BBNetConfig.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface BBNetConfig : NSObject

//便利初始化方法
+ (instancetype)configWithBaseURL:(NSString *)baseurl;
//初始化方法
- (instancetype)initWithBaseURL:(NSString *)baseurl NS_DESIGNATED_INITIALIZER;

//服务器访问地址
@property (nonatomic, strong) NSString *baseUrl;
//session配置
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
//安全策略
@property (nonatomic, strong) AFSecurityPolicy *policy;
//请求序列化配置
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
//响应序列化配置
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

//公共参数
@property (nonatomic, strong) NSDictionary *publicParameters;

@end
