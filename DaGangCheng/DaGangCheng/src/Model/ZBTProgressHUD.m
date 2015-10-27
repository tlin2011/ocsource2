//
//  ZBTProgressHUD.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-29.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTProgressHUD.h"

@implementation ZBTProgressHUD
static ZBTProgressHUD * shareHUD = nil;

+ (ZBTProgressHUD *)shareInstance {
    if (shareHUD == nil) {
        shareHUD = [[ZBTProgressHUD alloc] init];
    }
    return shareHUD;
}

@end
