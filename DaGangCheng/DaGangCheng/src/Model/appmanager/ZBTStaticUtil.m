//
//  ZBTStaticUtil.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTStaticUtil.h"
#import "MJExtension.h"
#import "ZbtUserPm.h"

@implementation ZBTStaticUtil

static ZbtUserPm *userPm;

+(ZbtUserPm *)getUserPm{
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr]};
    [request urlStr:[ApiUrl getUserPm] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        if (![customDict[@"ret"] integerValue]) {
            NSDictionary *dict2 =customDict;
            ZbtUserPm   *tempZbtUserPm = [ZbtUserPm objectWithKeyValues:dict2];
            userPm=tempZbtUserPm;
        }
    }];
    return userPm;
}

@end
