//
//  BBRequest.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/25.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBRequest.h"

@implementation BBRequest

- (instancetype)initWithMetod:(BBRequestMethod)method {
    self = [super init];
    if (self) {
        self.requestMethod = method;
    }
    return self;
}


- (instancetype)init
{
    return [self initWithMetod:BBRequestMethodPOST];
}

+ (instancetype)post:(NSString *)urlStr parameters:(id)param
{
    return [self post:urlStr parameters:param filedata:nil progress:nil];
}

+ (instancetype)post:(NSString *)urlStr parameters:(id)param filedata:(void (^)(id<AFMultipartFormData>))block {
    
    return [self post:urlStr parameters:param filedata:nil progress:nil];
}

+ (instancetype)post:(NSString *)urlStr parameters:(id)param progress:(void (^)(NSProgress *))uploadProgress {
    
    return [self post:urlStr parameters:param filedata:nil progress:nil];
    
}

+ (instancetype)post:(NSString *)urlStr parameters:(id)param filedata:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))uploadProgress {
    
    BBRequest *request = [[self alloc] init];
    
    request.requestMethod = BBRequestMethodPOST;
    request.requestUrl = urlStr;
    request.parameters = param;
    request.filedata = block;
    request.progress = uploadProgress;
    
    return request;
}

+ (instancetype)get:(NSString *)urlStr parameters:(id)param {
    
    return [self get:urlStr parameters:param progress:nil];
}

+ (instancetype)get:(NSString *)urlStr parameters:(id)param progress:(void (^)(NSProgress *))downloadProgress {
    
    BBRequest *request = [[self alloc] init];
    
    request.requestMethod = BBRequestMethodPOST;
    request.requestUrl = urlStr;
    request.parameters = param;
    request.progress = downloadProgress;
    
    return request;
}

@end
