//
//  BBDownloadTask.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/27.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBDownloadTask.h"
#import <AFNetworking/AFNetworking.h>

@implementation BBDownloadTask

+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
             targetPath:(NSString *)filePath
               progress:(void (^)(NSProgress *))downloadProgressBlock
             completion:(void (^)(NSURLResponse *, NSURL *, NSError *))completionHandler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    return [manager downloadTaskWithRequest:request
                            progress:downloadProgressBlock
                         destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                             
                             return [NSURL URLWithString:filePath];
                         }
                   completionHandler:completionHandler];
}

@end
