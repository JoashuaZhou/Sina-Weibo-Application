//
//  WeiboTitleViewButton.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboTitleViewButton.h"
#import "UIImage+resizeImage.h"
#import "NSString+StringSize.h"

@implementation WeiboTitleViewButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage resizeImage:[UIImage imageNamed:@"navigationbar_filter_background_highlighted_os7"]] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentRight;   // 靠右对齐是为了让字和图的间距不要这么大
        self.imageView.contentMode = UIViewContentModeCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width - 20, 0, 20, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width - 20, contentRect.size.height);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    CGSize titleSize = [NSString getStringSize:title font:self.titleLabel.font];
    CGSize buttonSize = CGSizeMake(titleSize.width + self.imageView.bounds.size.width + 5, titleSize.height);
    self.bounds = CGRectMake(0, 0, buttonSize.width, self.bounds.size.height);
    
    [super setTitle:title forState:state];
}

@end
