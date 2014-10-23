//
//  WeiboNewFeatureViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboNewFeatureViewController.h"
#import "WeiboTabBarViewController.h"

@interface WeiboNewFeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageController;

@end

@implementation WeiboNewFeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupScrollView];
    
    [self setupPageController];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(featuresCount * self.view.bounds.size.width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    for (NSInteger i = 0; i < 3; i++) {
        NSString *featureImageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:featureImageName]];
        [scrollView addSubview:imageView];
        imageView.frame = CGRectMake(i * self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *lastFeaturesView = [scrollView.subviews lastObject];
    lastFeaturesView.userInteractionEnabled = YES;  // 要把父控件的userInteractionEnabled打开，它的子控件的button才能被点击
    [lastFeaturesView addSubview:button];
    button.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 0.6);
    button.bounds = CGRectMake(0, 0, 105, 36);
    [button setTitle:@"进入微博" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(enterUI) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
    [[scrollView.subviews lastObject] addSubview:checkBox];
    checkBox.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 0.5);
    checkBox.bounds = CGRectMake(0, 0, 150, 36);
    checkBox.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [checkBox setTitle:@"分享给大家" forState:UIControlStateNormal];
    [checkBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkBox setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [checkBox setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [checkBox addTarget:self action:@selector(isShareNewFeature:) forControlEvents:UIControlEventTouchUpInside];
    checkBox.selected = YES;
}

- (void)isShareNewFeature:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

- (void)enterUI
{
    self.view.window.rootViewController = [[WeiboTabBarViewController alloc] init]; // 点击“进入微博”，就进入到主UI，而新版本viewController就销毁不要了
}

- (void)setupPageController
{
    UIPageControl *pageController = [[UIPageControl alloc] init];
    pageController.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:42/255.0 alpha:1.0];
    pageController.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
    pageController.numberOfPages = featuresCount;
    self.pageController = pageController;
    [self.view addSubview:pageController];
    pageController.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 30);
    pageController.bounds = CGRectMake(0, 0, 120, 30);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width);
    NSInteger currentPage = (NSInteger)(pageFloat + 0.5);
    self.pageController.currentPage = currentPage;
}

@end
