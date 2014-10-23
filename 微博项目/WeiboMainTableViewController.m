//
//  WeiboMainTableViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-10.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboMainTableViewController.h"
#import "UIBarButtonItem+WeiBoBarButton.h"
#import "WeiboTitleViewButton.h"
#import "AFNetworking.h"
#import "WeiboOAuthModel.h"
#import "WeiboNewFeatureChecker.h"
#import "WeiboStatusFrameModel.h"
#import "UIImageView+WebCache.h"
#import "WeiboCell.h"
#import "UIImage+resizeImage.h"
#import "MJRefreshFooterView.h"

@interface WeiboMainTableViewController () <MJRefreshBaseViewDelegate>

@property (nonatomic, strong) NSArray *weiboArray;
@property (nonatomic, strong) WeiboOAuthModel *oauthModel;
@property (nonatomic, weak) UIRefreshControl *refresher;

@end

@implementation WeiboMainTableViewController

- (NSArray *)weiboArray
{
    if (!_weiboArray) {
        _weiboArray = [[NSArray alloc] init];
    }
    return _weiboArray;
}

- (WeiboOAuthModel *)oauthModel
{
    if (!_oauthModel) {
        _oauthModel = [WeiboNewFeatureChecker readAuthorityInfo];
    }
    return _oauthModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getUserInfo];
    
    [self setupNavigationBar];
    
    [self setupUI];
}

- (void)setupUI
{
    self.tableView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* 下拉刷新 - 也可以用MJHeaderView框架 */
    UIRefreshControl *refresher = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:refresher];
    [refresher addTarget:self action:@selector(refreshWeibo:) forControlEvents:UIControlEventValueChanged];
    self.refresher = refresher;
    [self.refresher beginRefreshing];   // 进入微博自动刷新一次
    [self refreshWeibo:self.refresher];
    
    /* 上拉刷新 - MJFooterView框架 */
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
//    self.footer = footer;
}

- (void)refreshWeibo:(UIRefreshControl *)refresher
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"access_token"] = self.oauthModel.access_token;
    dictionary[@"count"] = @(2);    // 表示一次请求返回2条微博，新浪接口文档有写
    if (self.weiboArray.count) {
        WeiboStatusFrameModel *frameModel = [self.weiboArray firstObject];
        dictionary[@"since_id"] = frameModel.model.ID;
    }
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *statusesArray = responseObject[@"statuses"];
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in statusesArray) {
            WeiboStatusFrameModel *frameModel = [[WeiboStatusFrameModel alloc] init];
            frameModel.model = [[WeiboStatusModel alloc] initWithDictionary:dictionary];
            [modelArray addObject:frameModel];
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [tempArray addObjectsFromArray:modelArray];
        [tempArray addObjectsFromArray:self.weiboArray];
        self.weiboArray = tempArray;

        [self.tableView reloadData];
        [self.refresher endRefreshing];
        
        [self showNewWeiboCount:modelArray.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取微博失败！");
        [self.refresher endRefreshing];
    }];
}

/* 下拉刷新后提示有多少条新微博 */
- (void)showNewWeiboCount:(NSInteger)count
{
    CGFloat countViewWidth = self.navigationController.navigationBar.bounds.size.width - 16;
    CGFloat countViewHeight = 30;
    CGFloat countViewX = 8;
    CGFloat countViewY = 64 - countViewHeight;
    UIButton *weiboCountView = [[UIButton alloc] initWithFrame:CGRectMake(countViewX, countViewY, countViewWidth, countViewHeight)];
    weiboCountView.userInteractionEnabled = NO;
    if (count) {
        [weiboCountView setTitle:[NSString stringWithFormat:@"%d条新微博", count] forState:UIControlStateNormal];
    } else {
        [weiboCountView setTitle:@"没有新微博" forState:UIControlStateNormal];
    }
    [weiboCountView setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    weiboCountView.titleLabel.font = newWeiboCountViewFont;
    [weiboCountView setBackgroundImage:[UIImage resizeImage:[UIImage imageNamed:@"timeline_new_status_background_os7"]] forState:UIControlStateNormal];
    [self.navigationController.view insertSubview:weiboCountView belowSubview:self.navigationController.navigationBar]; // 把weiboCountView藏在nabigationBar的后面
    [UIView animateWithDuration:0.7 animations:^{
        weiboCountView.frame = CGRectMake(countViewX, 64, countViewWidth, countViewHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0.9 options:UIViewAnimationOptionCurveLinear animations:^{
            weiboCountView.frame = CGRectMake(countViewX, 0, countViewWidth, countViewHeight);
        } completion:^(BOOL finished) {
            [weiboCountView removeFromSuperview];
        }];
    }];
}

/* MJRefresh框架的delegate方法，上拉刷新 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"access_token"] = self.oauthModel.access_token;
    dictionary[@"count"] = @(2);
    WeiboStatusFrameModel *frameModel = [self.weiboArray lastObject];
    dictionary[@"max_id"] = [NSString stringWithFormat:@"%lld", [frameModel.model.ID longLongValue] - 1];   // -1是因为新浪文档说返回的是 <= max_id的数据，因为有个等于，就重复了一条微博，为了去掉这条微博，就要 -1
    [manager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *statusesArray = responseObject[@"statuses"];
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in statusesArray) {
            WeiboStatusFrameModel *frameModel = [[WeiboStatusFrameModel alloc] init];
            frameModel.model = [[WeiboStatusModel alloc] initWithDictionary:dictionary];
            [modelArray addObject:frameModel];
        }
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        [tempArray addObjectsFromArray:self.weiboArray];
        [tempArray addObjectsFromArray:modelArray];
        self.weiboArray = tempArray;
        
        [self.tableView reloadData];
        [refreshView endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取微博失败！");
        [refreshView endRefreshing];
    }];
}

- (void)setupNavigationBar
{
    WeiboTitleViewButton *titleButton = [[WeiboTitleViewButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    if (self.oauthModel.userName) {
        [titleButton setTitle:self.oauthModel.userName forState:UIControlStateNormal];
    } else {
        [titleButton setTitle:@"首页" forState:UIControlStateNormal];
    }
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down_os7"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up_os7"] forState:UIControlStateSelected];
    [titleButton setTintColor:[UIColor blackColor]];
    [titleButton addTarget:self action:@selector(clickTitleView:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setupNavigationBarButtonWithImage:[UIImage imageNamed:@"navigationbar_friendsearch_os7"] highlightedImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted_os7"]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem setupNavigationBarButtonWithImage:[UIImage imageNamed:@"navigationbar_pop_os7"] highlightedImage:[UIImage imageNamed:@"navigationbar_pop_highlighted_os7"]];
}

/* 每次打开app都获取用户数据 */
- (void)getUserInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"access_token"] = self.oauthModel.access_token;
    dictionary[@"uid"] = @(self.oauthModel.uid);
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *userName = responseObject[@"name"];
        self.oauthModel.userName = userName;
        [WeiboNewFeatureChecker writeAuthorityInfo:self.oauthModel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取用户数据失败！");
    }];
}

- (void)clickTitleView:(WeiboTitleViewButton *)sender
{
    if (sender.currentImage == [UIImage imageNamed:@"navigationbar_arrow_down_os7"]) {
        [sender setImage:[UIImage imageNamed:@"navigationbar_arrow_up_os7"] forState:UIControlStateNormal];
    } else
    {
        [sender setImage:[UIImage imageNamed:@"navigationbar_arrow_down_os7"] forState:UIControlStateNormal];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.weiboArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weibo"]; // 疑问：与dequeueReusableCellWithIdentifier: withIndexPath:的区别？
    
    WeiboCell *cell = [[WeiboCell alloc] init];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"weibo"];
//    }
    
    WeiboStatusFrameModel *frameModel = self.weiboArray[indexPath.row];
    cell.frameModel = frameModel;
//    cell.textLabel.text = model.text;
//    cell.detailTextLabel.text = model.user.name;
//    /* 以下注释掉的两行代码是同步加载图片代码，会阻塞主线程，如果要多线程加载图片，使用SDWebImage框架 */
////    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.user.profile_image_url]];
////    cell.imageView.image = [UIImage imageWithData:data];
//    
//    [cell.imageView setImageWithURL:[NSURL URLWithString:model.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"SCUT_icon"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboStatusFrameModel *frameModel = self.weiboArray[indexPath.row];
    return frameModel.cellHeight;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
