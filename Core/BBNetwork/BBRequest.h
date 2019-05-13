//
//  BBRequest.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/25.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "BBNetConfig.h"

//请求类型
typedef NS_ENUM(NSUInteger, BBRequestMethod) {
    BBRequestMethodGET,
    BBRequestMethodPOST,
    BBRequestMethodHead,
    BBRequestMethodPut,
    BBRequestMethodDelete,
    BBRequestMethodPatch,
};

//****** 请求类 ********//

@interface BBRequest : NSObject

@property (nonatomic, assign) BBRequestMethod requestMethod;

@property (nonatomic, strong) NSString *requestUrl;

@property (nonatomic, strong) id parameters;

@property (nonatomic, copy) void (^progress)(NSProgress *);

@property (nonatomic, copy) void (^filedata)(id <AFMultipartFormData> formData);


////////////////////////////////////////自定义配置/////////////////////////////////////
@property (nonatomic, strong) BBNetConfig *config;

////////////////////////////////////////创建请求实例/////////////////////////////////////
//默认为POST请求
- (instancetype)init;

- (instancetype)initWithMetod:(BBRequestMethod)method NS_DESIGNATED_INITIALIZER;

#pragma mark - POST

+ (instancetype)post:(NSString *)urlStr parameters:(id)param;

+ (instancetype)post:(NSString *)urlStr parameters:(id)param progress:(void (^)(NSProgress *uploadProgress))uploadProgress;


+ (instancetype)post:(NSString *)urlStr parameters:(id)param filedata:(void (^)(id <AFMultipartFormData> formData))block;


+ (instancetype)post:(NSString *)urlStr parameters:(id)param filedata:(void (^)(id <AFMultipartFormData> formData))block progress:(void (^)(NSProgress *uploadProgress))uploadProgress;

#pragma mark - GET

+ (instancetype)get:(NSString *)urlStr parameters:(id)param;

+ (instancetype)get:(NSString *)urlStr parameters:(id)param progress:(void (^)(NSProgress *uploadProgress))downloadProgress;

@end
