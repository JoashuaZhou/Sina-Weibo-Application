//
//  WeiboPhotoView.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboPhotoView.h"
#import "UIImageView+WebCache.h"

@interface WeiboPhotoView ()

@property (nonatomic, weak) UIImageView *gifMarkView;

@end

@implementation WeiboPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *gifMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        gifMarkView.hidden = YES;
        self.gifMarkView = gifMarkView;
    }
    return self;
}

- (void)setPhotoModel:(WeiboPhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    self.gifMarkView.hidden = ![photoModel.thumbnail_pic hasSuffix:@"gif"];  // 当if条件和其执行的语句都是BOOL型时，可以这样写省去if
    [self setImageWithURL:[NSURL URLWithString:photoModel.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /* 让gif标签放在右下角 */
    self.gifMarkView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifMarkView.layer.position = CGPointMake(self.bounds.size.width, self.bounds.size.height);
}

@end
