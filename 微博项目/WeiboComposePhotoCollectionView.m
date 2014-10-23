//
//  WeiboComposePhotoCollectionView.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-19.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboComposePhotoCollectionView.h"

@implementation WeiboComposePhotoCollectionView

- (void)addPhoto:(UIImage *)image
{
    if (self.subviews.count == 9) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger maxColumn = 4;
    CGFloat imageViewWidth = 70;
    CGFloat imageViewHeight = 70;
    CGFloat myMargin = (self.bounds.size.width - maxColumn * imageViewWidth) / (maxColumn + 1);
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        NSInteger row = i / maxColumn;
        NSInteger column = i % maxColumn;
        UIImageView *imageView = self.subviews[i];
        imageView.frame = CGRectMake(column * (myMargin + imageViewWidth) + myMargin, row * (margin + imageViewHeight), imageViewWidth, imageViewHeight);
    }
}

@end
