//
//  WeiboStatusModel.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUserModel.h"

@interface WeiboStatusModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) NSInteger reposts_count;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger attitudes_count;
@property (nonatomic, strong) NSArray *pic_urls;
//@property (nonatomic, copy) NSString *thumbnail_pic;
@property (nonatomic, strong) WeiboUserModel *user;
@property (nonatomic, strong) WeiboStatusModel *retweeted_status;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
