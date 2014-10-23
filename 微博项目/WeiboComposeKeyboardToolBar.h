//
//  WeiboComposeKeyboardToolBar.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-19.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WeiboComposeKeyboardToolBarButtonCamera,
    WeiboComposeKeyboardToolBarButtonPhoto,
    WeiboComposeKeyboardToolBarButtonMention,
    WeiboComposeKeyboardToolBarButtonEmotion,
    WeiboComposeKeyboardToolBarButtonTrend
} WeiboComposeKeyboardToolBarButtonType;        // 定义一个枚举，绑定tag，用于判断按下哪一个barbutton，用0, 1这些数字不容易看懂

@class WeiboComposeKeyboardToolBar;
@protocol WeiboComposeKeyboardToolBarDelegate <NSObject>

@optional
- (void)WeiboComposeKeyboardToolBar:(WeiboComposeKeyboardToolBar *)toolbar didClickBarButtonType:(WeiboComposeKeyboardToolBarButtonType)buttonType;

@end

@interface WeiboComposeKeyboardToolBar : UIView

@property (nonatomic, weak) id <WeiboComposeKeyboardToolBarDelegate> delegate;

@end
