//
//  NaviPindaoView.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-3.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NaviPindaoView.h"

@implementation NaviPindaoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGRect frame = self.frame;
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, frame.size.width-6*2, frame.size.height - 6*2)];
    self.titleLab.layer.borderWidth = 0.5;
    self.titleLab.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleLab.layer.cornerRadius = 5;
    self.titleLab.layer.masksToBounds = YES;
    
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.titleLab];
    
    self.delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //self.delBtn.backgroundColor = [UIColor redColor];
    [self.delBtn setImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
    [self.delBtn setImageEdgeInsets:UIEdgeInsetsMake(-15, -15, 0, 0)];
    //self.delBtn.backgroundColor = [UIColor redColor];
    //self.backgroundColor = [UIColor orangeColor];
    [self addSubview:self.delBtn];
}

@end
