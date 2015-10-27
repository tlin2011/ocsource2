//
//  ZBNumberUtil.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-19.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBNumberUtil : NSObject
/**
 *  数字简写
 *
 *  @param integer <#integer description#>
 *
 *  @return 简写的字符串（最多五个数字长度）。
 */
+ (NSString *)shortStringByInteger:(NSInteger)integer;

/**
 *  数字简写
 *
 *  @param number <#number description#>
 *
 *  @return 简写的字符串（最多五个数字长度）。
 */
+ (NSString *)shortStringByNumber:(NSNumber *)number;

/**
 *  数字简写
 *
 *  @param string <#string description#>
 *
 *  @return 简写的字符串（最多五个数字长度）。
 */
+ (NSString *)shortStringByString:(NSString *)string;
@end
