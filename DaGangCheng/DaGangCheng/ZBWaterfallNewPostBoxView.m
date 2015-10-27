//
//  ZBWaterfallNewPostBoxView.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-4.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWaterfallNewPostBoxView.h"

@implementation ZBWaterfallNewPostBoxView

- (void)initSubviews {
    [super initSubviews];
    
    //键盘按钮
    UIButton* keyboardBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 4, 50, 32)];
    [keyboardBtn setTitle:@"" forState:UIControlStateNormal];
    [keyboardBtn setImage:[UIImage imageNamed:@"icons06_2.png"] forState:UIControlStateNormal];
    //keyboardBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [keyboardBtn addTarget:self action:@selector(keyboardBtnClick:) forControlEvents:UIControlEventTouchUpInside];//keyboard.png
    [self addSubview:keyboardBtn];
    self.keyboardBtn = keyboardBtn;
}

- (void)keyboardBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(waterfallNewPostBoxViewClickKeyboardBtn)]) {
        [self.delegate waterfallNewPostBoxViewClickKeyboardBtn];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    CGRect startFrame = self.frame;
    startFrame.origin = CGPointMake(startFrame.origin.x, DeviceHeight - startFrame.size.height);
    self.frame = startFrame;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    
    //NSLog(@"%@", notification);
    //1. 通过notification的userInfo获取键盘的坐标系信息
    NSDictionary *userInfo = notification.userInfo;
    CGSize keyboardSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.superview bringSubviewToFront:self];
    
    CGRect endFrame = self.frame;
    //2. 计算输入框的坐标
    endFrame.origin = CGPointMake(endFrame.origin.x, self.superview.frame.size.height-keyboardSize.height - endFrame.size.height);
    
    //3. 动画地改变坐标
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions options = [userInfo[UIKeyboardAnimationCurveUserInfoKey]unsignedIntegerValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.frame = endFrame;
    } completion:nil];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
