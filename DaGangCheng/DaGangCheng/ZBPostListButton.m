//
//  ZBPostListButton.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-31.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPostListButton.h"

@implementation ZBPostListButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
}

- (CGFloat)buttonTitleWidth {
    NSString *title = [self currentTitle];
    CGSize size = [title sizeWithFont:self.titleLabel.font forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    if (!title || [title isEqualToString:@"0"]) {
        title = @"";
    }
    [super setTitle:title forState:state];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
