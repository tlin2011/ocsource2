//
//  NSString+ZYFontSize.h
//
//  Created by 郑遥 on 14-12-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ZYFontSize)

/**
 *  取一段文字内容的实际尺寸
 *
 *  @param font 字体大小
 *  @param size 一段文字内容的最大尺寸
 *
 *  @return 返回文字的尺寸
 */
- (CGSize)textSizeWithFont:(UIFont *) font andMaxSzie:(CGSize) size;

@end
