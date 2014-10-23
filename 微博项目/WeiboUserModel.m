//
//  WeiboUserModel.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboUserModel.h"

@implementation WeiboUserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.ID = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.profile_image_url = dictionary[@"profile_image_url"];
        self.mbtype = [dictionary[@"mbtype"] integerValue];
    }
    return self;
}

@end
