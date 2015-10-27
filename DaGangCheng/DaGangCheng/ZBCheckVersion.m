//
//  ZBCheckVersion.m
//  DaGangCheng
//
//  Created by huaxo on 15-2-3.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCheckVersion.h"
#import "AFNetworking.h"

@implementation ZBCheckVersion



//请求version
+ (void)netRequestAppstoreVersionPassBlock:(CustomBlock)sender{
    NSString *appId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_id"];
    if (!appId) {
        return;
    }
    NSDictionary *allParameters = @{@"id":appId};
    NSString *urlStr = @"http://itunes.apple.com/lookup";
    //管理者
    AFHTTPRequestOperationManager * aManager =[AFHTTPRequestOperationManager manager];
    //格式
    aManager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/javascript"];//text/html
    // [aManager.responseSerializer add:[NSSet setWithObject:@"text/plain"]];
    //请求
    [aManager POST:urlStr parameters:allParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        //NSLog(@"operation: %@", operation.responseString);
        NSDictionary* dic = responseObject;
        sender(dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败:%@",error);
        NSLog(@"operation: %@", operation.responseString);
        sender(nil);
    }];
    
}
@end
