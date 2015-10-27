//
//  NotifyCenter.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NotifyCenter.h"
#import "CommHead.h"

@interface NotifyCenter()
{
    NSTimer *timer;
}
@end

@implementation NotifyCenter

+(NSString*)userNotifyKey{
    return @"NotifyCenter-userNewsNotifyKey";
}
+(NSString*)userLoginStatusKey{
    return @"NotifyCenter-userLoginStatusNotifyKey";
}
+(void)sendLoginStatus:(id)obj
{
    //发送通知 fred 2014/07/10
    [[NSNotificationCenter defaultCenter] postNotificationName:[NotifyCenter userLoginStatusKey] object:nil userInfo:obj];
}
-(void)startUserNewsNotify
{
    [self getUserNews];
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getUserNews) userInfo:nil repeats:YES];
}
-(void)stopUserNewsNotify
{
    if(timer && timer.isValid)
        [timer invalidate];
}
-(void)getUserNews
{
    NetRequest * request = [NetRequest new];
    NSDictionary * parameters =@{@"uid":[HuaxoUtil getUdidStr],@"app":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"]};
    [request urlStr:[ApiUrl getUserNewsUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if (!customDict[@"ret"]) {
            NSLog(@"getPindaoNews failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"app_ver"]){
                NSDictionary *dic = @{@"feed_cnt": @(0), @"app_ver":customDict[@"app_ver"]};
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAppVer" object:nil userInfo:dic];
            }
            return ;
        }
        
        NSMutableDictionary*newsDic = [customDict mutableCopy];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSNumber *num = [ud objectForKey:@"feed_cnt"];
        NSInteger feed = [num integerValue] + [newsDic[@"feed_cnt"] integerValue];
        [ud setObject:[NSNumber numberWithInteger:feed] forKey:@"feed_cnt"];
        [newsDic setObject:[NSNumber numberWithInteger:feed] forKey:@"feed_cnt"];
        customDict = [newsDic copy];
        
        int fCnt = [newsDic[@"feed_cnt"] intValue]+[newsDic[@"freq_cnt"] intValue]+[newsDic[@"umsg_new"] intValue];
        
        if (fCnt>99) fCnt = 99;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:fCnt];
        
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:[NotifyCenter userNotifyKey] object:nil userInfo:customDict];
    }];
}
@end
