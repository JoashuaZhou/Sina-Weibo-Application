//
//  WeiboStatusFrameModel.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboStatusFrameModel.h"
#import "WeiboPhotosViewCollection.h"

@implementation WeiboStatusFrameModel

- (void)setModel:(WeiboStatusModel *)model
{
    _model = model;
    
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewWidth = [UIScreen mainScreen].bounds.size.width - 2 * margin;
    
    // 头像
    CGFloat iconViewX = margin;
    CGFloat iconViewY = margin;
    CGFloat iconViewWidth = 44;
    CGFloat iconViewHeight = 44;
    _iconViewFrame = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    
    // 名字
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewFrame) + margin;
    CGFloat nameLabelY = iconViewY;
//    CGSize nameLabelSize = [model.user.name sizeWithFont:WeiboNameFontSize];  // 此接口已过期
    CGSize nameLabelSize = [model.user.name boundingRectWithSize:CGSizeMake(topViewWidth - 2 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WeiboNameFontSize} context:nil].size;
    _nameLabelFrame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};  // 注意这种写法
    
    // vip图标
    if (model.user.mbtype > 4) {  // 是vip，为什么要 > 4？ 新浪定义的就是如此
        CGFloat vipViewX = CGRectGetMaxX(_nameLabelFrame) + margin;
        CGFloat vipViewY = nameLabelY;
        CGFloat vipViewWidth = 14;
        CGFloat vipViewHeight = nameLabelSize.height;
        _vipViewFrame = CGRectMake(vipViewX, vipViewY, vipViewWidth, vipViewHeight);
    }
    
    // 时间
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelFrame) + margin;
//    CGSize timeLabelSize = [model.created_at sizeWithFont:WeiboTimeFontSize];
    CGSize timeLabelSize = [model.created_at boundingRectWithSize:CGSizeMake(topViewWidth - 2 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WeiboTimeFontSize} context:nil].size;
    _timeLabelFrame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    // 来源
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelFrame) + 3 * margin;
    CGFloat sourceLabelY = timeLabelY;
//    CGSize sourceLabelSize = [model.source sizeWithFont:WeiboSourceFontSize];
    CGSize sourceLabelSize = [model.source boundingRectWithSize:CGSizeMake(topViewWidth - 2 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WeiboSourceFontSize} context:nil].size;
    _sourceLabelFrame = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    
    // 微博正文
    CGFloat textLabelX = iconViewX;
    CGFloat textLabelY = CGRectGetMaxY(_iconViewFrame) > CGRectGetMaxY(_timeLabelFrame) ? (CGRectGetMaxY(_iconViewFrame) + margin) : (CGRectGetMaxY(_timeLabelFrame) + margin);
//    CGSize textLabelSize = [model.text sizeWithFont:WeiboTextFontSize];
    CGSize textLabelSize = [model.text boundingRectWithSize:CGSizeMake(topViewWidth - 2 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WeiboTextFontSize} context:nil].size;
    _textFrame = (CGRect){{textLabelX, textLabelY}, textLabelSize};
    CGFloat topViewHeight = CGRectGetMaxY(_textFrame) + margin;
    
    // 配图
    if (model.pic_urls.count) {
        CGFloat photoViewX = iconViewX;
        CGFloat photoViewY = CGRectGetMaxY(_textFrame) + margin;
        CGSize photoViewSize = [WeiboPhotosViewCollection getPhotosViewCollectionSize:model.pic_urls.count];
        _photoViewFrame = (CGRect){{photoViewX, photoViewY}, photoViewSize};
        
        topViewHeight = CGRectGetMaxY(_photoViewFrame) + margin;
    }
    
    if (model.retweeted_status) {   // 有转发
        CGFloat repostNameLabelX = margin;
        CGFloat repostNameLabelY = margin;
//        CGSize repostNameLabelSize = [model.retweeted_status.user.name sizeWithFont:WeiboNameFontSize];
        NSString *reposterName = [NSString stringWithFormat:@"@%@", model.retweeted_status.user.name];
        CGSize repostNameLabelSize = [reposterName boundingRectWithSize:CGSizeMake(topViewWidth - 4 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WeiboNameFontSize} context:nil].size;
        _repostNameLabelFrame = (CGRect){{repostNameLabelX, repostNameLabelY}, repostNameLabelSize};
        
        CGFloat repostTextLabelX = repostNameLabelX;
        CGFloat repostTextLabelY = CGRectGetMaxY(_repostNameLabelFrame) + margin;
//        CGSize repostTextLabelSize = [model.retweeted_status.text sizeWithFont:WeiboTextFontSize];
        CGSize repostTextLabelSize = [model.retweeted_status.text boundingRectWithSize:CGSizeMake(topViewWidth - 4 * margin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: WeiboTextFontSize} context:nil].size;
        _repostTextLabelFrame = (CGRect){{repostTextLabelX, repostTextLabelY}, repostTextLabelSize};
        
        if (model.retweeted_status.pic_urls.count) {     // 转发含配图
            CGFloat repostImageViewX = repostTextLabelX;
            CGFloat repostImageViewY = CGRectGetMaxY(_repostTextLabelFrame) + margin;
            CGSize respostImageViewSize = [WeiboPhotosViewCollection getPhotosViewCollectionSize:model.retweeted_status.pic_urls.count];
            _repostImageViewFrame = (CGRect){{repostImageViewX, repostImageViewY}, respostImageViewSize};
            
            CGFloat repostViewX = iconViewX;
            CGFloat repostViewY = CGRectGetMaxY(_textFrame) + margin;
            CGFloat repostViewWidth = topViewWidth - 2 * margin;
            CGFloat repostViewHeight = CGRectGetMaxY(_repostImageViewFrame) + margin;
            _repostViewFrame = CGRectMake(repostViewX, repostViewY, repostViewWidth, repostViewHeight);
        } else {    // 转发不含配图
            CGFloat repostViewX = iconViewX;
            CGFloat repostViewY = CGRectGetMaxY(_textFrame) + margin;
            CGFloat repostViewWidth = topViewWidth - 2 * margin;
            CGFloat repostViewHeight = CGRectGetMaxY(_repostTextLabelFrame) + margin;
            _repostViewFrame = CGRectMake(repostViewX, repostViewY, repostViewWidth, repostViewHeight);
        }
        topViewHeight = CGRectGetMaxY(_repostViewFrame) + margin;
     }
    
    _topViewFrame = CGRectMake(topViewX, topViewY, topViewWidth, topViewHeight);
    
    CGFloat bottomViewX = topViewX;
    CGFloat bottomViewY = CGRectGetMaxY(_topViewFrame);
    CGFloat bottomViewWidth = topViewWidth;
    CGFloat bottomViewHeight = 44;
    _bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewWidth, bottomViewHeight);
    
    CGFloat repostButtonX = bottomViewX;
    CGFloat repostButtonY = bottomViewY;
    CGFloat repostButtonWidth = bottomViewWidth / 3;
    CGFloat repostButtonHeight = bottomViewHeight;
    _repostButtonFrame = CGRectMake(repostButtonX, repostButtonY, repostButtonWidth, repostButtonHeight);
    
    CGFloat commentButtonX = CGRectGetMaxX(_repostButtonFrame);
    CGFloat commentButtonY = bottomViewY;
    CGFloat commentButtonWidth = bottomViewWidth / 3;
    CGFloat commentButtonHeight = bottomViewHeight;
    _commentButtonFrame = CGRectMake(commentButtonX, commentButtonY, commentButtonWidth, commentButtonHeight);
    
    CGFloat attitudeButtonX = CGRectGetMaxX(_commentButtonFrame);
    CGFloat attitudeButtonY = bottomViewY;
    CGFloat attitudeButtonWidth = bottomViewWidth / 3;
    CGFloat attitudeButtonHeight = bottomViewHeight;
    _attitudeButtonFrame = CGRectMake(attitudeButtonX, attitudeButtonY, attitudeButtonWidth, attitudeButtonHeight);
    
    _cellHeight = CGRectGetMaxY(_bottomViewFrame) + margin;
}

@end
