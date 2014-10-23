//
//  WeiboStatusFrameModel.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-15.
//  assign, readonlyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboStatusModel.h"

@interface WeiboStatusFrameModel : NSObject

@property (nonatomic, strong) WeiboStatusModel *model;

@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGRect timeLabelFrame;
@property (nonatomic, assign, readonly) CGRect sourceLabelFrame;
@property (nonatomic, assign, readonly) CGRect photoViewFrame;
@property (nonatomic, assign, readonly) CGRect iconViewFrame;
@property (nonatomic, assign, readonly) CGRect nameLabelFrame;
@property (nonatomic, assign, readonly) CGRect vipViewFrame;

@property (nonatomic, assign, readonly) CGRect repostNameLabelFrame;
@property (nonatomic, assign, readonly) CGRect repostTextLabelFrame;
@property (nonatomic, assign, readonly) CGRect repostImageViewFrame;

@property (nonatomic, assign, readonly) CGRect repostButtonFrame;
@property (nonatomic, assign, readonly) CGRect commentButtonFrame;
@property (nonatomic, assign, readonly) CGRect attitudeButtonFrame;

@property (nonatomic, assign, readonly) CGRect topViewFrame;
@property (nonatomic, assign, readonly) CGRect repostViewFrame;
@property (nonatomic, assign, readonly) CGRect bottomViewFrame;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
