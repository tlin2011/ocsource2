//
//  ZBTNetRequest.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTNetRequest.h"

@implementation ZBTNetRequest


- (void)postJSONWithUrlStr:(NSString *)urlStr parameters:(id)parameters  success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary * allParameters =[[NSMutableDictionary alloc] initWithDictionary:self.prepareDict];
    
    [allParameters addEntriesFromDictionary:parameters];
    
    urlStr = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlStr];
    
    [manager POST:urlStr parameters:allParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}


-(instancetype)initWithBaseUrl:(NSString *)baseUrl prepareDict:(NSDictionary *)prepareDict{
    self=[super init];
    if (self) {
        self.baseUrl=baseUrl;
        self.prepareDict=prepareDict;
    }
    return self;
}



+ (void)postJSONWithBaseUrl:(NSString *)baseStr urlStr:(NSString *)urlStr parameters:(id)parameters  success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];

    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSString* s_id = [sql queryWithCondition:@"session_id"];
    s_id = s_id?s_id:@"";

    NSDictionary * prepareDict =@{
                           @"s_id":s_id,
                           @"app_kind":app_kind,
                           @"s_udid":[HuaxoUtil getUdidStr]
//                           @"s_udid":@"256203"
//                           @"s_ibg_kind":@"ibuger_opencom",
//                           @"s_ibg_ver":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"]
                };

    NSMutableDictionary * allParameters =[[NSMutableDictionary alloc] initWithDictionary:prepareDict];

    [allParameters addEntriesFromDictionary:parameters];

    urlStr = [NSString stringWithFormat:@"%@%@",baseStr,urlStr];

    [manager POST:urlStr parameters:allParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}


@end
