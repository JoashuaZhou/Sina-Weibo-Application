//
//  WeiboOAuthModel.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-11.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboOAuthModel.h"

@implementation WeiboOAuthModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeInt64:self.expires_in forKey:@"expires_in"];      // long long可用int64代替
    [aCoder encodeInt64:self.remind_in forKey:@"remind_in"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expireTime forKey:@"expireTime"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeInt64ForKey:@"expires_in"];
        self.remind_in = [aDecoder decodeInt64ForKey:@"remind_in"];
        self.uid = [aDecoder decodeInt64ForKey:@"uid"];
        self.expireTime = [aDecoder decodeObjectForKey:@"expireTime"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
    }
    return self;
}

@end
