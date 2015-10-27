//
//  PostZanAndReplyView.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PostZanAndReplyView.h"

@interface PostZanAndReplyView ()


@end

@implementation PostZanAndReplyView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

//- (void)setZanNum:(NSInteger)zanNum {
//    _zanNum = zanNum;
//    [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",(long)zanNum] forState:UIControlStateNormal];
//    [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",(long)zanNum] forState:UIControlStateSelected];
//}
//
//- (void)setReplyNum:(NSInteger)replyNum {
//    _replyNum = replyNum;
//    [self.replyBtn setTitle:[NSString stringWithFormat:@"%ld",(long)replyNum] forState:UIControlStateNormal];
//}

- (void)initSubviews {
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
    [line setImage:[UIImage imageNamed:@"赞和评论_barLine_查看话题"]];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];

    UIButton *zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置button上的正常情况下显示的图片
    [zanBtn setImage:[UIImage imageNamed:@"赞_tool_查看话题.png"] forState:UIControlStateNormal];
    //设置button上的被点击后显示的图片
//    [zanBtn setImage:[UIImage imageNamed:@"赞_查看话题_s.png"] forState:UIControlStateHighlighted];
    [zanBtn setImage:[[UIImage imageNamed:@"赞_tool_查看话题_s.png"] imageWithMobanThemeColor] forState:UIControlStateSelected];
    //设置button上图片的偏移量
//    [zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0) ];
    //设置button大小
    zanBtn.frame = CGRectMake(0, 1, 50, self.bounds.size.height-1);
    //设置button方法的实现
    [zanBtn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    //设置button上的正常情况下显示的字体的颜色
//    zanBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    //[btn setTitle:self.titles[i] forState:UIControlStateNormal];
//    [zanBtn setTitleColor:UIColorFromRGB(0x878d98) forState:UIControlStateNormal];
//    //设置button上的被点击后的显示的字体颜色
//    [zanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    //设置button上字体的偏移量
//    [zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    
//    [zanBtn setBackgroundImage:[UIImage imageNamed:@"矩形白.jpg"] forState:UIControlStateNormal];
//    [zanBtn setBackgroundImage:[UIImage imageNamed:@"矩形灰.jpg"] forState:UIControlStateHighlighted];
    zanBtn.tag = 0;
    [self addSubview:zanBtn];
    self.zanBtn = zanBtn;
    
    UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置button上的正常情况下显示的图片
    [replyBtn setImage:[UIImage imageNamed:@"铅笔_tool_查看话题.png"] forState:UIControlStateNormal];
    //设置button上的被点击后显示的图片
//    [replyBtn setImage:[UIImage imageNamed:@"评论数_查看话题_h.png"] forState:UIControlStateHighlighted];
    //设置button上图片的偏移量
    [replyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0) ];
    //设置button大小
    replyBtn.frame = CGRectMake(CGRectGetMaxX(zanBtn.frame), 8, self.bounds.size.width - CGRectGetMaxX(zanBtn.frame) - 10, self.bounds.size.height-8*2);
    //设置button方法的实现
    [replyBtn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    //设置button上的正常情况下显示的字体的颜色
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [replyBtn setTitle:GDLocalizedString(@"回复楼主") forState:UIControlStateNormal];
    [replyBtn setTitleColor:UIColorFromRGB(0x878d98) forState:UIControlStateNormal];
    //设置button上的被点击后的显示的字体颜色
//    [replyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //设置button上字体的偏移量
    [replyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    replyBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    replyBtn.layer.borderWidth = 1.0f;
    replyBtn.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
    replyBtn.layer.cornerRadius = 5.0f;
    replyBtn.layer.masksToBounds = YES;
    replyBtn.adjustsImageWhenHighlighted = NO;
//    [replyBtn setBackgroundImage:[UIImage imageNamed:@"矩形白.jpg"] forState:UIControlStateNormal];
//    [replyBtn setBackgroundImage:[UIImage imageNamed:@"矩形灰.jpg"] forState:UIControlStateHighlighted];
    replyBtn.tag = 1;
    [self addSubview:replyBtn];
    self.replyBtn = replyBtn;
//
//    
//    UIImageView *shuline = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0, self.bounds.size.height/3.0, 1, self.bounds.size.height/3.0)];
//    shuline.backgroundColor = UIColorFromRGB(0xdfdfdf);
//    [self addSubview:shuline];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)clickedButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(postZanAndReplyView:selectedTitle:)]) {
        NSString *title = nil;
        if (sender.tag == 0) {
            title = @"zan";
        } else if (sender.tag == 1) {
            title = @"reply";
        }
        [self.delegate postZanAndReplyView:self selectedTitle:title];
    }
}

@end