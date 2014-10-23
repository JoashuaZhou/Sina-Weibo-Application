//
//  WeiboCell.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboBottomView.h"
//#import "WeiboRepostView.h"
#import "WeiboTopView.h"

@interface WeiboCell ()

@property (nonatomic, weak) WeiboTopView *topView;
//@property (nonatomic, weak) WeiboRepostView *repostView;
@property (nonatomic, weak) WeiboBottomView *bottomView;

@end

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /* 1.topView部分 */
        [self setupTopView];
        
        /* 2.转发部分 */
//        [self setupRepostView];
        
        /* 3.底部工具条(转发、评论、点赞) */
        [self setupBottomView];
    }
    return self;
}

- (void)setupTopView
{
    WeiboTopView *topView = [[WeiboTopView alloc] init];  // 因为要显示背景图片，所以要imageView而不用View

    [self.contentView addSubview:topView];
    self.topView = topView;
    
    self.backgroundColor = [UIColor clearColor];
}

//- (void)setupRepostView
//{
//    WeiboRepostView *repostView = [[WeiboRepostView alloc] init];
//    [self.topView addSubview:repostView];
//    self.repostView = repostView;
//}

- (void)setupBottomView
{
    WeiboBottomView *bottomView = [[WeiboBottomView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setFrameModel:(WeiboStatusFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    [self setTopViewData];
//    [self setRepostViewData];
    [self setBottomViewData];
}

- (void)setTopViewData
{
    self.topView.frame = self.frameModel.topViewFrame;
    self.topView.frameModel = self.frameModel;
}

//- (void)setRepostViewData
//{
//    self.repostView.frame = self.frameModel.repostViewFrame;
//    self.repostView.frameModel = self.frameModel;
//}

- (void)setBottomViewData
{
    self.bottomView.frame = self.frameModel.bottomViewFrame;
    self.bottomView.statusModel = self.frameModel.model;
}

/* 设置cell的边框 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 8;
    frame.size.width -= 2 * margin;
    frame.size.height -= margin;
    [super setFrame:frame];
}

@end
