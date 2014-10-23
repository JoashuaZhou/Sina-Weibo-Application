//
//  WeiboOAuthModel.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-11.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboOAuthModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, assign) long long expires_in;
@property (nonatomic, assign) long long remind_in;
@property (nonatomic, assign) long long uid;
@property (nonatomic, strong) NSDate *expireTime;

@property (nonatomic, copy) NSString *userName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
