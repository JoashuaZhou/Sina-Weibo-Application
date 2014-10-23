//
//  WeiboTabBar.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-9.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboTabBar;
@protocol WeiboTabBarDelegate <NSObject>

@optional
- (void)tabBarButtonDidClick:(WeiboTabBar *)WeibotabBar atIndex:(NSInteger)index;
- (void)tabBarComposeButtonDidClick:(WeiboTabBar *)WeibotabBar;
@end

@interface WeiboTabBar : UIView

- (void)addWeiboTabBar:(UITabBarItem *)item;

@property (nonatomic, weak) id <WeiboTabBarDelegate> delegate;

@end
