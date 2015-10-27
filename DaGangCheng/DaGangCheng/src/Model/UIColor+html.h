//
//  UIColor+html.h
//  DaGangCheng
//
//  Created by huaxo on 15-4-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (html)
/**
 *  字符串转颜色
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

/**
 *  颜色转字符串
 */
+ (NSString *) changeUIColorToRGB:(UIColor *)color;
@end
