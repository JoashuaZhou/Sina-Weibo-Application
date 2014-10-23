//
//  WeiboNewFeatureChecker.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboNewFeatureChecker.h"
#import "WeiboTabBarViewController.h"
#import "WeiboNewFeatureViewController.h"

@implementation WeiboNewFeatureChecker

+ (UIViewController *)isNewFeature
{
    /* 判断安装app/更新版本后，第一次打开app的思路：
     * 1.自定义一个key到userDefault，专门存储版本号，打开时读取看看版本号存不存在。
     * 2.若不存在，肯定是第一次打开app，这时把rootViewController设为WeiboNewFeatureViewController，并存储版本号到userDeafult
     * 3.若存在，还要判断版本号是否与当前版本号相等，如果不是就是更新后第一次打开app，这时把rootViewController设为WeiboNewFeatureViewController，并存储版本号到userDeafult
     * 4.若版本号相等，就不是第一次打开app，这时把rootViewController设为WeiboTabBarViewController
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastSavedVersion = [defaults stringForKey:@"CFBundleVersion"];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];    // 读取现在app的版本号，其实就是读取文件”微博项目-Info.plist“的bundle version
    if ([currentVersion isEqualToString:lastSavedVersion]) {    // 版本号存在，并与当前版本号相等
        return [[WeiboTabBarViewController alloc] init];
    } else
    {
        [defaults setObject:currentVersion forKey:@"CFBundleVersion"];
        [defaults synchronize];
        return [[WeiboNewFeatureViewController alloc] init];
    }
}

+ (BOOL)writeAuthorityInfo:(WeiboOAuthModel *)model
{
    /* 记录授权的时间 */
    NSDate *now = [NSDate date];
    model.expireTime = [now dateByAddingTimeInterval:model.expires_in];
    
    NSString *mainPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];  // 返回的是只有一个元素的数组，所以使用last object
    NSString *filePath = [mainPath stringByAppendingPathComponent:@"authority_info.data"];
    return [NSKeyedArchiver archiveRootObject:model toFile:filePath];
}

+ (WeiboOAuthModel *)readAuthorityInfo
{
    NSString *mainPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];  // 返回的是只有一个元素的数组，所以使用last object
    NSString *filePath = [mainPath stringByAppendingPathComponent:@"authority_info.data"];
    
    WeiboOAuthModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    /* 判断账号授权是否过期 */
    if ([self isExpired:model]) {
        return nil;
    }
    return model;
}

+ (BOOL)isExpired:(WeiboOAuthModel *)model
{
    NSDate *now = [NSDate date];
    if ([now compare:model.expireTime] == NSOrderedDescending) {     // NSOrderedDescending的理解：now, expireTime降序排列，所以now > expireTime，即已经过期
        return YES;
    }
    
    return NO;
}

@end
