//
//  ZBCoreTextRegularMatch.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-16.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBCoreText.h"

@interface ZBCoreTextRegularMatch : NSObject

/**
 *  将字符切分存进数组
 */
+ (NSArray *)arrayFromString:(NSString *)string;

/**
 *  根据字符串返回 ZBCoreTextKind
 */
+ (ZBCoreTextKind)coreTextKindFromString:(NSString *)string;
@end
