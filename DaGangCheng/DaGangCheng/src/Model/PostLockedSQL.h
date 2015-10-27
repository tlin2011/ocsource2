//
//  PostLockedSQL.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface PostLockedSQL : NSObject
@property (nonatomic, copy) NSString * sqlPath;


- (BOOL)createSQL;  //创建表
- (void)insertPostId:(NSString *)postId; //插入数据
- (BOOL)isExistingByPostId:(NSString *)postId; //查询数据是否存在
- (void)queryAll; //查询所以数据
- (void)removeCacher; //清除缓存
@end
