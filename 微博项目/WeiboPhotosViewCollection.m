//
//  WeiboPhotosViewCollection.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboPhotosViewCollection.h"
#import "WeiboPhotoView.h"
#import "WeiboPhotoModel.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation WeiboPhotosViewCollection

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (NSInteger i = 0; i < numberOfPhotoViews; i++) {
            WeiboPhotoView *photoView = [[WeiboPhotoView alloc] init];
            photoView.userInteractionEnabled = YES; // 打开交互，添加手势识别才能识别得到
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabPhotoView:)];
            photoView.tag = i;
            [photoView addGestureRecognizer:recognizer];
            [self addSubview:photoView];
        }
    }
    return self;
}

- (void)tabPhotoView:(UITapGestureRecognizer *)recognizer
{
    int count = self.photos.count;
    
    // 1.封装图片数据
    NSMutableArray *myphotos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 一个MJPhoto对应一张显示的图片
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        
        mjphoto.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        
        WeiboPhotoModel *photoModel = self.photos[i];
        NSString *photoUrl = [photoModel.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        mjphoto.url = [NSURL URLWithString:photoUrl]; // 图片路径
        
        [myphotos addObject:mjphoto];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = recognizer.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = myphotos; // 设置所有的图片
    [browser show];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    for (NSInteger i = 0; i < numberOfPhotoViews; i++) {
        WeiboPhotoView *photoView = self.subviews[i];
        
        if (i < photos.count) {     // 如果图片还没显示完
            photoView.hidden = NO;
            
            photoView.photoModel = photos[i];
            
            NSInteger maxColumn = (photos.count == 4) ? 2 : 3;  // 如果图片总数是4，就是4宫格显示，其他都用9宫格显示
            NSInteger row = i / maxColumn;
            NSInteger column = i % maxColumn;
            photoView.frame = CGRectMake(column * (photoViewWidth + photoMargin), row * (photoViewHeight + photoMargin), photoViewWidth, photoViewHeight);
            
            if (photos.count == 1) {
                photoView.contentMode = UIViewContentModeScaleAspectFit;
                photoView.clipsToBounds = NO;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;  // 如果不剪掉，图片会多出来
            }
        } else {
            photoView.hidden = YES;
        }
    }
}

+ (CGSize)getPhotosViewCollectionSize:(NSInteger)count
{
    // 一行最多有3列
    int maxColumns = (count == 4) ? 2 : 3;
    
    //  总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * photoViewHeight + (rows - 1) * photoMargin;
    
    // 总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * photoViewWidth + (cols - 1) * photoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
