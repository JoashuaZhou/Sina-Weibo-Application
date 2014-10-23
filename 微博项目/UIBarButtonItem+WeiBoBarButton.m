//
//  UIBarButtonItem+WeiBoBarButton.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "UIBarButtonItem+WeiBoBarButton.h"

@implementation UIBarButtonItem (WeiBoBarButton)

+ (UIBarButtonItem *)setupNavigationBarButtonWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIButton *button = [[UIButton alloc] init];
    button.bounds = CGRectMake(0, 0, 30, 30);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
