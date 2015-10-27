//
//  ReplyManagerView.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ReplyManagerView.h"

#define ButtonTitleHeight 32
#define ButtonTitleWidth 70

@interface ReplyManagerView ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *bgButton;

@property (nonatomic, assign) CGPoint viewOringin;

@end

@implementation ReplyManagerView

- (id)initWithButtonTitles:(NSArray *)titles delegate:(id<ReplyManagerViewDelegate>)delegate origin:(CGPoint)point{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        self.viewOringin = point;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (int i=0; i<self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置button上的正常情况下显示的图片
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@评论_查看话题.png",self.titles[i]]] forState:UIControlStateNormal];
        //设置button上的被点击后显示的图片
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@评论_查看话题_h.png",self.titles[i]]] forState:UIControlStateHighlighted];
        //设置button上图片的偏移量
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) ];
        //设置button大小
        btn.frame = CGRectMake(ButtonTitleWidth * i, 0, ButtonTitleWidth, ButtonTitleHeight);
        //设置button方法的实现
        [btn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        //设置button上的正常情况下显示的字体的颜色
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //设置button上的被点击后的显示的字体颜色
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        //设置button上字体的偏移量
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"评论操作的背景_查看话题.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"评论操作的背景_查看话题_h.png"] forState:UIControlStateHighlighted];
        btn.tag = i;
        
        [self.view addSubview:btn];

        if (i == self.titles.count - 1) {
            continue;
        }
        
        CGRect ivFrame = btn.frame;
        ivFrame.origin.x = ivFrame.size.width-1;
        ivFrame.size.width = 1;
        ivFrame.origin.y = ivFrame.size.height/4.0+1;
        UIImageView *iv = [[UIImageView alloc] initWithFrame:ivFrame];
        [iv setImage:[UIImage imageNamed:@"评论操作的分割线_查看话题.png"]];
        [btn addSubview:iv];
    }
    
    self.view.bounds = CGRectMake(0, 0, ButtonTitleWidth * self.titles.count, ButtonTitleHeight);
}

- (void)show {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpOutside];
    
    self.frame = CGRectZero;
    AppDelegate *app = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [[app window] addSubview:self];
    [[app window] addSubview:btn];
    
    self.bgButton = btn;
    
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(self.viewOringin.x-self.view.bounds.size.width, self.viewOringin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSLog(@"bgview frame %@",NSStringFromCGRect(BgView.frame));
    BgView.clipsToBounds = YES;
    [[app window] addSubview:BgView];
    self.bgView = BgView;
    
    CGRect startFrame = self.view.bounds;
    startFrame.origin.x = startFrame.size.width;
    
    CGRect endFrame = self.view.bounds;
    endFrame.origin.x = 0;
    
    self.view.frame = startFrame;
    self.view.layer.cornerRadius = 3;
    self.view.layer.borderColor = [UIColor grayColor].CGColor;
    self.view.layer.borderWidth = 0.5;
    self.view.layer.masksToBounds = YES;
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
    if ([self.delegate respondsToSelector:@selector(replyManagerView:selectedButtonTitle:)]) {
        [self.delegate replyManagerView:self selectedButtonTitle:self.titles[sender.tag]];
        
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.2];
    }
}

- (void)dealloc {
    
}
@end
