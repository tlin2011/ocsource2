//
//  ZBHtmlToApp.h
//  DaGangCheng
//
//  Created by huaxo on 15-4-13.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZBAppSetting.h"
#import "UIColor+html.h"
#import "Singleton.h"

#import "PindaoIndexViewController.h"
#import "PostViewController.h"
#import "NewPostViewController.h"
#import "MyMsgViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "QBImagePickerController.h"
#import "LookPictureVC.h"
#import "ZBTMyFeedTableVC.h"
#import "JYSlideSegmentController.h"
#import "JYSlideSegmentController+back.h"
#import "MyMsgTableVC.h"
#import "FriendViewController.h"
#import "NearbyUsersViewController.h"
#import "UploadImage.h"
#import "MBProgressHUD.h"
#import "NSDictionary+json.h"
#import "ZBSuperCS.h"
#import "PersonageSlideVC.h"
#import "AppDelegate.h"
#import "PlateTableViewController.h"
#import "ZBCoreTextRegularMatch.h"
#import "ShequPindaoKindVC.h"
#import "ShequPindaoTableVC.h"
#import "NearHotPindaoTableVC.h"
#import "CreatePindaoTableVC.h"

#import "MyIntegralViewController.h"

#import "ZBSuperCSTabVC.h"

#import "ZBTNetRequest.h"


#import "ScanViewController.h"


@interface ZBHtmlToApp : NSObject<QBImagePickerControllerDelegate, MBProgressHUDDelegate,ScanViewControllerDelegate>
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, weak) UIWebView *webView;

singleton_interface(ZBHtmlToApp);

/**
 *  是否遵守超链规则
 */
+ (BOOL)isSupCSRuleWithUrlStr:(NSString *)string vc:(UIViewController *)vc webView:(UIWebView *)webView;

/**
 *  是否是超链
 */
+ (BOOL)isSupCSWithUrlStr:(NSString *)string webView:(UIWebView *)webView;

/**
 *  是否是跳转到app页面
 */
+ (BOOL)isGotoAppWithUrlStr:(NSString *)string vc:(UIViewController *)vc;

/**
 *  新web页面打开
 */
+ (BOOL)isNewWebOpenWithUrlStr:(NSString *)string vc:(UIViewController *)vc;

/**
 *  是否想网页注入js
 */
+ (BOOL)isJsWithUrlStr:(NSString *)string vc:(UIViewController *)vc webView:(UIWebView *)webView;

/**
 *  发帖跳转
 */
+ (void)toNewPostVCWithVC:(UIViewController *)vc;


+ (void)toChatVCWithUid:(NSString *)uid name:(NSString *)name vc:(UIViewController *)vc;

/**
 *  查看话题跳转
 */
+ (void)toPostVCWithPostId:(NSInteger)ID vc:(UIViewController *)vc;

/**
 *  频道跳转
 */
+ (void)toPindaoVCWithPindaoId:(NSInteger)ID vc:(UIViewController *)vc;


+ (void)toCFDetailVCWithCurrencyId:(NSString *)currencyId currencyType:(NSString *)currencyType vc:(UIViewController *)vc;

/**
 *  跳转到网页
 */
+ (void)toWebVCWithUrlStr:(NSString *)urlStr vc:(UIViewController *)vc;
@end
