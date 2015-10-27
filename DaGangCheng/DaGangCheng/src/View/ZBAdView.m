//
//  ZBAdView.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBAdView.h"

@interface ZBAdView ()
@property (weak, nonatomic) UIButton *imageBtn;   //图片按钮
@property (weak, nonatomic) UIButton *ignoreBtn;  // 跳过按钮
@property (weak, nonatomic) UIButton *intoBtn;  // 跳转按钮
@property (weak, nonatomic) UIImageView *imageIv;    //图片

@end

@implementation ZBAdView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    UIButton *imageBtn = [[UIButton alloc] init];
    imageBtn.userInteractionEnabled = YES;
    [imageBtn addTarget:self action:@selector(intoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageBtn setAdjustsImageWhenHighlighted:NO];
    self.imageBtn = imageBtn;
    [self addSubview:imageBtn];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [iv setContentMode:UIViewContentModeScaleAspectFill];
    self.imageIv = iv;
    [self.imageBtn addSubview:iv];
    
    UIButton *intoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    intoBtn.backgroundColor = [UIColor blackColor];
    intoBtn.alpha = 0.5f;
    intoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [intoBtn setTitle:GDLocalizedString(@"立即查看") forState:UIControlStateNormal];
    [intoBtn addTarget:self action:@selector(intoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.intoBtn = intoBtn;
    self.intoBtn.hidden = YES;
    [self.imageBtn addSubview:intoBtn];
    
    UIButton *ignoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ignoreBtn.backgroundColor = [UIColor blackColor];
    ignoreBtn.alpha = 0.5f;
    ignoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [ignoreBtn setTitle:GDLocalizedString(@"跳过") forState:UIControlStateNormal];
    [ignoreBtn addTarget:self action:@selector(ignoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.ignoreBtn = ignoreBtn;
    [self.imageBtn addSubview:ignoreBtn];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageBtn.frame = self.bounds;
    self.imageIv.frame = self.imageBtn.bounds;
    self.intoBtn.frame = CGRectMake(0, self.imageBtn.height - 44, self.imageBtn.width, 44);
    self.ignoreBtn.frame = CGRectMake(self.imageBtn.width - 50, 28, 50, 30);
    
    NSURL *url = [NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[self.imageId integerValue] w:1000 ]];
    [self.imageIv sd_setImageWithURL:url];
}


/**
 *  类方法创建广告启动页
 */
+ (instancetype)adView
{
    return [[self alloc] init];
}

- (void)intoBtnClick
{
    ZBLog(@"intoBtnClick-----------------%s", __func__);
    if ([self.delegate respondsToSelector:@selector(adViewClickedAd:)]) {
        [self.delegate adViewClickedAd:self];
    }
}

- (void)ignoreBtnClick
{
    if ([self.delegate respondsToSelector:@selector(adViewIgnore:)]) {
        [self.delegate adViewIgnore:self];
    }
    ZBLog(@"ignoreBtnClick-----------------%s", __func__);
}

- (void)dealloc
{
    ZBLog(@"%s", __func__);
}

@end