//
//  PostLockedSQL.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PostLockedSQL.h"
#define FileName @"PostLockedSqlite.db"

@implementation PostLockedSQL
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
    NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT NOT NULL UNIQUE, '%@' INTEGER)",@"POST",@"id",@"post_id",@"time"];
    [database executeUpdate:sqlCreateTable];
    
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
- (void)insertPostId:(NSString *)postId{
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
    double t = [[NSDate date] timeIntervalSince1970];
    
    NSString *insertSql = [NSString stringWithFormat:
                            @"INSERT INTO '%@' ('%@', '%@') VALUES ('%@', '%f')",@"POST",@"post_id",@"time",postId,t];
    BOOL res = [database executeUpdate:insertSql];
    if (!res) {
        
        NSLog(@"error when insert db table");
    } else {
        NSLog(@"success to insert db table");
    }
    //关闭
    [database close];
}

//查询数据是否存在
- (BOOL)isExistingByPostId:(NSString *)postId {
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:FileName];
    //NSLog(@"%@",self.sqlPath);
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return NO;
        };
    };
    
    //开,判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return NO;
    }
    
    //操作
    NSString *querySql = [NSString stringWithFormat:
                           @"SELECT * FROM %@ where %@ = '%@'",@"POST",@"post_id",postId];

    FMResultSet *rs = [database executeQuery:querySql];
    while ([rs next]) {
        NSString *pId = [rs stringForColumn:@"post_id"];
        if ([pId isEqualToString:pId]) {
            [database close];
            return YES;
        }
    }
    //关闭
    [database close];
    
    return NO;
}

//数据
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
    NSString *querySql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",@"POST"];
    FMResultSet *rs = [database executeQuery:querySql];
    while ([rs next]) {
        int Id = [rs intForColumn:@"id"];
        NSString *pId = [rs stringForColumn:@"post_id"];
        double time = [rs doubleForColumn:@"time"];
        NSLog(@"ID:%d,Post_id:%@,Time:%lf",Id,pId,time);
    }
    //关闭
    [database close];

}

//清除缓存
- (void)removeCacher {
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
    
    double t = [[NSDate date] timeIntervalSince1970] - 60*24*60*60;//60*24*60*60
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM POST where time < %f",t];
    //NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM POST"];
    BOOL res = [database executeUpdate:deleteSql];
    
    if (!res) {
        NSLog(@"error when delete db table");
    } else {
        NSLog(@"success to delete db table");
    }
    //关闭
    [database close];
}

@end
