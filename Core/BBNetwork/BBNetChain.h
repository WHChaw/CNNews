//
//  BBNetChain.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/6/1.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBNetConfig.h"
#import "BBRequest.h"
#import "BBNetTask.h"
#import "BBNetResponse.h"

@interface BBNetChain <JsonObject>: NSObject

@property (class, readonly) BBNetChain *request;

//post方法
- (BBNetTask * (^)())post;
//get方法
- (BBNetTask * (^)())get;
//head方法
- (BBNetTask * (^)())head;
//put方法
- (BBNetTask * (^)())put;
//delete方法
- (BBNetTask * (^)())del;
//patch方法
- (BBNetTask * (^)())patch;


//请求URL路径
- (BBNetChain * (^)(NSString *))urlPath;
//请求参数
- (BBNetChain * (^)(JsonObject))parameters;
//请求进度回调
- (BBNetChain * (^)(void (^)(NSProgress *)))progress;
//文件上传
- (BBNetChain * (^)(void (^)(id <AFMultipartFormData> formData)))fileData;
//自定义配置
- (BBNetChain * (^)(BBNetConfig *))config;
//请求回调
- (BBNetChain * (^)(BBRequestCompletion))completion;

@end
