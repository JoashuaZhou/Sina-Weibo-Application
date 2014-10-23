//
//  WeiboStatusModel.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboStatusModel.h"
#import "NSDate+MJ.h"
#import "WeiboPhotoModel.h"

@implementation WeiboStatusModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.ID = dictionary[@"id"];
//        NSLog(@"服务器返回的ID：%@", dictionary[@"id"]);
        self.text = dictionary[@"text"];
        self.created_at = dictionary[@"created_at"];
        self.source = dictionary[@"source"];
        
        self.reposts_count = [dictionary[@"reposts_count"] integerValue];
        self.comments_count = [dictionary[@"comments_count"] integerValue];
        self.attitudes_count = [dictionary[@"attitudes_count"] integerValue];
        self.pic_urls = [self setupPic_urlsArray:dictionary[@"pic_urls"]];
        self.user = [[WeiboUserModel alloc] initWithDictionary:dictionary[@"user"]];
        if (dictionary[@"retweeted_status"]) {
            NSDictionary *repostDictionary = dictionary[@"retweeted_status"];
            self.retweeted_status = [[WeiboStatusModel alloc] init];
            self.retweeted_status.ID = repostDictionary[@"id"];
            self.retweeted_status.text = repostDictionary[@"text"];
            self.retweeted_status.created_at = repostDictionary[@"created_at"];
            self.retweeted_status.source = repostDictionary[@"source"];
            self.retweeted_status.pic_urls = [self.retweeted_status setupPic_urlsArray:repostDictionary[@"pic_urls"]];
            self.retweeted_status.user = [[WeiboUserModel alloc] initWithDictionary:repostDictionary[@"user"]];
        }
    }
    return self;
}

- (NSArray *)setupPic_urlsArray:(NSArray *)array
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *picDictionary in array) {
        WeiboPhotoModel *photoModel = [[WeiboPhotoModel alloc] initWithDictionary:picDictionary];
        [tempArray addObject:photoModel];
    }
    return tempArray;
}

/* 为什么这里用getter，而下面的source是用setter？因为当tableView滚动时，getter会被不断调用，也就是说时间会不断重新计算，这样时间就可以做到实时计算更新，所以这里用getter，而setter只调用一次，就做不到时间的实时计算更新 */
- (NSString *)created_at
{
    // _created_at == Fri May 09 16:30:34 +0800 2014
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *createdDate = [fmt dateFromString:_created_at];
    
    // 2..判断微博发送时间 和 现在时间 的差距
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%d小时前", createdDate.deltaWithNow.hour];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%d分钟前", createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) { // 昨天
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}

/* 为什么在setter里面设置而不在getter？因为这里setter只调用一次，之后数据不会怎么变，而getter会被调用很多次，为了节省性能，在此设置 */
- (void)setSource:(NSString *)source
{
//    NSLog(@"%@", source);
    NSRange startRange = [source rangeOfString:@">"];   // 只查找第一个匹配的字符串，第二个不管
    NSRange endRange = [source rangeOfString:@"</"];
    NSRange range = NSMakeRange(startRange.location + 1, endRange.location - startRange.location - 1);
//    NSLog(@"Range: %d, %d", range.location, range.length);
    NSString *string = [source substringWithRange:range];
    _source = [NSString stringWithFormat:@"来自 %@", string];
//    NSLog(@"截取：%@", string);
}

@end
