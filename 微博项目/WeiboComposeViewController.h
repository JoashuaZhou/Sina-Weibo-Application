//
//  WeiboComposeViewController.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-18.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboComposeViewController;
@protocol WeiboComposeViewControllerDelegate <NSObject>

- (void)WeiboComposeViewControllerDidCancelCompose:(WeiboComposeViewController *)WeiboComposeViewController;
- (void)WeiboComposeViewControllerDidSendCompose:(WeiboComposeViewController *)WeiboComposeViewController;

@end

@interface WeiboComposeViewController : UIViewController

@property (nonatomic, weak) id <WeiboComposeViewControllerDelegate> delegate;

@end