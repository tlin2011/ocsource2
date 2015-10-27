//
//  PindaoFocusSQL.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PindaoFocusSQL : NSObject


+(PindaoFocusSQL *)sharedManager;

//插入数据
- (void)insertUid:(NSString *) uid list:(NSDictionary *)list;

//查询数据
- (NSDictionary *)queryListByUid:(NSString *)uid;

//查询所有数据
- (void)queryAll;

//- (void)removeCacher; //清除缓存
@end
