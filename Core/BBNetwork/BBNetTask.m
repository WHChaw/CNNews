//
//  BBNetTask.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBNetTask.h"
#import "BBNetManager.h"


@implementation BBNetTask

- (void)startWithRequest:(BBRequest *)request {
    [self startWithRequest:request completion:nil];
}

- (void)startWithRequest:(BBRequest *)request completion:(BBRequestCompletion)completionBlock {
    
    [self setupRequestParameters:request];
    self.request = request;
    self.completionBlock = completionBlock;
    [[BBNetManager sharedManager] appendTask:self];
    
}

- (void)stop {
    [[BBNetManager sharedManager] cancelTask:self];
}


- (void)setupRequestParameters:(BBRequest *)request {
    
    if (request.parameters && [request.parameters isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
        if (request.config) {
            [dict addEntriesFromDictionary:request.config.publicParameters];
        } else if ([BBNetManager sharedManager].config.publicParameters) {
            [dict addEntriesFromDictionary:[BBNetManager sharedManager].config.publicParameters];
        }
        
        request.parameters = dict;
    } else {
        if (request.config) {
            request.parameters = request.config.publicParameters;
        } else if ([BBNetManager sharedManager].config.publicParameters) {
           request.parameters = [BBNetManager sharedManager].config.publicParameters;
        }
    }
    
}

@end
