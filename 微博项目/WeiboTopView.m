//
//  WeiboTopView.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboTopView.h"
#import "WeiboRepostView.h"
#import "UIImage+resizeImage.h"
#import "UIImageView+WebCache.h"
#import "WeiboPhotoModel.h"
#import "WeiboPhotosViewCollection.h"

@interface WeiboTopView ()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIImageView *vipView;
@property (nonatomic, weak) WeiboPhotosViewCollection *photoView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *sourceLabel;
@property (nonatomic, weak) UILabel *statusTextLabel;

@property (nonatomic, weak) WeiboRepostView *repostView;

@end

@implementation WeiboTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES; // 用于点击图片时photoViewCollection能传递事件
        [self setImage:[UIImage resizeImage:[UIImage imageNamed:@"timeline_card_top_background_os7"]]];
        
        [self setupSubviews];
        [self setupRepostView];
    }
    return self;
}

- (void)setupSubviews
{
    UIImageView *iconView = [[UIImageView alloc] init]; // 头像
    [self addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = WeiboNameFontSize;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = WeiboTimeFontSize;
    [timeLabel setTextColor:[UIColor orangeColor]];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    vipView.hidden = YES;
    [self addSubview:vipView];
    self.vipView = vipView;
    
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = [UIColor lightGrayColor];
    sourceLabel.font = WeiboSourceFontSize;
    [self addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = WeiboTextFontSize;
    textLabel.numberOfLines = 0; // 自动换行
    [self addSubview:textLabel];
    self.statusTextLabel = textLabel;
    
    WeiboPhotosViewCollection *photoView = [[WeiboPhotosViewCollection alloc] init];    // 配图
    photoView.hidden = YES;
    [self addSubview:photoView];
    self.photoView = photoView;
}

- (void)setFrameModel:(WeiboStatusFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    WeiboStatusModel *model = self.frameModel.model;
    [self.iconView setImageWithURL:[NSURL URLWithString:model.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"SCUT_icon"]];
    self.iconView.frame = self.frameModel.iconViewFrame;
    
    self.nameLabel.text = model.user.name;
    self.nameLabel.frame = self.frameModel.nameLabelFrame;
    
    if (model.user.mbtype) {     // 是微博会员
        self.vipView.hidden = NO;
        [self.vipView setImage:[UIImage imageNamed:@"common_icon_membership"]];
        self.vipView.frame = self.frameModel.vipViewFrame;
        [self.nameLabel setTextColor:[UIColor redColor]];
    } else {                    // 不是微博会员
        self.vipView.hidden = YES;
    }
    
    self.timeLabel.text = model.created_at;
    self.timeLabel.frame = self.frameModel.timeLabelFrame;
    
    self.sourceLabel.text = model.source;
    self.sourceLabel.frame = self.frameModel.sourceLabelFrame;
    
    self.statusTextLabel.text = model.text;
    self.statusTextLabel.frame = self.frameModel.textFrame;
    
    if (model.pic_urls.count) {
        self.photoView.hidden = NO;
        self.photoView.photos = model.pic_urls;
        self.photoView.frame = self.frameModel.photoViewFrame;
    } else {
        self.photoView.hidden = YES;
    }
    
    [self setRepostViewData];
}

- (void)setupRepostView
{
    WeiboRepostView *repostView = [[WeiboRepostView alloc] init];
    [self addSubview:repostView];
    self.repostView = repostView;
}

- (void)setRepostViewData
{
    self.repostView.frame = self.frameModel.repostViewFrame;
    self.repostView.frameModel = self.frameModel;
}

@end
