//
//  WeiboHTTPTools.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-22.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboHTTPTools : NSObject

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)dictionary success:(void (^)(id responseJason))success failure:(void (^)(NSError *error))failure;

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)dictionary success:(void (^)(id responseJason))success failure:(void (^)(NSError *error))failure;

@end
