//
//  WeiboSquareViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-9.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboSquareViewController.h"
#import "UIImage+resizeImage.h"

@interface WeiboSquareViewController ()

@end

@implementation WeiboSquareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self setupSearchField];
}

- (void)setupSearchField
{
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [searchField setBackground:[UIImage resizeImage:[UIImage imageNamed:@"searchbar_textfield_background_os7"]]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
    imageView.bounds = CGRectMake(0, 0, 30, 30);
    imageView.contentMode = UIViewContentModeCenter;
    searchField.font = [UIFont systemFontOfSize:13];
    searchField.placeholder = @"搜索";
    searchField.leftView = imageView;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.clearButtonMode = UITextFieldViewModeAlways;
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.enablesReturnKeyAutomatically = YES;
    self.navigationItem.titleView = searchField; //[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] 其实用系统自带的也行
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
