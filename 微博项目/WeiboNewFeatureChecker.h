//
//  WeiboNewFeatureChecker.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboOAuthModel.h"

@interface WeiboNewFeatureChecker : NSObject

+ (UIViewController *)isNewFeature;

+ (BOOL)writeAuthorityInfo:(WeiboOAuthModel *)model;
+ (WeiboOAuthModel *)readAuthorityInfo;

@end
