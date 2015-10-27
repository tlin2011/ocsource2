//
//  ZBTUrlCacher.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-20.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface ZBTUrlCacher : NSObject
@property (nonatomic, copy) NSString * sqlPath;


- (BOOL)createSQL;      //创建表

- (void)insertUrlStr:(NSString *)urlstr andJson:(NSDictionary *)json;            //插入数据

- (NSDictionary *)queryByUrlStr:(NSString *)urlStr;   //查询数据

- (void)queryAll;      //查询所有数据
@end
