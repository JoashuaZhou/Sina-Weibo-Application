//
//  UIImage+resizeImage.h
//  QQ聊天界面
//
//  Created by Joshua Zhou on 14-8-24.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (resizeImage)

+ (UIImage *)resizeImage:(UIImage *)image;
+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;

@end
