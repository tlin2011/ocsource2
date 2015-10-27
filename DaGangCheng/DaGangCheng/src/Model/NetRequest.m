//
//  NetRequest.m
//  DaGangCheng
//
//  Created by huaxo on 14-3-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

-(void)urlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters passBlock:(CustomBlock)sender
{
    [self.class urlStr:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(sender != nil) sender((NSDictionary *)responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dic = [[NSDictionary alloc] init];
        if(sender != nil) sender(dic);
    }];
}

+ (void)urlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *secret_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"secret_key"];
    NSDictionary * prepareDict =@{
                                  @"s_ibg_ver":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"],
                                  @"s_net_status":@"wifi",
                                  @"s_ibg_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"action":urlStr,
                                  @"secret_key":secret_key
                                  };
    
    //查询数据库
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSString* s_id = [sql queryWithCondition:@"session_id"];
    s_id = s_id?s_id:@"";
    
    NSDictionary * prepareDict2 =@{
                                   @"s_id": s_id,
                                   @"s_udid":[HuaxoUtil getUdidStr],
                                   @"phone_uid":[HuaxoUtil getUdidStr],
                                   };
    //准备好的参数
    NSMutableDictionary * allParameters =[[NSMutableDictionary alloc] initWithDictionary:prepareDict];
    [allParameters addEntriesFromDictionary:prepareDict2];
    //准备好的参数 + 传进来的参数
    [allParameters addEntriesFromDictionary:parameters];
    
    //管理者
    AFHTTPRequestOperationManager * aManager =[AFHTTPRequestOperationManager manager];
    //格式
    aManager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];//text/html
    aManager.requestSerializer.timeoutInterval = 45;    //网络超时45秒
    // [aManager.responseSerializer add:[NSSet setWithObject:@"text/plain"]];
    //请求
    //NSLog(@"base: %@-> url:%@",[ApiUrl baseUrlStr], allParameters);
    
    [aManager GET:[ApiUrl baseUrlStr] parameters:allParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        //NSLog(@"operation: %@", operation.responseString);
        NSDictionary* dic = responseObject;
        if([dic[@"ret"] intValue] <=0 && dic[@"msg"] && [((NSString*)dic[@"msg"]) isEqualToString:@"session_error"])
        {
            if([HuaxoUtil hasUdid])
            {
                [self requestUdidSession];
            }else{
                [self requestUdidInfo];
            }
        }
        if (success != nil) success(operation, responseObject);
    } failure:failure];

}

+ (void)requestAddrWithLat:(float)lat lng:(float)lng passBlock:(CustomBlock)sender{
    //管理者
    AFHTTPRequestOperationManager * aManager =[AFHTTPRequestOperationManager manager];
    //格式
    aManager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/javascript"];//text/html
    // [aManager.responseSerializer add:[NSSet setWithObject:@"text/plain"]];
    //请求

    
    NSString *baiduMap_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"baiduMap_key"];
    
    NSDictionary * parmeters = @{@"key":baiduMap_key,
                                 @"output":@"json",
                                 @"location":[NSString stringWithFormat:@"%f,%f",lat,lng]
                                 };
    [aManager GET:@"http://api.map.baidu.com/geocoder" parameters:parmeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if (![dic[@"status"] isEqualToString:@"OK"]) {
            NSLog(@"获取地址失败");
            return;
        }
        if(sender != nil) sender(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请检查网络 ,%@",error);
    }];

    
    //        http://api.map.baidu.com/geocoder?output=json&location=39.983424,%20116.322987&key=37492c0ee6f924cb5e934fa08c6b1676
}

+ (void)requestUdidInfo {
    [self requestUdidInfoCompletion:nil];
}

+ (void)requestUdidInfoCompletion:(void (^)(BOOL finished))completion {
    if([HuaxoUtil hasUdid]  )
    {
        NSLog(@"aleady hasUdid");
        
        if(![HuaxoUtil hasSessionId]){
            NSLog(@"not have session-id");
            [self requestUdidSessionCompletion:completion];
            return ;
        }
        NSLog(@"has session-id");
        if (completion != nil) completion(YES);
        return ;
    }
    
    NSString* udid = [NSString stringWithFormat:@"Unique GLOBAL Device Identifier:\n%@",
                      [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    NSLog(@"device- udid---:%@",udid);
    
    NSDictionary * parameters = @{
                                  @"ibg_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"imei": udid,
                                  @"imsi": udid,
                                  @"serial_num": @"",
                                  @"android_id": @"ios-device",
                                  @"mac":@"",
                                  @"ibg_ver": @"0",
                                  @"m": @"ios",
                                  @"sdk_ver":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                                  @"module":@"",
                                  @"model":@"",
                                  };
    [NetRequest urlStr:[ApiUrl getUdidInfoStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *customDict = responseObject;
        NSLog(@"get-udid-info:%@",customDict);
        if (![(NSNumber*)customDict[@"ret"] intValue]  ) {
            NSLog(@"get-udid-info:error!!!!%@",customDict[@"msg"]);
            if (completion != nil) completion(NO);
            return ;
        }
        
        if([HuaxoUtil hasUdid]){
            if (completion != nil) completion(YES);
            return;
        }
        
        SQLDataBase * sql = [SQLDataBase new];
        [sql save:customDict];
        
        NSLog(@"[sql save:customDict]  udid:%@",[sql queryWithCondition:@"udid"]);
        
        //sql = [SQLDataBase new];
        [sql updateValue:[NSString stringWithFormat:@"%@",customDict[@"udid"]] key:@"phone_uid"];
        
        
        [self requestUdidSessionCompletion:completion];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) completion(NO);
    }];
}

+ (void)requestUdidSession
{
    [self requestUdidSessionCompletion:nil];
}

+(void)requestUdidSessionCompletion:(void (^)(BOOL finished))completion {
    if(![HuaxoUtil hasUdid])
    {
        NSLog(@"do not have udid!");
        if (completion != nil) completion(NO);
        return ;
    }
    NSLog(@"into getUdidSession");

    NSDictionary * parameters = @{
                                  @"udid": [HuaxoUtil getUdidStr],
                                  @"safe_md5": [HuaxoUtil getSafeMd5Str],
                                  };
    [NetRequest urlStr:[ApiUrl getUdidSessionStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *customDict = responseObject;
        NSLog(@"get-udid-session:%@",customDict);
        if (![customDict[@"ret"] intValue]  ) {
            NSLog(@"get-udid-session:error!!!!%@",customDict[@"msg"]);
            if (completion != nil) completion(NO);
            return ;
        }
        //        if ([HuaxoUtil hasSessionId]) {
        //            return;
        //        }
        SQLDataBase * sql = [SQLDataBase new];
        [sql updateValue:[NSString stringWithFormat:@"%@",customDict[@"session_id"]] key:@"session_id"];
        if (completion != nil) completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) completion(NO);
    }];

}
@end
