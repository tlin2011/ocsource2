//
//  HuaxoUtil.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "HuaxoUtil.h"
#import <UIKit/UIKit.h>
#import "SQLDataBase.h"

@implementation HuaxoUtil

+(NSString*)getFriendlyDistance:(NSNumber*)l
{
    long len = [l integerValue];
    if(len<=100)
        return @"100m";
    if(len<1000)
        return [NSString stringWithFormat:@"%ldm",(long)(len/100)*100] ;
    return [NSString stringWithFormat:@"%ldkm",(long)(len/1000)];
}
+(void)showMsg:(NSString*)msg title:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
    [alertView show];
}

+(BOOL)isLogined
{
    return [HuaxoUtil getPhoneStr].length>2;
}

+(BOOL)hasUdid
{
    return [HuaxoUtil getUdidStr].length>2;
}
+(BOOL)hasSessionId
{
    return [HuaxoUtil getSessionIdStr].length>2;
}
+(NSString*)getUdidStr
{
    SQLDataBase * sql = [SQLDataBase new];
    NSString* udid = [sql queryWithCondition:@"phone_uid"];
    udid = udid ?udid:@"0";
    NSLog(@"getUdidStr-udid:%@",udid);
    udid = [NSString stringWithFormat:@"%@",udid];
    return udid;
}
+(NSString*)getPhoneStr
{
    SQLDataBase * sql = [SQLDataBase new];
    NSString* phone = [sql queryWithCondition:@"phone"];
    phone= phone ? phone: @"0";
    phone = [NSString stringWithFormat:@"%@",phone];
    return phone;
}
+(NSString*)getSafeMd5Str
{
    SQLDataBase * sql = [SQLDataBase new];
    NSString* safe_md5 = [sql queryWithCondition:@"safe_md5"];
    safe_md5 = safe_md5 ?safe_md5:@"null";
    return safe_md5;
}
+(NSString*)getSessionIdStr
{
    SQLDataBase * sql = [SQLDataBase new];
    NSString* session_id = [sql queryWithCondition:@"session_id"];
    session_id = session_id ?session_id:@"0";
    NSLog(@"session-id:%@",session_id);
    return session_id;
}

+(long long)getFileSize:(NSString*) file
{
    @try {
        long  long imgSize=0;
        NSError *error = nil;
        NSFileManager *fm  = [NSFileManager defaultManager];
        NSDictionary* dictFile = [fm attributesOfItemAtPath:file error:&error];
        if (!error)
        {
            imgSize = [dictFile fileSize]; //得到文件大小
        }
        return imgSize ;
    }
    @catch (NSException *exception) {
        NSLog(@"getMyFileSize-exception:%@",exception);
    }
    @finally {
    }
    return 0;
}
@end
