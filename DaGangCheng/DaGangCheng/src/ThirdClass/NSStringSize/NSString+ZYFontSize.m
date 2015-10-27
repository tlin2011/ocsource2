//
//  NSString+ZYFontSize.m
//
//  Created by 郑遥 on 14-12-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+ZYFontSize.h"

@implementation NSString (ZYFontSize)

- (CGSize)textSizeWithFont:(UIFont *) font andMaxSzie:(CGSize) size
{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end