//
//  WeiboBadgeValueButton.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboBadgeValueButton.h"
#import "UIImage+resizeImage.h"
#import "NSString+StringSize.h"

@implementation WeiboBadgeValueButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.hidden = YES;  // 默认是不显示的
    }
    return self;
}

#define widthMargin 10
#define heightMargin 5
- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];    // @property声明为copy，赋值的时候就最好用copy
    [self setBackgroundImage:[UIImage resizeImage:[UIImage imageNamed:@"main_badge_os7"]] forState:UIControlStateNormal];
    [self setTitle:badgeValue forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    CGSize fontSize = [NSString getStringSize:badgeValue font:self.titleLabel.font];
    self.bounds = CGRectMake(0, 0, fontSize.width + widthMargin, fontSize.height + heightMargin);
    if ([badgeValue integerValue] > 0 || [badgeValue isEqualToString:@"new"]) {    // 只有badgeValue > 0，即有新消息时，才显示
        self.hidden = NO;
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, -1, contentRect.size.width, contentRect.size.height);
}

@end
