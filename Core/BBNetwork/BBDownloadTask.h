//
//  BBDownloadTask.h
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/27.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBDownloadTask : NSObject

///文件下载
+ (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
             targetPath:(NSString *)filePath
               progress:( void (^)(NSProgress *downloadProgress))downloadProgressBlock
             completion:(void (^)(NSURLResponse *response, NSURL * filePath, NSError * error))completionHandler;

@end
