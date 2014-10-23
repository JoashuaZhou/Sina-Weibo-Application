//
//  NSString+StringSize.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

+ (CGSize)getStringSize:(NSString *)string font:(UIFont *)font
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

@end
