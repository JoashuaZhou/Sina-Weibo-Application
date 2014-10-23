//
//  WeiboTextView.m
//  微博项目
//
//  Created by Joshua Zhou on 14-9-18.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "WeiboTextView.h"

@interface WeiboTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation WeiboTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        [placeholderLabel setTextColor:[UIColor lightGrayColor]];
        placeholderLabel.numberOfLines = 0;     // 设置自动换行，防止别人把placeholder的文字设置得过长
        if (!self.font) {
            self.font = [UIFont systemFontOfSize:16];
        }
        placeholderLabel.font = self.font;      // placeholder的字体和textView的字体一样大
        [self insertSubview:placeholderLabel atIndex:0];
        self.placeholderLabel = placeholderLabel;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidChanged
{
    if (self.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    CGFloat placeholderMargin = 8;
    CGSize placeholderLabelSize = [placeholder boundingRectWithSize:CGSizeMake(self.bounds.size.width - 2 * placeholderMargin, self.bounds.size.height - 2 * placeholderMargin) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.placeholderLabel.font} context:nil].size;
    
    self.placeholderLabel.frame = CGRectMake(5, placeholderMargin, placeholderLabelSize.width, placeholderLabelSize.height);
    self.placeholderLabel.text = placeholder;
}

@end
