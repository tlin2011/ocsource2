//
//  Praise.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "Praise.h"
#import "HuaxoUtil.h"
#import "MBProgressHUD.h"
#import "NetRequest.h"
#import "ApiUrl.h"

@interface Praise ()
@property (nonatomic, copy) NSString *support_id;
@property (nonatomic, copy) NSString *be_praised_uid;
@property (nonatomic, copy) NSString *praise_kind;
@end

@implementation Praise

+ (void)hudShowTextOnly:(NSString *)message delegate:(id)delegate{
    if ([delegate respondsToSelector:@selector(navigationController)]) {
        UIViewController *v = delegate;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:v.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:1.5];
    }
}

@end
