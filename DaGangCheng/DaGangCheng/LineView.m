//
//  LineView.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "LineView.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@implementation LineView



-(void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, kHexRGBAlpha(0xe8e8e8,1).CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context,0,5);
    CGContextAddLineToPoint(context,0,35);
    CGContextStrokePath(context);
    
    
}

@end
