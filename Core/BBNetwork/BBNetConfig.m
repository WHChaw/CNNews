//
//  BBNetConfig.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBNetConfig.h"
#import "BBNetManager.h"

@implementation BBNetConfig

+ (instancetype)configWithBaseURL:(NSString *)baseurl {
    
    return [[self alloc] initWithBaseURL:baseurl];
}

- (instancetype)init
{
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSString *)baseurl {
    self = [super init];
    if (self) {
        self.baseUrl = baseurl;
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.policy = [AFSecurityPolicy defaultPolicy];
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

@end
