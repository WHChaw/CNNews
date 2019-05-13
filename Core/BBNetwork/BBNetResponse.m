//
//  BBNetResponse.m
//  BBNetwork
//
//  Created by 曹文辉 on 16/5/26.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "BBNetResponse.h"

@implementation BBNetResponse

- (BOOL)responseValid {
    BOOL httpCodeValid = NO;
    BOOL jsonValid = NO;
    if (_responseCode>=200 && _responseCode <= 299) {
        httpCodeValid = YES;
    } else {
        httpCodeValid = NO;
    }
    
    if ([NSJSONSerialization isValidJSONObject:_responseObject]) {
        jsonValid = YES;
    } else {
        jsonValid = NO;
    }
    
    return httpCodeValid&&jsonValid;
    
}

@end
