//
//  SQLDataBase.h
//  DaGangCheng
//
//  Created by huaxo on 14-2-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface SQLDataBase : NSObject
@property (nonatomic, copy) NSString * sqlPath;
//创建表
- (BOOL)createSQL;

//保存
-(void)save:(NSDictionary *) aDic;

//删除
-(void)deleteData;

//查询
-(NSDictionary*)query;

//有条件查询
-(NSString*)queryWithCondition:(NSString*)condition;

//修改
-(void)change:(NSString*)originalStr andLaterStr:(NSString*)laterStr;

-(void)updateValue:(NSString *)value key:(NSString *)key;
@end
