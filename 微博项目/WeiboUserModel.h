//
//  WeiboUserModel.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUserModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, assign) NSInteger mbtype;    // 微博会员

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end