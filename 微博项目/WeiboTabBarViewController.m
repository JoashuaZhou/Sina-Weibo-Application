//
//  WeiboTabBarViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-9.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboTabBarViewController.h"
#import "WeiboNavigationViewController.h"
#import "WeiboMainTableViewController.h"
#import "WeiboMessageTableViewController.h"
#import "WeiboSquareViewController.h"
#import "WeiboAboutMeViewController.h"
#import "WeiboComposeViewController.h"
#import "WeiboTabBar.h"

@interface WeiboTabBarViewController () <WeiboTabBarDelegate, WeiboComposeViewControllerDelegate>

@property (nonatomic, weak) WeiboTabBar *myTabBar;

@end

@implementation WeiboTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialMyTabBar];
    
    [self addViewControllers];
}

- (void)viewWillAppear:(BOOL)animated       // 之所以在这里删去tabBar的subView，是因为在viewDidLoad里面，tabBar.subView = nil，为什么?
{
    [super viewWillAppear:animated];
    for (UIView *view in self.tabBar.subviews) {    // 不知道tabbarButton的子控件是什么，那就
        if ([view isKindOfClass:[UIControl class]]) {   // 为什么要判断? 因为viewWillAppear是在viewDidLoad之后运行的，如果不判断的话，连我们自定义的tabBar都会被remove掉
            [view removeFromSuperview];
        }
    }
}

- (void)initialMyTabBar
{
    WeiboTabBar *myTabBar = [[WeiboTabBar alloc] init];
    myTabBar.frame = self.tabBar.bounds;    // 如果是frame会显示不出来，因为myTabBar将会作为tabBar的subView
    myTabBar.delegate = self;
    [self.tabBar addSubview:myTabBar];
    self.myTabBar = myTabBar;
}

- (void)addViewControllers
{
    WeiboMainTableViewController *mainController = [[WeiboMainTableViewController alloc] init];
    [self initailViewControllers:mainController title:@"首页" image:[UIImage imageNamed:@"tabbar_home_os7"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected_os7"]];
    mainController.tabBarItem.badgeValue = @"new";
    
    WeiboMessageTableViewController *messageController = [[WeiboMessageTableViewController alloc] init];
    [self initailViewControllers:messageController title:@"消息" image:[UIImage imageNamed:@"tabbar_message_center_os7"] selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected_os7"]];
    messageController.tabBarItem.badgeValue = @"new";
    
    WeiboSquareViewController *squareController = [[WeiboSquareViewController alloc] init];
    [self initailViewControllers:squareController title:@"广场" image:[UIImage imageNamed:@"tabbar_discover_os7"] selectedImage:[UIImage imageNamed:@"tabbar_discover_selected_os7"]];
    squareController.tabBarItem.badgeValue = @"new";
    
    WeiboAboutMeViewController *aboutMeController = [[WeiboAboutMeViewController alloc] init];
    [self initailViewControllers:aboutMeController title:@"关于我" image:[UIImage imageNamed:@"tabbar_profile_os7"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected_os7"]];
    aboutMeController.tabBarItem.badgeValue = @"new";
}

- (void)initailViewControllers:(UIViewController *)viewController title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    /* tabBarItem包含以下@property哈 */
    viewController.title = title;   // 只要设置了viewController的title，它的navigationController和tabbarController的标题都是一样的
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = selectedImage;
    
    WeiboNavigationViewController *navController = [[WeiboNavigationViewController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navController];
    
    [self.myTabBar addWeiboTabBar:viewController.tabBarItem];
}

- (void)tabBarButtonDidClick:(WeiboTabBar *)WeibotabBar atIndex:(NSInteger)index
{
    self.selectedIndex = index;
}

- (void)tabBarComposeButtonDidClick:(WeiboTabBar *)WeibotabBar
{
    WeiboComposeViewController *wcvc = [[WeiboComposeViewController alloc] init];
    wcvc.delegate = self;
    WeiboNavigationViewController *navvc = [[WeiboNavigationViewController alloc] initWithRootViewController:wcvc];
    [self presentViewController:navvc animated:YES completion:nil];
}

- (void)WeiboComposeViewControllerDidCancelCompose:(WeiboComposeViewController *)WeiboComposeViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)WeiboComposeViewControllerDidSendCompose:(WeiboComposeViewController *)WeiboComposeViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
