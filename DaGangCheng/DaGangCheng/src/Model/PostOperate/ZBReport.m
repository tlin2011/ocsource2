//
//  ZBReport.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBReport.h"

@implementation ZBReport

+ (void)reportWithKindId:(NSString *)kindId getReportUid:(NSString *)gUid reportUid:(NSString *)uid reportKind:(ZBReportKind)reportKind reason:(NSString *)reason {
    [self reportWithKindId:kindId getReportUid:gUid reportUid:uid reportKind:reportKind reason:reason completed:nil];
}

+ (void)reportWithKindId:(NSString *)kindId getReportUid:(NSString *)gUid reportUid:(NSString *)uid reportKind:(ZBReportKind)reportKind reason:(NSString *)reason completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    NSString *kind = [NSString stringWithFormat:@"%d",reportKind];
    NSDictionary *parameters = @{@"post_id":kindId,
                                 @"owner_uid":gUid,
                                 @"uid":uid,
                                 @"op":@"1",
                                 @"reason":reason,
                                 @"act_kind":kind
                                 };
    [self reportWithParameters:parameters completed:completedBlock];
}

+ (void)reportWithParameters:(NSDictionary *)parameters completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    //判断是否登录
    if (![HuaxoUtil isLogined]) {
        NSError *error = [NSError errorWithDomain:GDLocalizedString(@"您还未登录") code:10001 userInfo:nil];
        if (completedBlock) completedBlock(NO, GDLocalizedString(@"请登录后再举报！"), error);
        return;
    }
    
    [NetRequest urlStr:[ApiUrl collectionAndReportPostUrlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = (NSDictionary *)responseObject;
        if (![json[@"ret"] integerValue]) {
            if (completedBlock) completedBlock(NO, json[@"msg"], nil);
            return ;
        }
        if (completedBlock) completedBlock(YES, json[@"msg"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completedBlock) completedBlock(NO, GDLocalizedString(@"举报失败！"), error);
    }];
}

+ (void)isReportWithKindId:(NSString *)kindId reportUid:(NSString *)uid reportKind:(ZBReportKind)reportKind completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    NSString *kind = [NSString stringWithFormat:@"%d",reportKind];
    NSDictionary *parameters = @{@"post_id":kindId,
                                 @"uid":uid,
                                 @"act_kind":kind
                                 };
    [self isReportWithParameters:parameters completed:completedBlock];
}

+ (void)isReportWithParameters:(NSDictionary *)parameters completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    [NetRequest urlStr:[ApiUrl checkUserPostManagerUrlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        if ([json[@"isReport"] integerValue]) {
            if (completedBlock) completedBlock(YES, json[@"msg"], nil);
            return ;
        }
        if (completedBlock) completedBlock(NO, json[@"msg"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completedBlock) completedBlock(NO,GDLocalizedString(@"查询失败！"), error);
    }];
}

@end
