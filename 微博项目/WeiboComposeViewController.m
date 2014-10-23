//
//  WeiboComposeViewController.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-18.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboComposeViewController.h"
#import "AFNetworking.h"
#import "WeiboTextView.h"
#import "WeiboNewFeatureChecker.h"
#import "WeiboComposeKeyboardToolBar.h"
#import "WeiboComposePhotoCollectionView.h"

@interface WeiboComposeViewController () <WeiboComposeKeyboardToolBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) WeiboTextView *textView;
@property (nonatomic, weak) WeiboComposePhotoCollectionView *postPhotoCollectionView;

@end

@implementation WeiboComposeViewController

- (void)viewDidLoad
{
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"发微博";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelCompose)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendCompose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    WeiboTextView *textView = [[WeiboTextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:textView];
    textView.placeholder = @"分享此刻的心情...";
    textView.alwaysBounceVertical = YES;    // 即使textView里面的内容不够，也能滚动
    self.textView = textView;
    
    CGFloat toolbarHeight = 44;
    WeiboComposeKeyboardToolBar *toolbar = [[WeiboComposeKeyboardToolBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - toolbarHeight, self.view.bounds.size.width, toolbarHeight)];
    toolbar.delegate = self;
    [self.view addSubview:toolbar];     // 添加到self.view而不是self.textView，就是因为添加到self.textView，toolBar会随着self.textView的滚动而滚动
    
//    UIImageView *postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 100, 100, 100)];
//    postImageView.contentMode = UIViewContentModeScaleAspectFill;
//    postImageView.clipsToBounds = YES;
//    [self.textView addSubview:postImageView];
//    self.postImageView = postImageView;
    WeiboComposePhotoCollectionView *photoCollectionView = [[WeiboComposePhotoCollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.textView addSubview:photoCollectionView];
    self.postPhotoCollectionView = photoCollectionView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChanged:) name:UIKeyboardDidShowNotification object:textView];     // object = textView说明只有textView控件发出的UIKeyboardDidChangeFrameNotification通知才关心，其他控件的UIKeyboardDidChangeFrameNotification通知不关心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:textView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.textView becomeFirstResponder];   // 为什么这句话要放这里而不放在viewDidLoad？因为放在viewDidLoad那里，加载Controller的view的时候，同时也会弹出键盘，会有点卡，放在这里的话，让controller全部加载完，才弹出键盘，就不会卡了
}

- (void)textViewTextDidChange
{
    if (self.textView.text.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)keyboardFrameDidChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
}

- (void)cancelCompose
{
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(WeiboComposeViewControllerDidCancelCompose:)]) {
        [self.delegate WeiboComposeViewControllerDidCancelCompose:self];
    }
}

- (void)sendCompose
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"access_token"] = [WeiboNewFeatureChecker readAuthorityInfo].access_token;
    dictionary[@"status"] = self.textView.text;
    if (self.postPhotoCollectionView.subviews.count) {     // 发送的微博带有图片
        [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSInteger i = 0;
            for (UIImageView *photoView in self.postPhotoCollectionView.subviews) {
                NSData *imageData = UIImageJPEGRepresentation(photoView.image, 1.0);   // 1.0说明上传的是原图，不经过压缩
                [formData appendPartWithFileData:imageData name:@"pic" fileName:[NSString stringWithFormat:@"%d.jpg", i] mimeType:@"image/jpeg"];  // 图片或文件不像简单的数据，在AFN框架中，需要用另一个POST方法上传，并在上传前构造上传的数据。在这个函数中，name就是新浪要我们填的图片key，fileName随便(这里不填也可以)，mimeType就是告诉服务器这是什么数据，关于各文件格式的mimeType，可以百度“常见文件 mimeType”。
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"发送微博成功！");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发送微博失败！");
        }];
    } else {                            // 发送的微博没有图片
        [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"发送微博成功！");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发送微博失败！");
        }];
    }
    
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(WeiboComposeViewControllerDidSendCompose:)]) {
        [self.delegate WeiboComposeViewControllerDidSendCompose:self];
    }
}

- (void)WeiboComposeKeyboardToolBar:(WeiboComposeKeyboardToolBar *)toolbar didClickBarButtonType:(WeiboComposeKeyboardToolBarButtonType)buttonType
{
    switch (buttonType) {
        case WeiboComposeKeyboardToolBarButtonCamera:
            [self openCamera];
            break;
            
        case WeiboComposeKeyboardToolBarButtonPhoto:
            [self openPhotoAlbum];
        default:
            break;
    }
}

- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openPhotoAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/* camera和photoLibrary共用此方法 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.postPhotoCollectionView addPhoto:info[UIImagePickerControllerOriginalImage]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
