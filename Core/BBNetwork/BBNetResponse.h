//
//  BBNetResponse.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBRequest;
//****** 响应类 ********//

@interface BBNetResponse : NSObject
//请求实体
@property (nonatomic, weak) BBRequest *request;
//URLSessionTask
@property (nonatomic, strong) NSURLSessionTask *sessionTask;
//响应报文
@property (nonatomic, strong) id responseObject;
//响应状态码，成功一般为200
@property (nonatomic, assign) NSUInteger responseCode;
//错误信息
@property (nonatomic, strong) NSError *error;

//检查响应报文是否成功并且有效
- (BOOL)responseValid;

@end
