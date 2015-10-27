//
//  ZBCollection.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCollection.h"

@implementation ZBCollection

+ (void)collectionWithKindId:(NSString *)kindId getCollectionUid:(NSString *)gUid collectionUid:(NSString *)uid collectionKind:(ZBCollectionKind)collectionKind {
    [self collectionWithKindId:kindId getCollectionUid:gUid collectionUid:uid collectionKind:collectionKind completed:nil];
}

+ (void)collectionWithKindId:(NSString *)kindId getCollectionUid:(NSString *)gUid collectionUid:(NSString *)uid collectionKind:(ZBCollectionKind)collectionKind completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    NSString *kind = [NSString stringWithFormat:@"%d",collectionKind];
    NSDictionary *parameters = @{@"post_id":kindId,
                                 @"owner_uid":gUid,
                                 @"uid":uid,
                                 @"op":@"0",
                                 @"reason":@"",
                                 @"act_kind":kind
                                 };
    [self collectionWithParameters:parameters completed:completedBlock];
}

+ (void)collectionWithParameters:(NSDictionary *)parameters completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    //判断是否登录
    if (![HuaxoUtil isLogined]) {
        NSError *error = [NSError errorWithDomain:GDLocalizedString(@"您还未登录") code:10001 userInfo:nil];
        if (completedBlock) completedBlock(NO, GDLocalizedString(@"请登录后再收藏！"), error);
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
        if (completedBlock) completedBlock(NO, GDLocalizedString(@"收藏失败！"), error);
    }];
}

+ (void)isCollectionWithKindId:(NSString *)kindId collectionUid:(NSString *)uid collectionKind:(ZBCollectionKind)collectionKind completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    NSString *kind = [NSString stringWithFormat:@"%d",collectionKind];
    NSDictionary *parameters = @{@"post_id":kindId,
                                 @"uid":uid,
                                 @"act_kind":kind
                                 };
    [self isCollectionWithParameters:parameters completed:completedBlock];
}

+ (void)isCollectionWithParameters:(NSDictionary *)parameters completed:(void (^)(BOOL, NSString *, NSError *))completedBlock {
    
    [NetRequest urlStr:[ApiUrl checkUserPostManagerUrlStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = responseObject;
        if ([json[@"isCollect"] integerValue]) {
            if (completedBlock) completedBlock(YES, json[@"msg"], nil);
            return ;
        }
        if (completedBlock) completedBlock(NO, json[@"msg"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completedBlock) completedBlock(NO,GDLocalizedString(@"查询失败！"), error);
    }];
}

@end
