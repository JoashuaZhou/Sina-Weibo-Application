//
//  WeiboRepostView.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboStatusFrameModel.h"

@interface WeiboRepostView : UIImageView

@property (nonatomic, strong) WeiboStatusFrameModel *frameModel; // 为什么这里是frameModel而不是model? 因为这个view的subView.frame随着数据的不一样而不一样 

@end
