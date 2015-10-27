//
//  PindaoFocusSQL.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoFocusSQL.h"
#import "FMDatabase.h"
#import "YRJSONAdapter.h"

static PindaoFocusSQL * sharedManager = nil;
@implementation PindaoFocusSQL


+(PindaoFocusSQL *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (BOOL) isFileExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

//插入数据
- (void)insertUid:(NSString *) uid list:(NSDictionary *)list{
    [self.class archiveListWithDic:list uid:uid];
}

//查询数据
- (NSDictionary *)queryListByUid:(NSString *)uid {
    NSDictionary *dic = [self.class unarchiveListWithUid:uid];
    if (dic && [dic[@"list"] isKindOfClass:[NSArray class]]) {
        return dic;
    }
    return nil;
}

//数据
- (void)queryAll{
    //todo
    
}

+ (NSDictionary *)unarchiveListWithUid:(NSString *)uid {
    NSString *fileName = [NSString stringWithFormat:@"PindaoFocus-%ld",(long)[uid integerValue]];
    return [self unarchiveListWithFileName:fileName];
}

//反归档
+ (NSDictionary *)unarchiveListWithFileName:(NSString *)fileName {
    //文件路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    //数据对象
    NSData * data =[[NSData alloc]initWithContentsOfFile:filePath];
    
    //    1.创建反归档对象
    NSKeyedUnarchiver *unArch = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //    2.解码 把对象解出来
    NSDictionary *list = [unArch decodeObjectForKey:@"PindaoFocus"];

    NSLog(@"list:%@",list);

    return list;
}


+ (void)archiveListWithDic:(NSDictionary*)dic uid:(NSString *)uid {
    NSLog(@"%ld",(long)[uid integerValue]);
    NSString *fileName = [NSString stringWithFormat:@"PindaoFocus-%ld",(long)[uid integerValue]];
    [self archiveListWithDic:dic andFileName:fileName];
}
//归档
+ (void)archiveListWithDic:(NSDictionary*)dic andFileName:(NSString *)fileName {
    //文件路径
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //    1.创建一个可变长度的data
    NSMutableData *md = [NSMutableData data];
    //    2.创建归档对象
    NSKeyedArchiver *arch = [[NSKeyedArchiver alloc]initForWritingWithMutableData:md];
    //    3.开始编码 把对象编码进去
    [arch encodeObject:dic forKey:@"PindaoFocus"];
    //    4.完成编码
    [arch finishEncoding];
    
    [md writeToFile:filePath atomically:YES];
    
}
@end
