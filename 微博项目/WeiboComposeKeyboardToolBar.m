//
//  WeiboComposeKeyboardToolBar.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-19.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboComposeKeyboardToolBar.h"

@implementation WeiboComposeKeyboardToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background_os7"]]];
        
        /* 表情 */
        [self addToolButtonWithImageName:@"compose_emoticonbutton_background_os7" highlightedImageName:@"compose_emoticonbutton_background_highlighted_os7" buttonType:WeiboComposeKeyboardToolBarButtonEmotion];
        
        /* 照片 */
        [self addToolButtonWithImageName:@"compose_toolbar_picture_os7" highlightedImageName:@"compose_toolbar_picture_highlighted_os7" buttonType:WeiboComposeKeyboardToolBarButtonPhoto];
        
        /* 照相机 */
        [self addToolButtonWithImageName:@"compose_camerabutton_background_os7" highlightedImageName:@"compose_camerabutton_background_highlighted_os7" buttonType:WeiboComposeKeyboardToolBarButtonCamera];
        
        /* @ */
        [self addToolButtonWithImageName:@"compose_mentionbutton_background_os7" highlightedImageName:@"compose_mentionbutton_background_highlighted_os7" buttonType:WeiboComposeKeyboardToolBarButtonMention];
        
        /* 热门话题 */
        [self addToolButtonWithImageName:@"compose_trendbutton_background_os7" highlightedImageName:@"compose_trendbutton_background_highlighted_os7" buttonType:WeiboComposeKeyboardToolBarButtonTrend];
    }
    return self;
}

- (void)addToolButtonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName buttonType:(WeiboComposeKeyboardToolBarButtonType)buttonType
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightedImageName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    button.tag = buttonType;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)clickButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(WeiboComposeKeyboardToolBar:didClickBarButtonType:)]) {
        [self.delegate WeiboComposeKeyboardToolBar:self didClickBarButtonType:button.tag];
    }
}

#define numberOfButton 5
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth = self.bounds.size.width / numberOfButton;
    CGFloat buttonheight = self.bounds.size.height;
    for (NSInteger i = 0; i < numberOfButton; i++) {
        CGFloat buttonX = i * buttonWidth;
        UIButton *button = self.subviews[i];
        button.frame = CGRectMake(buttonX, 0, buttonWidth, buttonheight);
    }
}

@end
