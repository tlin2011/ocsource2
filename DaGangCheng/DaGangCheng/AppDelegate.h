//
//  AppDelegate.h
//  DaGangCheng
//
//  Created by huaxo on 14-2-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <RennSDK/RennSDK.h>
#import "YXApi.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "WeiboApi.h"
#import "MobClick.h"
#import "RootViewController.h"
#import "ZBAdView.h"
#import "ZBAdVC.h"
#import "ZBPostJumpTool.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ZBAdViewDelegate, ZBAdVCDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) NSDictionary *launchOptions;

- (void)toRootViewControllerWithIsGotoAd:(BOOL)isGotoAd;
@end
