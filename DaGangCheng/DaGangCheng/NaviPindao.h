//
//  NaviPindao.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviPindao : NSObject <NSCoding, NSCopying, NSMutableCopying>
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;


+ (NSArray *)naviPindaoArrWithArr:(NSArray *)arr;
+ (BOOL)isArr:(NSArray *)arr equalityToArr:(NSArray *)arr2;
//删除数组中的naviPindao
+ (NSArray *)arr:(NSArray *)arr removeNaviPindao:(NaviPindao *)pindao;
//向数组中添加naviPindao
+ (NSArray *)arr:(NSArray *)arr addNaviPindao:(NaviPindao *)pindao;

//第一步：删
- (void)removeNoExistNaviPindaoWithNaviPindaoArr:(NSArray *)arr;
//第二步：增
- (void)addNaviPindaoWithNaviPindaoArr:(NSArray *)arr;

+ (void)archiveDisplayList:(NSArray *)list;
+ (void)archiveDeleteList:(NSArray *)list;
+ (NSArray *)unarchiverDisplayList;
+ (NSArray *)unarchiverDeleteList;
@end
