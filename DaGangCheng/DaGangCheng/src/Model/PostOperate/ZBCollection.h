//
//  ZBPostCollection.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import "ApiUrl.h"

typedef NS_ENUM(NSInteger, ZBCollectionKind) {
    /**
     * The post.
     */
    ZBCollectionKindPost = 1,
    /**
     * The reply.
     */
    ZBCollectionKindReply,
    /**
     * The subReply.
     */
    ZBCollectionKindSubReply
};

@interface ZBCollection : NSObject

/**
 *  收藏
 *
 *  @param kindId     收藏的内容ID
 *  @param gUid       被收藏的人
 *  @param uid        收藏的人
 *  @param praiseKind 收藏的类型
 */
+ (void)collectionWithKindId:(NSString *)kindId getCollectionUid:(NSString *)gUid collectionUid:(NSString *)uid collectionKind:(ZBCollectionKind)collectionKind;

/**
 *  收藏+回调
 *
 *  @param kindId     收藏的内容ID
 *  @param gUid       被收藏的人
 *  @param uid        收藏的人
 *  @param praiseKind 收藏的类型
 *  @param completedBlock 回调
 */
+ (void)collectionWithKindId:(NSString *)kindId getCollectionUid:(NSString *)gUid collectionUid:(NSString *)uid collectionKind:(ZBCollectionKind)collectionKind completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

+ (void)collectionWithParameters:(NSDictionary *)parameters completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

/**
 *  查询收藏
 *
 *  @param kindId         收藏的内容ID
 *  @param uid            收藏的人
 *  @param praiseKind     收藏的类型
 *  @param completedBlock 回调
 */
+ (void)isCollectionWithKindId:(NSString *)kindId collectionUid:(NSString *)uid collectionKind:(ZBCollectionKind)collectionKind completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

+ (void)isCollectionWithParameters:(NSDictionary *)parameters completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

@end
