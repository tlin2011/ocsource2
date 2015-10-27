//
//  NaviPindaoDelView.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NaviPindaoDelView.h"

@implementation NaviPindaoDelView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGRect frame = self.frame;
    self.titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 6, frame.size.width-6*2, frame.size.height - 6*2)];
    self.titleBtn.layer.borderWidth = 0.5;
    self.titleBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleBtn.layer.cornerRadius = 5;
    self.titleBtn.layer.masksToBounds = YES;
    
    //self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.titleBtn.backgroundColor = UIColorFromRGB(0xefefef);
    [self.titleBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:self.titleBtn];
}
@end
