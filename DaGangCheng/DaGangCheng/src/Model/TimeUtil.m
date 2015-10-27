//
//  TimeUtil.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil


+(NSString*)getFriendlyTime:(NSNumber*) timestamp
{
    long time = [timestamp longValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString* nowYear = [TimeUtil getDateYearStr:[NSDate new]];
    NSString* timeYear= [TimeUtil getDateYearStr:date];
    
    if([nowYear compare:timeYear]==NSOrderedSame){
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    }
}

+(NSString*)getFriendlySimpleTime:(NSNumber*) timestamp
{
    long time = [timestamp longValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString* nowYear = [TimeUtil getDateYearStr:[NSDate new]];
    NSString* timeYear= [TimeUtil getDateYearStr:date];
    
    if([nowYear compare:timeYear]==NSOrderedSame){
        long nowTimeSec = [TimeUtil getCurrentTimestamp];
        long diff  = nowTimeSec  -time;
		long minutes = diff / 60;
		long hours = minutes / 60;
		//long days = hours / 24;
		//long months = days/30;
		//long years = months = days/365;
		if(diff <60)
		{
			return GDLocalizedString(@"刚刚");
		}
		if(minutes  <60 )
		{
			return [NSString stringWithFormat:@"%ld%@", minutes,GDLocalizedString(@"分钟前")];
		}
		if( hours < 24 )
		{
            return [NSString stringWithFormat:@"%ld%@", hours,GDLocalizedString(@"小时前")];
		}
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    }
}

+(NSString*)getPostTime:(NSNumber*) timestamp
{
    long time = [timestamp longValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString* nowYear = [TimeUtil getDateYearStr:[NSDate new]];
    NSString* timeYear= [TimeUtil getDateYearStr:date];
    
    if([nowYear compare:timeYear]==NSOrderedSame){
        long nowTimeSec = [TimeUtil getCurrentTimestamp];
        long diff  = nowTimeSec  -time;
		long minutes = diff / 60;
		long hours = minutes / 60;
		//long days = hours / 24;
		//long months = days/30;
		//long years = months = days/365;
		if(diff <60)
		{
			return GDLocalizedString(@"刚刚");
		}
		if(minutes  <60 )
		{
			return [NSString stringWithFormat:@"%ld%@", minutes,GDLocalizedString(@"分钟前")];
		}
		if( hours < 24 )
		{
            return [NSString stringWithFormat:@"%ld%@", hours,GDLocalizedString(@"小时前")];
		}
        [dateFormatter setDateFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:date];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM"];
        return [dateFormatter stringFromDate:date];
    }
}

+(BOOL)is24Inner:(NSNumber*) timestamp
{
    long time = [timestamp longValue];
    long nowTimeSec = [TimeUtil getCurrentTimestamp];
    return nowTimeSec-time<24*60*60;
}
+(long)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return a;
}

+(double)getCurrentTimestampDouble
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    return a;
}

+(NSString*)getDateYearStr:(NSDate*) date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    return [dateFormatter stringFromDate:date];
}

+ (NSTimeInterval)getTimeIntervalFromString:(NSString *)string {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSTimeInterval interval = [inputDate timeIntervalSince1970];
    return interval;
}

@end
