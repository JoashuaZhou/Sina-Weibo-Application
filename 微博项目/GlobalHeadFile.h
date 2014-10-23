//
//  GlobalHeadFile.h
//  微博项目
//
//  Created by Joshua Zhou on 14-9-18.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#ifndef _____GlobalHeadFile_h
#define _____GlobalHeadFile_h

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)  // 判断是否为iOS7

#define featuresCount   3   // 新特性个数

/* 字体 */
#define newWeiboCountViewFont [UIFont systemFontOfSize:14]  // 提示获取到刷新微博数的字体

/* PhotoViewCollection属性 */
#define numberOfPhotoViews  9
#define photoViewWidth      90
#define photoViewHeight     90
#define photoMargin         5

#define WeiboButtonFont [UIFont systemFontOfSize:12]    // 每个微博底部工具栏的按钮字体

/* frameModel的属性 */
#define margin 8
#define WeiboNameFontSize       [UIFont boldSystemFontOfSize:15]
#define WeiboRepostNameFontSize [UIFont systemFontOfSize:14]
#define WeiboTimeFontSize       [UIFont systemFontOfSize:12]
#define WeiboSourceFontSize     WeiboTimeFontSize
#define WeiboTextFontSize       [UIFont systemFontOfSize:14]

#define titleHeightRatio    0.7     // tabBar按键的高度比例

#endif