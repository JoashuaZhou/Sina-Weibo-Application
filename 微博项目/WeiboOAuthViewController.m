//
//  WeiboOAuthViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-11.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboOAuthViewController.h"
#import "AFNetworking.h"
#import "WeiboOAuthModel.h"
#import "WeiboNewFeatureChecker.h"

@interface WeiboOAuthViewController () <UIWebViewDelegate>

@end

@implementation WeiboOAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    [self accessOAuthPage:webView];
}

- (void)accessOAuthPage:(UIWebView *)webView
{
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=3154244823&redirect_uri=http://www.apple.com"]; // 这个url新浪的开发文档会告诉你，它也告诉你client_id和redirect_uri是必传参数极其意思，使用POST或者GET都无所谓，这里为了方便我们使用GET
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

/* 使用这个webView delegate方法的目的是，获取新浪服务器返回的access_code
 * 此方法在每次发送一个request的时候都会调用
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *string = request.URL.absoluteString;     // 获得url中的string
    NSRange range = [string rangeOfString:@"code="];   // 获取code=所在的range，NSRange结构体包括location和length
    if (range.length) {                                // range.length不等于0，说明string中包含code=字符串
        NSString *access_code = [string substringFromIndex:(range.location + range.length)]; // 获取access_code
        
        /* 获取access_code后，按照新浪的要求，要发送POST请求到服务器，我们使用AFNetworking框架 */
        [self getAccess:access_code];
        
        return NO;  // 不加载redirect_uri回调页面
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    // 也可以用MBProgressHUD框架
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/* 获取access_code后，按照新浪的要求，要发送POST请求到服务器，我们使用AFNetworking框架 */
- (void)getAccess:(NSString *)access_code
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dictionary = @{
                                 @"client_id": @"3154244823",
                                 @"client_secret": @"8259360ea47902ab37b0446dfdbaaca3",
                                 @"grant_type": @"authorization_code",
                                 @"code": access_code,
                                 @"redirect_uri": @"http://www.apple.com"
                                 };     // 因为我们要用POST请求，参数是一个字典，至于字典里面传什么新浪会告诉你
    
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
        WeiboOAuthModel *model = [[WeiboOAuthModel alloc] initWithDictionary:responseDictionary];   // 其实这一步不是必须，只是因为model使用起来比较方便
        [WeiboNewFeatureChecker writeAuthorityInfo:model];
        self.view.window.rootViewController = [WeiboNewFeatureChecker isNewFeature];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@", error);
    }];
}

@end
