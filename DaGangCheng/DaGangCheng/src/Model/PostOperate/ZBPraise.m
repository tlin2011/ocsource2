//
//  ZBPraise.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPraise.h"

@implementation ZBPraise

+ (void)praiseWithKindId:(NSString *)kindId getPraiseUid:(NSString *)gUid praisedUid:(NSString *)uid praiseKind:(ZBPraiseKind)praiseKind {
    [self praiseWithKindId:kindId getPraiseUid:gUid praisedUid:uid praiseKind:praiseKind completed:nil];
}

+ (void)praiseWithKindId:(NSString *)kindId getPraiseUid:(NSString *)gUid praisedUid:(NSString *)uid praiseKind:(ZBPraiseKind)praiseKind completed:(void (^)(BOOL, NSString *, NSError *))completedBlock{
    NSString *kind = [NSString stringWithFormat:@"%d",praiseKind];
    NSDictionary *parameters = @{@"support_id":kindId,
                                 @"be_praised_uid":gUid,
                                 @"praise_uid":uid,
                                 @"praise_kind":kind,
                                 @"addr":[[ZBAppSetting standardSetting] address],
                                 @"gps_lng":[[ZBAppSetting standardSetting] longitudeStr],
                                 @"gps_lat":[[ZBAppSetting standardSetting] latitudeStr]
                                 };
    [self praiseWithParameters:parameters completed:completedBlock];
}

+ (void)praiseWithParameters:(NSDictionary *)parameters completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    [NetRequest urlStr:[ApiUrl addPraiseUrlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = (NSDictionary *)responseObject;
        if (![json[@"ret"] integerValue]) {
            if (completedBlock) completedBlock(NO, json[@"msg"], nil);
            return ;
        }
        if (completedBlock) completedBlock(YES, json[@"msg"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (!completedBlock) completedBlock(NO, GDLocalizedString(@""), error);
    }];
}

+ (void)isPraiseWithKindId:(NSString *)kindId praisedUid:(NSString *)uid praiseKind:(ZBPraiseKind)praiseKind completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {

    NSString *kind = [NSString stringWithFormat:@"%d",praiseKind];
    NSDictionary *parameters = @{@"post_id":kindId,
                                 @"uid":uid,
                                 @"act_kind":kind
                                 };
    [self isPraiseWithParameters:parameters completed:completedBlock];
}

+ (void)isPraiseWithParameters:(NSDictionary *)parameters completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    [NetRequest urlStr:[ApiUrl checkUserPostManagerUrlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        if ([json[@"isSupport"] integerValue]) {
            if (completedBlock) completedBlock(YES, json[@"msg"], nil);
            return ;
        }
        if (completedBlock) completedBlock(NO, json[@"msg"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completedBlock) completedBlock(NO,GDLocalizedString(@"查询失败！"), error);
    }];
}

@end
