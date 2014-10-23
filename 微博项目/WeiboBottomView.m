//
//  WeiboBottomView.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-17.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboBottomView.h"
#import "UIImage+resizeImage.h"

@interface WeiboBottomView ()

@property (nonatomic, weak) UIButton *repostButton;
@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) UIButton *attitudeButton;

@property (nonatomic, strong) NSMutableArray *dividerArray;

@end

@implementation WeiboBottomView

- (NSMutableArray *)dividerArray
{
    if (!_dividerArray) {
        _dividerArray = [[NSMutableArray alloc] init];
    }
    return _dividerArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage resizeImage:[UIImage imageNamed:@"timeline_card_bottom_background_os7"]]];
        self.userInteractionEnabled = YES;
        
        [self setupButtonsOnBottomView];
    }
    return self;
}

- (void)setupButtonsOnBottomView
{
    UIButton *repostButton = [self setupButtonTitle:@"转发" image:[UIImage imageNamed:@"timeline_icon_retweet_os7"] highlightedImage:[UIImage imageNamed:@"timeline_card_leftbottom_highlighted_os7"]];
    [self addSubview:repostButton];
    self.repostButton = repostButton;
    
    UIButton *commentButton = [self setupButtonTitle:@"评论" image:[UIImage imageNamed:@"timeline_icon_comment_os7"] highlightedImage:[UIImage imageNamed:@"timeline_card_middlebottom_highlighted_os7"]];
    [self addSubview:commentButton];
    self.commentButton = commentButton;
    
    UIButton *attitudeButton = [self setupButtonTitle:@"赞" image:[UIImage imageNamed:@"timeline_icon_unlike_os7"] highlightedImage:[UIImage imageNamed:@"timeline_card_rightbottom_highlighted_os7"]];
    [self addSubview:attitudeButton];
    self.attitudeButton = attitudeButton;
}

- (UIButton *)setupButtonTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    UIImage *resizedImage = [UIImage resizeImage:image];
    UIImage *resizedHighlightedImage = [UIImage resizeImage:highlightedImage];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:resizedImage forState:UIControlStateNormal];
    [button setBackgroundImage:resizedHighlightedImage forState:UIControlStateHighlighted];
    button.titleLabel.font = WeiboButtonFont;
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

/* 按钮分割线 */
#define dividerWidth    1
- (void)buttonDivider
{
    for (NSInteger i = 0; i < 2; i++) {
        UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_os7"]];
        [self.dividerArray addObject:divider];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth = ((self.bounds.size.width - 2 * dividerWidth) / self.subviews.count);
    CGFloat buttonHeight = self.bounds.size.height;
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIButton *button = self.subviews[i];
        button.frame = CGRectMake(i * (buttonWidth + dividerWidth), 0, buttonWidth, buttonHeight);
    }
    
    [self buttonDivider];
    for (NSInteger i = 0; i < self.dividerArray.count; i++) {
        UIImageView *divider = self.dividerArray[i];
        divider.frame = CGRectMake((i + 1) * buttonWidth + i * dividerWidth, 0, dividerWidth, self.bounds.size.height);
        [self addSubview:divider];
    }
}


/* 按钮上的文字变数字 */
- (void)setStatusModel:(WeiboStatusModel *)statusModel
{
    _statusModel = statusModel;
    
    [self setButtonTitle:statusModel.reposts_count atButton:self.repostButton];
    [self setButtonTitle:statusModel.comments_count atButton:self.commentButton];
    [self setButtonTitle:statusModel.attitudes_count atButton:self.attitudeButton];
}

- (void)setButtonTitle:(NSInteger)count atButton:(UIButton *)button
{
    if (count == 0) {
        return;
    }
    if (count > 10000) {
        float title = count / 10000.0;
        NSString *string = [NSString stringWithFormat:@"%.1f万", title];
        NSString *buttonTitle = [string stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
    } else {
        [button setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
    }
}

@end
