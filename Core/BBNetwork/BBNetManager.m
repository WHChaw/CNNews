//
//  BBNetManager.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBNetManager.h"
#import "BBNetResponse.h"
#import "DAThreadSafeMutableDictionary.h"

NSString *const BBNetworkErrorDomain = @"BBNetworkErrorDomain";

@interface BBNetManager () {
    DAThreadSafeMutableDictionary *_netTasks;
}

@property (nonatomic, weak) id <NetTaskDelegate> taskDelegate;

@end

@implementation BBNetManager

+ (instancetype)sharedManager {
    static BBNetManager *netManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[self alloc] init];
    });
    return netManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _netTasks = [DAThreadSafeMutableDictionary dictionary];
        _config = [[BBNetConfig alloc] init];
    }
    return self;
    
}

- (AFHTTPSessionManager *)sessionManagerWithTask:(BBNetTask *)task {
    
    if (!task.request.config) {
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.config.baseUrl] sessionConfiguration:self.config.sessionConfiguration];
        sessionManager.securityPolicy = self.config.policy;
        sessionManager.requestSerializer = self.config.requestSerializer;
        sessionManager.responseSerializer = self.config.responseSerializer;
        return sessionManager;
    } else {
        BBNetConfig *config = task.request.config;
        AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:config.baseUrl] sessionConfiguration:config.sessionConfiguration];
        
        sessionManager.requestSerializer = config.requestSerializer;
        sessionManager.responseSerializer = config.responseSerializer;
        sessionManager.securityPolicy = config.policy;
        
        return sessionManager;
    }
}

- (void)setNetTaskDelegate:(id<NetTaskDelegate>)delegate {
    self.taskDelegate = delegate;
}

#pragma mark - 请求队列控制

- (void)appendTask:(BBNetTask *)task {
    
    if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskWillStart:)]) {
        task.request = [_taskDelegate taskWillStart:task];
    }
    
    if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskShouldStart:)]) {
        BOOL shouldStart = [_taskDelegate taskShouldStart:task];
        if (!shouldStart) {
            return;
        }
        [self addRequest:task];
    } else {
        [self addRequest:task];
    }
}

- (void)cancelTask:(BBNetTask *)task {
    
    if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskWillCancel:)]) {
        [_taskDelegate taskWillCancel:task];
    }
    
    [self cancelRequest:task];
    
    if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskDidCancel:)]) {
        [_taskDelegate taskDidCancel:task];
    }
}

- (void)cancelAllTasks {
    
    NSDictionary *tasks = [_netTasks copy];
    for (NSString *key in tasks.allKeys) {
        BBNetTask *netTask = [_netTasks objectForKey:key];
        [netTask stop];
    }
}

- (void)addRequest:(BBNetTask *)task {
    
    switch (task.request.requestMethod) {
        case BBRequestMethodGET:
            task.sessionTask = [self GETRequest:task];
            break;
        case BBRequestMethodPOST:
            task.sessionTask = [self POSTRequest:task];
            break;
        case BBRequestMethodHead:
            task.sessionTask = [self HEADRequest:task];
            break;
        case BBRequestMethodPut:
            task.sessionTask = [self PUTRequest:task];
            break;
        case BBRequestMethodPatch:
            task.sessionTask = [self PATCHRequest:task];
            break;
        case BBRequestMethodDelete:
            task.sessionTask = [self DELETERequest:task];
            break;
            
        default:
            break;
    }
    
    [self addTask:task];
    
}

- (void)cancelRequest:(BBNetTask *)task {
    
    [task.sessionTask cancel];
    [self removeTask:task.sessionTask];
    
}

- (void)addTask:(BBNetTask *)task {
    
    if (task) {
        [_netTasks setObject:task forKey:[self uniquekey:task.sessionTask]];
    }
}


- (void)removeTask:(NSURLSessionTask *)task {
    
    if (task) {
        [_netTasks removeObjectForKey:[self uniquekey:task]];
    }
    
}

- (NSString *)uniquekey:(NSURLSessionTask *)task {
    
    return [NSString stringWithFormat:@"%lu",(unsigned long)[task hash]];
}

#pragma mark - start request

- (NSURLSessionDataTask *)GETRequest:(BBNetTask *)netTask {
    
    return [[self sessionManagerWithTask:netTask] GET:netTask.request.requestUrl
                                           parameters:netTask.request.parameters
                                             progress:netTask.request.progress
                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                  
                                                  [self completionHandleWith:[self responseWithTask:task responseObject:responseObject]];
                                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                  
                                                  [self completionHandleWith:[self responseWithTask:task error:error]];
                                              }];
}

- (NSURLSessionDataTask *)POSTRequest:(BBNetTask *)netTask {
    
    NSURLSessionDataTask *sessionTask = nil;
    
    if (!netTask.request.filedata) {
        sessionTask = [[self sessionManagerWithTask:netTask] POST:netTask.request.requestUrl
                                                       parameters:netTask.request.parameters
                                                         progress:netTask.request.progress
                                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                              
                                                              [self completionHandleWith:[self responseWithTask:task responseObject:responseObject]];
                                                              
                                                          }
                                                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                              
                                                              [self completionHandleWith:[self responseWithTask:task error:error]];
                                                          }];
    } else {
        sessionTask = [[self sessionManagerWithTask:netTask] POST:netTask.request.requestUrl
                                                       parameters:netTask.request.parameters
                                        constructingBodyWithBlock:netTask.request.filedata
                                                         progress:netTask.request.progress
                                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                              
                                                              [self completionHandleWith:[self responseWithTask:task responseObject:responseObject]];
                                                              
                                                          }
                                                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                              
                                                              [self completionHandleWith:[self responseWithTask:task error:error]];
                                                          }];
    }
    return sessionTask;
}

- (NSURLSessionDataTask *)HEADRequest:(BBNetTask *)netTask {
    
    return [[self sessionManagerWithTask:netTask] HEAD:netTask.request.requestUrl
                                            parameters:netTask.request.parameters
                                               success:^(NSURLSessionDataTask * _Nonnull task) {
                                                   [self completionHandleWith:[self responseWithTask:task responseObject:nil]];
                                               }
                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   [self completionHandleWith:[self responseWithTask:task error:error]];
                                               }];
}

- (NSURLSessionDataTask *)PUTRequest:(BBNetTask *)netTask {
    
    return [[self sessionManagerWithTask:netTask] PUT:netTask.request.requestUrl
                                           parameters:netTask.request.parameters
                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                  [self completionHandleWith:[self responseWithTask:task responseObject:responseObject]];
                                              }
                                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                  [self completionHandleWith:[self responseWithTask:task error:error]];
                                              }];
}

- (NSURLSessionDataTask *)PATCHRequest:(BBNetTask *)netTask {
    
    return [[self sessionManagerWithTask:netTask] PATCH:netTask.request.requestUrl
                                             parameters:netTask.request.parameters
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                    [self completionHandleWith:[self responseWithTask:task responseObject:responseObject]];
                                                }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                    [self completionHandleWith:[self responseWithTask:task error:error]];
                                                    
                                                }];
}

- (NSURLSessionDataTask *)DELETERequest:(BBNetTask *)netTask {
    
    return [[self sessionManagerWithTask:netTask] DELETE:netTask.request.requestUrl
                                              parameters:netTask.request.parameters
                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                     [self completionHandleWith:[self responseWithTask:task responseObject:responseObject]];
                                                 }
                                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                     [self completionHandleWith:[self responseWithTask:task error:error]];
                                                 }];
}

#pragma mark - request completion

- (BBNetResponse *)responseWithTask:(NSURLSessionTask *)task responseObject:(id)obj {
    BBNetResponse *response = [[BBNetResponse alloc] init];
    response.sessionTask = task;
    response.responseObject = obj;
    response.responseCode = [(NSHTTPURLResponse *)task.response statusCode];
    if (![response responseValid]) {
        //返回报文无效或响应不成功
        response.error = [NSError errorWithDomain:BBNetworkErrorDomain code:response.responseCode userInfo:@{NSLocalizedDescriptionKey:[NSHTTPURLResponse localizedStringForStatusCode:response.responseCode]}];
    }
    return response;
}

- (BBNetResponse *)responseWithTask:(NSURLSessionTask *)task error:(NSError *)error {
    //错误处理
    BBNetResponse *response = [[BBNetResponse alloc] init];
    response.sessionTask = task;
    response.error = error;
    response.responseCode = [(NSHTTPURLResponse *)task.response statusCode];
    
    return response;
}


- (void)completionHandleWith:(BBNetResponse *)response {
    NSString *taskKey = [self uniquekey:response.sessionTask];
    BBNetTask *netTask = [_netTasks objectForKey:taskKey];
    
    if (netTask) {
        response.request = netTask.request;
        netTask.response = response;
        
        BOOL success = [response responseValid];
        if (success) {
            if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskWillEnd:)]) {
                [_taskDelegate taskWillEnd:netTask];
            }
            
            if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskShouldEnd:)]) {
                BOOL shoudEnd = [_taskDelegate taskShouldEnd:netTask];
                if (shoudEnd) {
                    if (netTask.completionBlock) {
                        netTask.completionBlock(response);
                    }
                }
            } else {
                if (netTask.completionBlock) {
                    netTask.completionBlock(response);
                }
            }
            if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskDidEnd:)]) {
                [_taskDelegate taskDidEnd:netTask];
            }
        } else {
            if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskWillEnd:)]) {
                [_taskDelegate taskWillEnd:netTask];
            }
            if (netTask.completionBlock) {
                netTask.completionBlock(response);
            }
            if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(taskDidEnd:)]) {
                [_taskDelegate taskDidEnd:netTask];
            }
        }
    }
    
    [self removeTask:response.sessionTask];
}


@end
