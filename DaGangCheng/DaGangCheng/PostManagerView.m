//
//  PostManagerView.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-13.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PostManagerView.h"

#define ButtonTitleHeight 44

@interface PostManagerView ()
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) NSArray *images;

@end

@implementation PostManagerView

- (id)initWithButtonTitles:(NSArray *)titles delegate:(id<PostManagerViewDelegate>)delegate {
    self = [super init];
    if (self) {
        self.titles = titles;
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (int i=0; i<self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置button上的正常情况下显示的图片
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.titles[i][@"image"]]] forState:UIControlStateNormal];
        //设置button上的被点击后显示的图片
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_h.png",self.titles[i][@"image"]]] forState:UIControlStateHighlighted];
        //设置button上图片的偏移量
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0) ];
        //设置button大小
        btn.frame = CGRectMake(0, i*ButtonTitleHeight, 150, ButtonTitleHeight);
        //设置button方法的实现
        [btn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        //设置button上的正常情况下显示的字体的颜色
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn setTitle:self.titles[i][@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //设置button上的被点击后的显示的字体颜色
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        //设置button上字体的偏移量
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"矩形白.jpg"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"矩形灰.jpg"] forState:UIControlStateHighlighted];
        
        [self.view addSubview:btn];
        
        
        if (i == self.titles.count - 1) {
            continue;
        }
        
        CGRect ivFrame = btn.frame;
        ivFrame.origin.y = ivFrame.size.height-1;
        ivFrame.size.height = 1;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:ivFrame];
        iv.backgroundColor = UIColorFromRGB(0xd9d9d9);
        [btn addSubview:iv];
    }
    self.view.bounds = CGRectMake(0, 0, DeviceWidth, self.titles.count * ButtonTitleHeight);
}

- (void)show {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.5;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame = CGRectZero;
    AppDelegate *app = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [[app window] addSubview:self];
    [[app window] addSubview:btn];

    self.bgButton = btn;
    
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(DeviceWidth - 150, 64, 150, self.view.bounds.size.height)];
    BgView.clipsToBounds = YES;
    [[app window] addSubview:BgView];
    self.bgView = BgView;
    
    CGRect startFrame = self.view.bounds;
    startFrame.origin.y = - startFrame.size.height;
    
    CGRect endFrame = self.view.bounds;
    endFrame.origin.y = 0;
    
    self.view.frame = startFrame;
    [BgView addSubview:self.view];
    
    __block UIView *bManagerView = self.view;

    [UIView animateWithDuration:0.3 animations:^{
        bManagerView.frame = endFrame;
    } completion:^(BOOL finished) {
        //bManagerView.frame = endFrame;
    }];
}

- (void)clickedBtn:(UIButton *)sender {
    [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.2];
}

- (void)removeSelf {
    [self.bgButton removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)clickedButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(postManagerView:selectedButtonTitle:)]) {
        [self.delegate postManagerView:self selectedButtonTitle:[sender titleForState:UIControlStateNormal]];
        
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.2];
    }
}

- (void)dealloc {

}

@end
