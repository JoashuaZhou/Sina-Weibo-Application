//
//  UIImage+resizeImage.m
//  QQ聊天界面
//
//  Created by Joshua Zhou on 14-8-24.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "UIImage+resizeImage.h"

@implementation UIImage (resizeImage)

+ (UIImage *)resizeImage:(UIImage *)image
{
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height
{
    return [image stretchableImageWithLeftCapWidth:image.size.width * width topCapHeight:image.size.height * height];
}

@end
