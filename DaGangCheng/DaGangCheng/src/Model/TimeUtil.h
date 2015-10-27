//
//  TimeUtil.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

+(NSString*)getFriendlyTime:(NSNumber*) timestamp;
+(NSString*)getFriendlySimpleTime:(NSNumber*) timestamp;
+(NSString*)getDateYearStr:(NSDate*) date;
+(long)getCurrentTimestamp;
+(double)getCurrentTimestampDouble;
+(NSString*)getPostTime:(NSNumber*) timestamp;
+(BOOL)is24Inner:(NSNumber*) timestamp;
/**
 *  字符串转换为时间戳
 */
+ (NSTimeInterval)getTimeIntervalFromString:(NSString *)string;
@end
