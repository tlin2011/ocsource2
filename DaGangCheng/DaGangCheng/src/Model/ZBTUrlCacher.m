//
//  ZBTUrlCacher.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-20.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTUrlCacher.h"
#import "YRJSONAdapter.h"

#define FileName @"UrlCacher.db"
@implementation ZBTUrlCacher
//创建表
- (BOOL)createSQL {
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:FileName];
    //NSLog(@"%@",self.sqlPath);
    
    //开,判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return NO;
    }
    
    //操作
    [database executeUpdate:@"create table urlTable (id text PRIMARY KEY NOT NULL, content text)"];
    
    //关闭
    [database close];
    
    return YES;
}

- (BOOL) isFileExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

//插入数据
- (void)insertUrlStr:(NSString *)urlstr andJson:(NSDictionary *)json{
    
    NSString *content = [json JSONString];
    if (!urlstr || !content ) {
        NSLog(@"插入数据为空 id:%@, content:%@",urlstr,content);
        return;
    }
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:FileName];
    //NSLog(@"%@",self.sqlPath);
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return;
        };
    };
    
    //开,判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return;
    }
    
    //操作
    BOOL res = [database executeUpdate:@"replace into urlTable (id, content) values (?, ?)",urlstr,content];
    if (!res) {
        
        NSLog(@"error when insert db table");
    } else {
        NSLog(@"success to insert db table");
    }
    //关闭
    [database close];
}

//查询数据
- (NSDictionary *)queryByUrlStr:(NSString *)urlStr {
    if (!urlStr) {
        return nil;
    }
    
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:FileName];
    //NSLog(@"%@",self.sqlPath);
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return Nil;
        };
    };
    
    //开,判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return Nil;
    }
    
    //操作
    FMResultSet *rs = [database executeQuery:@"select content from urlTable where id = ?",urlStr];
    NSString *json = nil;
    while ([rs next]) {
        json = [rs stringForColumn:@"content"];
    }
    //关闭
    [database close];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDic = [jsonData objectFromJSONData];
    return resultDic;
}

//查询所有数据
- (void)queryAll{
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:FileName];
    //NSLog(@"%@",self.sqlPath);
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return;
        };
    };
    
    //开,判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return;
    }
    
    //操作
    FMResultSet *rs = [database executeQuery:@"select * from urlTable"];
    int i=0;
    while ([rs next]) {
        NSString *Id = [rs stringForColumn:@"id"];
        NSString *content = [rs stringForColumn:@"content"];
        NSLog(@"urlTable_num:%d,ID:%@,content:%@",i++,Id,content);
    }
    //关闭
    [database close];
    
}

//清除缓存
- (void)removeCacher {

}
@end
