//
//  WeiboTabBar.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-9.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboTabBar.h"
#import "WeiboTabBarButton.h"

@interface WeiboTabBar ()

@property (nonatomic, weak) WeiboTabBarButton *button;
@property (nonatomic, weak) UIButton *postButton;

@end

@implementation WeiboTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];    // 因为WeiboTabBarButton没有highlight状态，所以我们用UIButton
        [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_os7"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted_os7"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_os7"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted_os7"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(postNewWeiBo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.postButton = button;
    }
    return self;
}

- (void)postNewWeiBo:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBarComposeButtonDidClick:)]) {
        [self.delegate tabBarComposeButtonDidClick:self];
    }
}

- (void)addWeiboTabBar:(UITabBarItem *)item
{
    WeiboTabBarButton *button = [WeiboTabBarButton buttonWithType:UIButtonTypeCustom];

    button.item = item;
    
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:button];   // 先存入subView数组，就不用自己弄一个数组了
    
    if (self.subviews.count == 1) {     // 当subView只有一个按钮的时候，也就是button = 0
        [self buttonDidClicked:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth = self.bounds.size.width / self.subviews.count;
    CGFloat buttonHeight = self.bounds.size.height;
    for (NSInteger i = 1; i < self.subviews.count; i++) {   // 为什么从1开始？因为0是那个“加号按钮”
        NSInteger buttonX = (i-1) * buttonWidth;
        if (i > 2) {                                        // 这里要跳过，为什么？因为要留一个位置放“加号按钮”
            buttonX += buttonWidth;
        }
        WeiboTabBarButton *button = self.subviews[i];
        button.frame = CGRectMake(buttonX, 0, buttonWidth, buttonHeight);
        button.tag = i - 1;
    }
    self.postButton.center = self.center;   // 记得，可以用center来设置控件的位置，不一定非要用frame
    self.postButton.bounds = CGRectMake(0, 0, buttonWidth, buttonHeight);
}

- (void)buttonDidClicked:(WeiboTabBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBarButtonDidClick:atIndex:)]) {
        [self.delegate tabBarButtonDidClick:self atIndex:button.tag];
    }
    self.button.selected = NO;
    button.selected = YES;
    self.button = button;
}

@end
