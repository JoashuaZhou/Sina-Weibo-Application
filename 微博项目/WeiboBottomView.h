//
//  WeiboBottomView.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//  封装控件的类型是谁就继承谁

#import <UIKit/UIKit.h>
#import "WeiboStatusModel.h"

@interface WeiboBottomView : UIImageView

@property (nonatomic, strong) WeiboStatusModel *statusModel;    // 为什么这里是model而不是frameModel? 因为这个工具条的里面的subView.frame是不随着数据而改变的，而是固定的

@end
