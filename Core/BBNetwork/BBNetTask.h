//
//  BBNetTask.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBRequest.h"
#import "BBNetResponse.h"

//请求回调
typedef void (^BBRequestCompletion)(BBNetResponse *response);


@interface BBNetTask : NSObject

@property (nonatomic, strong) BBRequest *request;

@property (nonatomic, strong) BBNetResponse *response;

@property (nonatomic, copy) BBRequestCompletion completionBlock;

@property (nonatomic, strong) NSURLSessionTask *sessionTask;

- (void)startWithRequest:(BBRequest *)request;

- (void)startWithRequest:(BBRequest *)request
              completion:(BBRequestCompletion)completionBlock;

- (void)stop;

@end
