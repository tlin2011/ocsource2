//
//  HudUtil.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "HudUtil.h"

@implementation HudUtil

MBProgressHUD *hud;


+(void)showTextDialog:(NSString *)str view:(UIView*)view showSecond:(NSInteger *)second{
    
    hud=[[MBProgressHUD alloc] initWithView:view];
    
    [view addSubview:hud];
    
    hud.detailsLabelText = str;
    hud.labelFont = [UIFont systemFontOfSize:13];
    
    hud.userInteractionEnabled=NO;
    hud.mode=MBProgressHUDModeCustomView;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(second);
    } completionBlock:^{
        [hud removeFromSuperview];
        hud=nil;
    }];
}

@end
