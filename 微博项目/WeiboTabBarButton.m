//
//  WeiboTabBarButton.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-9.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboTabBarButton.h"
#import "WeiboBadgeValueButton.h"

@interface WeiboTabBarButton ()

@property (nonatomic, weak) WeiboBadgeValueButton *badgeButton;

@end

@implementation WeiboTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.imageView.contentMode = UIViewContentModeCenter;
        
        WeiboBadgeValueButton *badgeValueButton = [[WeiboBadgeValueButton alloc] init];
        [self addSubview:badgeValueButton];
        self.badgeButton = badgeValueButton;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    // 置空，取消highlighted状态
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height * titleHeightRatio, contentRect.size.width, contentRect.size.height * (1-titleHeightRatio));
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * titleHeightRatio);
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"title"];
    [self removeObserver:self forKeyPath:@"image"];
    [self removeObserver:self forKeyPath:@"selectedImage"];
    [self removeObserver:self forKeyPath:@"badgeValue"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:234/255.0 green:103/255.0 blue:7/255.0 alpha:1.0] forState:UIControlStateSelected];
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    self.badgeButton.badgeValue = self.item.badgeValue;
    CGRect frame = self.badgeButton.frame;
    frame.origin = CGPointMake(32, 0);  // 我们先确定了bounds，再确定origin，组合起来就是frame
    self.badgeButton.frame = frame;
}

@end
