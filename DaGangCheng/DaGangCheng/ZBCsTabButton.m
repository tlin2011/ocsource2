//
//  ZBCsTabButton.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCsTabButton.h"
@interface ZBCsTabButton ()
@property (nonatomic, strong) NSMutableArray *btns;
@end

@implementation ZBCsTabButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(clickedSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



- (void)initSubviewsWithSuperView:(UIView *)supView {
    self.btns = [[NSMutableArray alloc] init];
    CGFloat y = self.frame.origin.y;
    for (int i=0; i<[self.btnInfoArr count]; i++) {
        NSDictionary *dic = self.btnInfoArr[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.origin.x, y-44, 100, 44)];
        [btn setImage:[UIImage imageNamed:dic[@"img"]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:dic[@"img_h"]] forState:UIControlStateHighlighted];
        [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        [supView addSubview:btn];
        [self.btns addObject:btn];
        y += 44;
    }
}

- (NSMutableArray *)btns {
    
    if (!_btns) {
        self.btns = [[NSMutableArray alloc] init];
        CGFloat y = self.frame.origin.y;
        for (int i=0; i<[self.btnInfoArr count]; i++) {
            NSDictionary *dic = self.btnInfoArr[i];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.origin.x, y-44, 100, 44)];
            [btn setImage:[UIImage imageNamed:dic[@"img"]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:dic[@"img_h"]] forState:UIControlStateHighlighted];
            [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
            btn.hidden = YES;
            if (self.superview) {
                [self.superview addSubview:btn];
            }
            [_btns addObject:btn];
            y += 44;
        }
    }
    return _btns;
}

- (void)clickedSelf:(UIButton *)sender {
    [self.btns performSelector:@selector(setHidden:) withObject:NO];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
