//
//  PlayProgressBar.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PlayProgressBar.h"

@implementation PlayProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    //通知当前对象，重绘界面
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = self.bounds.size.width * 0.5;
    [path addArcWithCenter:center
                    radius:radius
                startAngle:M_PI_2 * 3
                  endAngle:M_PI_2 * 3 + M_PI * 2 * self.value
                 clockwise:YES];
    path.lineWidth = self.lineWidth;
    [self.strokeColor setStroke];
    [path stroke];
    
    CGContextRestoreGState(context);
}


@end
