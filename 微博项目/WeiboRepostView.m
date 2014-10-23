//
//  WeiboRepostView.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboRepostView.h"
#import "UIImage+resizeImage.h"
#import "UIImageView+WebCache.h"
#import "WeiboPhotoModel.h"
#import "WeiboPhotosViewCollection.h"

@interface WeiboRepostView ()

@property (nonatomic, weak) WeiboPhotosViewCollection *repostImageView;
@property (nonatomic, weak) UILabel *repostNameLabel;
@property (nonatomic, weak) UILabel *repostTextLabel;

@end

@implementation WeiboRepostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;  // 用于点击图片时photoViewCollection能传递事件
        [self setImage:[UIImage resizeImage:[UIImage imageNamed:@"timeline_retweet_background_os7"] width:0.9 height:0.5]];
        self.hidden = YES;
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    UILabel *repostNameLabel = [[UILabel alloc] init];
    repostNameLabel.textColor = [UIColor blueColor];
    repostNameLabel.font = WeiboRepostNameFontSize;
    [self addSubview:repostNameLabel];
    self.repostNameLabel = repostNameLabel;
    
    UILabel *repostTextLabel = [[UILabel alloc] init];
    repostTextLabel.font = WeiboTextFontSize;
    repostTextLabel.numberOfLines = 0;
    [self addSubview:repostTextLabel];
    self.repostTextLabel = repostTextLabel;
    
    WeiboPhotosViewCollection *repostImageView = [[WeiboPhotosViewCollection alloc] init];
    repostImageView.hidden = YES;
    [self addSubview:repostImageView];
    self.repostImageView = repostImageView;
}

- (void)setFrameModel:(WeiboStatusFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    WeiboStatusModel *model = frameModel.model;
    if (model.retweeted_status) {
        self.hidden = NO;
        self.repostNameLabel.text = [NSString stringWithFormat:@"@%@", model.retweeted_status.user.name];
        self.repostNameLabel.frame = self.frameModel.repostNameLabelFrame;
        
        if (model.retweeted_status.pic_urls.count) {
            self.repostImageView.hidden = NO;
            self.repostImageView.photos = model.retweeted_status.pic_urls;
            self.repostImageView.frame = self.frameModel.repostImageViewFrame;
        } else {
            self.repostImageView.hidden = YES;
        }
        
        self.repostTextLabel.text = model.retweeted_status.text;
        self.repostTextLabel.frame = self.frameModel.repostTextLabelFrame;
    } else {
        self.hidden = YES;
    }
}

@end
