//
//  HuaxoUtil.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuaxoUtil :NSObject

+(NSString*)getFriendlyDistance:(NSNumber*)len;
+(void)showMsg:(NSString*)msg title:(NSString*)title;
+(long long)getFileSize:(NSString*) file;

+(NSString*)getUdidStr;
+(NSString*)getSafeMd5Str;
+(BOOL)isLogined;
+(BOOL)hasUdid;
+(BOOL)hasSessionId;

@end
