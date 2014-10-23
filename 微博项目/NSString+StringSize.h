//
//  NSString+StringSize.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

+ (CGSize)getStringSize:(NSString *)string font:(UIFont *)font;

@end
