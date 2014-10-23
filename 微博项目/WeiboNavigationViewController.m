//
//  WeiboNavigationViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboNavigationViewController.h"

@interface WeiboNavigationViewController ()

@end

@implementation WeiboNavigationViewController

+ (void)initialize
{
    [self setNavigationTheme];
}

+ (void)setNavigationTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = @{NSForegroundColorAttributeName: [UIColor colorWithRed:234/255.0 green:103/255.0 blue:7/255.0 alpha:1.0], NSFontAttributeName: [UIFont systemFontOfSize:15]};
    // @{NSForegroundColorAttributeName: [UIColor colorWithRed:234/255.0 green:103/255.0 blue:7/255.0 alpha:1.0], NSFontAttributeName: [UIFont systemFontOfSize:15]}
    [item setTitleTextAttributes:dictionary forState:UIControlStateNormal];
    
    /* 设置navBarButton的按钮当不可用的时候的颜色 */
    NSDictionary *disabledDictionary = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [item setTitleTextAttributes:disabledDictionary forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 1) {       // rootViewController不需要隐藏bottomBar
        self.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end