//
//  NaviButton.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "NaviButton.h"

@implementation NaviButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor clearColor];
    
    self.lab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lab.layer.cornerRadius = 2.0f;
    self.lab.backgroundColor = [UIColor clearColor];
    self.lab.textColor = [UIColor clearColor];
    self.lab.font = [UIFont systemFontOfSize:15];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.clipsToBounds = YES;
    [self addSubview:self.lab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    self.lab.frame = CGRectMake(self.gapEdgeInsets.left, self.gapEdgeInsets.top, frame.size.width-self.gapEdgeInsets.left-self.gapEdgeInsets.right, frame.size.height-self.gapEdgeInsets.top-self.gapEdgeInsets.bottom);
    self.lab.text = [self currentTitle];
}

- (void)dealloc {

}

@end
