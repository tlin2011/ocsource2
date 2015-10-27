//
//  PindaoThemeTitleView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoThemeTitleView.h"

@implementation PindaoThemeTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show {
    [super show];
    CGRect frame = self.bgView.frame;
    frame.origin.x = DeviceWidth/2.0 - frame.size.width/2.0;
    self.bgView.frame = frame;
}

@end
