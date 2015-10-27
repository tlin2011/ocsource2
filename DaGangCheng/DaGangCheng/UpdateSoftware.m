//
//  UpdateSoftware.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "UpdateSoftware.h"
#import "NotifyCenter.h"
#import "AboutViewController.h"

@implementation UpdateSoftware


- (void)start{
    BOOL isUpdate = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_isUpdate"] boolValue];
    if (isUpdate) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAppVer:) name:[NotifyCenter userNotifyKey] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAppVer:) name:@"updateAppVer" object:nil];
}

}

- (void)updateAppVer:(NSNotification *)notification {
    static int isFirst=1;
    if (!isFirst) {
        return;
    }
    NSDictionary *info = notification.userInfo;
    NSLog(@"info %@",info);
    NSInteger appVer = [info[@"app_ver"] integerValue];
    //软件版本号
    NSInteger app_zijiatianxia_ver = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"] integerValue];
    NSLog(@"app_ziji %ld app_ver %ld",(long)app_zijiatianxia_ver, (long)appVer);
    
//    if (isFirst && (appVer > app_zijiatianxia_ver)) {
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"检测到有更新版本") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"立即更新"), GDLocalizedString(@"暂时忽略"), nil];
//        [av show];
//        isFirst=0;
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(updateSoftwareDidClickedUpdateBtn)]) {
            [self.delegate updateSoftwareDidClickedUpdateBtn];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
