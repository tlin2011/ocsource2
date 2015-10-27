//
//  ZBReport.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequest.h"
#import "ApiUrl.h"

typedef NS_ENUM(NSInteger, ZBReportKind) {
    /**
     * The post.
     */
    ZBReportKindPost = 1,
    /**
     * The reply.
     */
    ZBReportKindReply,
    /**
     * The subReply.
     */
    ZBReportKindSubReply
};

@interface ZBReport : NSObject

/**
 *  举报
 *
 *  @param kindId     举报的内容ID
 *  @param gUid       被举报的人
 *  @param uid        举报的人
 *  @param praiseKind 举报的类型
 */
+ (void)reportWithKindId:(NSString *)kindId getReportUid:(NSString *)gUid reportUid:(NSString *)uid reportKind:(ZBReportKind)reportKind reason:(NSString *)reason;

/**
 *  举报+回调
 *
 *  @param kindId     举报的内容ID
 *  @param gUid       被举报的人
 *  @param uid        举报的人
 *  @param praiseKind 举报的类型
 *  @param completedBlock 回调
 */
+ (void)reportWithKindId:(NSString *)kindId getReportUid:(NSString *)gUid reportUid:(NSString *)uid reportKind:(ZBReportKind)reportKind reason:(NSString *)reason completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

+ (void)reportWithParameters:(NSDictionary *)parameters completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;


/**
 *  查询举报
 *
 *  @param kindId         举报的内容ID
 *  @param uid            举报的人
 *  @param praiseKind     举报的类型
 *  @param completedBlock 回调
 */
+ (void)isReportWithKindId:(NSString *)kindId reportUid:(NSString *)uid reportKind:(ZBReportKind)reportKind completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;

+ (void)isReportWithParameters:(NSDictionary *)parameters completed:(void(^)(BOOL result, NSString *msg, NSError *error))completedBlock;
@end
