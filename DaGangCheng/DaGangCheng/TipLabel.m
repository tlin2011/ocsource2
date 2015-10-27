//
//  TipLabel.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "TipLabel.h"

@implementation TipLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 14, 14);
        self.layer.cornerRadius = 7.0f;
        self.layer.masksToBounds = YES;
        self.font = [UIFont systemFontOfSize:12];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        self.hidden = YES;
    }
    return self;
}

- (void)setNum:(int)num {
    //限制
    if (num >= 99) {
        num = 99;
    }
    _num = num;
    if (_num < 1) {
        self.text = @"";
        self.hidden = YES;
        CGRect frame = self.frame;
        frame.size = CGSizeMake(14, 14);
        self.frame = frame;
    }else {
        self.text = [NSString stringWithFormat:@"%d", num];
        self.hidden = NO;
        NSString *str = self.text;
        CGSize size = [str sizeWithFont:self.font forWidth:320 lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = self.frame;
        frame.size = CGSizeMake(size.width+8, 14);
        self.frame = frame;
    }
}

@end
