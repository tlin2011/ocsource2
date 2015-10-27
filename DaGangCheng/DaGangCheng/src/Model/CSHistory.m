//
//  CSHistory.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "CSHistory.h"
#import "ArchiverAndUnarchiver.h"

static NSString* const CSHISTORY_KEY = @"CSHISTORY_BACK_KEY";
static NSString* const CS_POST_TIPS = @"话题";
static NSString* const CS_PINDAO_TIPS = @"频道";

#define CS_MAX_NUM 500;

@implementation CSHistory
+(void)saveLog:(NSArray*)list
{
    //归档处理
    ArchiverAndUnarchiver *myArchiver =[[ArchiverAndUnarchiver alloc] init];
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:CSHISTORY_KEY];
    [myArchiver archiverPath:filePath andData:list andForKey:CSHISTORY_KEY];
}
+(NSDictionary*)getPostLog:(NSNumber*)post_id title:(NSString*)title
{
    NSDictionary* dic = @{@"id":post_id,@"title":title,@"kind":CS_POST_TIPS,@"time":[NSNumber numberWithLong:[TimeUtil getCurrentTimestamp]]};
    return dic;
}
+(NSDictionary*)getPindaoLog:(NSNumber*)pid title:(NSString*)title
{
    if(!pid||!title) return nil;
    NSDictionary* dic = @{@"id":pid,@"title":title,@"kind":CS_PINDAO_TIPS,@"time":[NSNumber numberWithLong:[TimeUtil getCurrentTimestamp]]};
    return dic;
}
+(NSArray*)getCSHistors
{
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:CSHISTORY_KEY];
    //数据对象
    NSData * data =[[NSData alloc]initWithContentsOfFile:filePath];
    //反归档人
    NSKeyedUnarchiver * unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    NSArray* list = [unarchiver decodeObjectForKey:CSHISTORY_KEY];
    list = !list || [list count]<=0 ? [[NSArray alloc] init]:list;
    return list;
}
//去重
+(BOOL)delMutiSaveLog:(NSMutableArray*)list log:(NSDictionary*)log
{
    if(!list||!log) return NO;
    for(int i=0;i<[list count];i++)
    {
        NSNumber* xid = [list[i] objectForKey:@"id"];
        NSNumber* xid0= [log objectForKey:@"id"];
        NSString* kind= [list[i] objectForKey:@"kind"];
        NSString* kind0= [log objectForKey:@"kind"];
        if(!xid||!xid0||!kind||!kind0) continue;
        if([xid intValue]== [xid0 intValue] && [kind isEqualToString:kind0])
        {
            [list removeObjectAtIndex:i];
            return YES;
        }
    }
    return NO;
}
+(BOOL)addCSLog:(NSDictionary*) log
{
    if(!log) return NO;
    NSMutableArray* list = [[CSHistory getCSHistors] mutableCopy];
    BOOL bRet = [CSHistory delMutiSaveLog:list log:log];
    NSLog(@"remove muti log:%@ ret:%d",log,bRet);
    [list insertObject:log atIndex:0];
    [CSHistory saveLog:list];
    return YES;
}
+(BOOL)isPostCS:(NSDictionary*)dic
{
    if(!dic||![dic objectForKey:@"kind"]) return NO;
    NSString* kind = [dic objectForKey:@"kind"];
    return [kind isEqualToString:CS_POST_TIPS];
}
+(BOOL)isPindaoCS:(NSDictionary*)dic
{
    if(!dic||![dic objectForKey:@"kind"]) return NO;
    NSString* kind = [dic objectForKey:@"kind"];
    return [kind isEqualToString:CS_PINDAO_TIPS];
}
+(BOOL)hasCSLog:(NSDictionary*)log
{
    if(!log) return NO;
    NSMutableArray* list = [[CSHistory getCSHistors] mutableCopy];
    if(!list) return NO;
    for(int i=0;i<[list count];i++)
    {
        NSNumber* xid = [list[i] objectForKey:@"id"];
        NSNumber* xid0= [log objectForKey:@"id"];
        NSString* kind= [list[i] objectForKey:@"kind"];
        NSString* kind0= [log objectForKey:@"kind"];
        if(!xid||!xid0||!kind||!kind0) continue;
        if([xid intValue]== [xid0 intValue] && [kind isEqualToString:kind0])
        {
            return YES;
        }
    }
    return NO;
}
@end
