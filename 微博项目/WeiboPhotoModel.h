//
//  WeiboPhotoModel.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboPhotoModel : NSObject

@property (nonatomic, copy) NSString *thumbnail_pic;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
