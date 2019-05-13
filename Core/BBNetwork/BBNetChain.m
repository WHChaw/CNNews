//
//  BBNetChain.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/6/1.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBNetChain.h"


@interface BBNetChain ()

@property (nonatomic, strong) BBNetTask *netTask;

@property (nonatomic, strong) BBRequest *request;

@property (nonatomic, copy) BBRequestCompletion completionBlock;

@end

@implementation BBNetChain

+ (BBNetChain *)request {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.request = [[BBRequest alloc] init];
    }
    return self;
}

- (void)startTaskWithRequest:(BBRequest *)request {
    
   
    self.netTask = [[BBNetTask alloc] init];
    
    [self.netTask startWithRequest:request completion:self.completionBlock];
}


- (BBNetTask * (^)())post {
    
    return ^ BBNetTask *() {
        self.request.requestMethod = BBRequestMethodPOST;
        
        [self startTaskWithRequest:self.request];
        return self.netTask;
    };
}

- (BBNetTask * (^)())get {
    
    return ^ BBNetTask *() {
        self.request.requestMethod = BBRequestMethodGET;
        
        [self startTaskWithRequest:self.request];
        return self.netTask;
    };
}

- (BBNetTask * (^)())head {
    
    return ^BBNetTask *() {
        self.request.requestMethod = BBRequestMethodHead;
        
        [self startTaskWithRequest:self.request];
        return self.netTask;
    };
}

- (BBNetTask * (^)())put {
    
    return ^ BBNetTask *() {
        self.request.requestMethod = BBRequestMethodPut;
        
        [self startTaskWithRequest:self.request];
        return self.netTask;
    };
}

- (BBNetTask * (^)())del {
    
    return ^ BBNetTask *() {
        self.request.requestMethod = BBRequestMethodDelete;
        
        [self startTaskWithRequest:self.request];
        return self.netTask;
    };
}

- (BBNetTask * (^)())patch {
    
    return ^ BBNetTask *() {
        self.request.requestMethod = BBRequestMethodPatch;
        
        [self startTaskWithRequest:self.request];
        return self.netTask;
    };
}

- (BBNetChain *(^)(NSString *))urlPath {
    
    return ^ BBNetChain * (NSString *url) {
        self.request.requestUrl = url;
        return self;
    };
}

- (BBNetChain *(^)(id))parameters {
    
    return ^ BBNetChain * (id obj) {
        self.request.parameters = obj;
        return self;
    };
}


- (BBNetChain *(^)(void (^)(NSProgress *)))progress {
    
    return ^ BBNetChain * (void (^requestProgress)(NSProgress *)) {
        self.request.progress = requestProgress;
        return self;
    };
}

- (BBNetChain *(^)(BBNetConfig *))config {
    
    return ^ BBNetChain * (BBNetConfig *requestConfig) {
        self.request.config = requestConfig;
        return self;
    };
}

- (BBNetChain * (^)(void (^)(id<AFMultipartFormData>)))fileData {
    
    return ^ BBNetChain * (void (^uploadBlock)(id<AFMultipartFormData>)) {
        self.request.filedata = uploadBlock;
        return self;
    };
}

- (BBNetChain * (^)(BBRequestCompletion))completion {
    
    return ^ BBNetChain *(BBRequestCompletion completionBlock) {
        self.completionBlock = completionBlock;
        return self;
    };
}

@end
