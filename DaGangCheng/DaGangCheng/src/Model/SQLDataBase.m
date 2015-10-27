//
//  SQLDataBase.m
//  DaGangCheng
//
//  Created by huaxo on 14-2-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "SQLDataBase.h"
static NSString * const fileName = @"userSqliteXq.db";
@implementation SQLDataBase

//创建表
- (BOOL)createSQL {
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    //NSLog(@"%@",self.sqlPath);
    
    //开,判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return NO;
    }
    
    //操作
    [database executeUpdate:@"create table if not exists user (key text PRIMARY KEY NOT NULL, value text)"];
    
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

-(void)save:(NSDictionary *)aDic
{
    [self deleteData];
    for (int i =0; i<[aDic allKeys].count; i++) {
        NSString *key = [[aDic allKeys]objectAtIndex:i];
        NSString *value = [NSString stringWithFormat:@"%@",[aDic objectForKey:key]];
        [self updateValue:value key:key];
        NSLog(@"key-values:(%@,%@)",key,value);
    }
}

-(void)deleteData
{
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return;
        };
    };
    
    //开判
    if (![database open]) {
        return;
    }
    
    //操作
    [database executeUpdate:@"delete from user"];
    
    //关闭
    [database close];
    
}

-(NSDictionary*)query
{
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"%@",self.sqlPath);

    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return Nil;
        };
    };
    
    //开判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        return nil;
    }

    //操作
    FMResultSet * resultSet =[database executeQuery:@"select * from user"];
    
    //键值数组
    NSMutableArray *keyArr =[[NSMutableArray alloc]init];
    NSMutableArray *valueArr =[[NSMutableArray alloc]init];

    //遍历查询
    while ([resultSet next]) {
        NSString * key = [resultSet stringForColumn:@"key"];
        NSString * value = [resultSet stringForColumn:@"value"];
        [keyArr addObject:key];
        if ([key isEqualToString:@"update"]) {
            [valueArr addObject:@""];
        }else {
            [valueArr addObject:value];
        }
    }
    NSDictionary * aDcit =[NSDictionary dictionaryWithObjects:valueArr forKeys:keyArr];
    
    //关闭
    [database close];
    
    return aDcit;
}




-(NSString *)queryWithCondition:(NSString *)condition
{
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return Nil;
        };
    };
    
    //开判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        NSLog(@"database open failed!");
        return nil;
    }
    
    //操作
    FMResultSet * resultSet =[database executeQuery:@"select * from user where key = ?",condition];
    
    //遍历查询
    NSString * myValue = nil;
    while ([resultSet next]) {
        myValue = [resultSet stringForColumn:@"value"];
    }
    //关闭
    [database close];
    
    return myValue;
}


-(void)change:(NSString *)originalStr andLaterStr:(NSString *)laterStr
{
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return;
        };
    };
    
    //开判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        NSLog(@"database open failed!");
        return;
    }
    
    //操作
    [database executeUpdate:@"update user set value = ? where value = ?",originalStr,laterStr];

    //关闭
    [database close];

}

-(void)updateValue:(NSString *)value key:(NSString *)key
{
    //路径
    self.sqlPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    //判断数据库文件是否存在
    if (![self isFileExist:self.sqlPath]) {
        if (![self createSQL]) {
            return;
        };
    };
    
    //开判
    FMDatabase * database =[FMDatabase databaseWithPath:self.sqlPath];
    if (![database open]) {
        NSLog(@"database open failed!");
        return;
    }
    
    //操作
    BOOL bRet = [database executeUpdate:@"insert into user (key, value) values(?,?)",key,value];
    NSLog(@"updateValue:%@,value:%@,bRet:%d",key,value, bRet);
    if(!bRet)
    {
        BOOL bRet = [database executeUpdate:@"update user set value = ? where key = ?",value,key];
        //bRet = [database executeUpdate:@"insert into user values(?,?)",key,value];
        NSLog(@"updateValue:%d insert into!",bRet);
    }
    //关闭
    [database close];
    
}


@end
