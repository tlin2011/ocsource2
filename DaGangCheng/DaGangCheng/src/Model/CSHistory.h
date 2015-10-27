//
//  CSHistory.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeUtil.h"

@interface CSHistory : NSObject

+(NSArray*)getCSHistors;

+(BOOL)addCSLog:(NSDictionary*) log;
+(NSDictionary*)getPostLog:(NSNumber*)post_id title:(NSString*)title;
+(NSDictionary*)getPindaoLog:(NSNumber*)pid title:(NSString*)title;

+(BOOL)isPostCS:(NSDictionary*)dic;
+(BOOL)isPindaoCS:(NSDictionary*)dic;

//存在log
+(BOOL)hasCSLog:(NSDictionary*)log;


@end
