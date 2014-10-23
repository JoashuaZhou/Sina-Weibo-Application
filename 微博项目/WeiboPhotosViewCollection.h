//
//  WeiboPhotosViewCollection.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboPhotosViewCollection : UIView

@property (nonatomic, strong) NSArray *photos;

+ (CGSize)getPhotosViewCollectionSize:(NSInteger)count;

@end
