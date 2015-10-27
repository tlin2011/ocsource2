//
//  ZBPraise.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import "ApiUrl.h"
#import "ZBAppSetting.h"

typedef NS_ENUM(NSInteger, ZBPraiseKind) {
    /**
     * The post.
     */
    ZBPraiseKindPost = 1,
    /**
     * The reply.
     */
    ZBPraiseKindReply,
    /**
     * The subReply.
     */
    ZBPraiseKindSubReply
};

@interface ZBPraise : NSObject

/**
 *  点赞
 *
 *  @param kindId     赞的内容ID
 *  @param gUid       收到赞的人
 *  @param uid        点赞的人
 *  @param praiseKind 赞的类型
 */
+ (void)praiseWithKindId:(NSString *)kindId getPraiseUid:(NSString *)gUid praisedUid:(NSString *)uid praiseKind:(ZBPraiseKind)praiseKind;

/**
 *  点赞+回调
 *
 *  @param kindId     赞的内容ID
 *  @param gUid       收到赞的人
 *  @param uid        点赞的人
 *  @param praiseKind 赞的类型
 *  @param completedBlock 回调
 */
+ (void)praiseWithKindId:(NSString *)kindId getPraiseUid:(NSString *)gUid praisedUid:(NSString *)uid praiseKind:(ZBPraiseKind)praiseKind completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

+ (void)praiseWithParameters:(NSDictionary *)parameters completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

/**
 *  查询点赞
 *
 *  @param kindId         赞的内容ID
 *  @param uid            点赞的人
 *  @param praiseKind     赞的类型
 *  @param completedBlock 回调
 */
+ (void)isPraiseWithKindId:(NSString *)kindId praisedUid:(NSString *)uid praiseKind:(ZBPraiseKind)praiseKind completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

+ (void)isPraiseWithParameters:(NSDictionary *)parameters completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;
@end
