//
//  NetRequestAll.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NetRequestAll.h"
#import "AFNetworking.h"
#import "NetRequest.h"
#import "ApiUrl.h"

@implementation NetRequestAll

+ (void)requestAppSetting:(CustomBlock)sender {
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    //请求
    NetRequest * req =[[NetRequest alloc]init];
    NSDictionary*  parameret =@{
                                @"app_kind":app_kind,
                                @"is_app":@"yes",
                                };
    
    //调用
    [req urlStr:[ApiUrl appSettingUrlStr] parameters:parameret passBlock:^(NSDictionary *customDict) {
        
        if(![customDict[@"ret"] intValue])
        {
            sender(nil);
            return ;
        }
        sender(customDict);
    }];
}


@end
