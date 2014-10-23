//
//  WeiboHTTPTools.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-22.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboHTTPTools.h"
#import "AFNetworking.h"

@implementation WeiboHTTPTools

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)dictionary success:(void (^)(id responseJason))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {              // 通过这样利用block传参
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)dictionary success:(void (^)(id responseJason))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
