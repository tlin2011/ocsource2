//
//  AppDelegate.m
//  DaGangCheng
//
//  Created by huaxo on 14-2-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "PostViewController.h"
#import "RootViewController.h"
#import "HotNavigationController.h"
#import "ZBAppSetting.h"
#import "NewLoginContoller.h"
#define JPushOpen

#import "MTA.h"
#import "MTAConfig.h"
#import "NewLoginContoller.h"

#import <AlipaySDK/AlipaySDK.h>

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //设置语言
    [GDLocalizable initUserLanguageToChinese];
    
    //
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"返回箭头.png"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"返回箭头_h.png"]];
    [[UINavigationBar appearance] setBarTintColor:UIColorWithMobanTheme];
    [[UINavigationBar appearance] setTintColor:UIColorWithMobanThemeSub];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorWithMobanThemeSub}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITabBar appearance] setTintColor:UIColorWithMobanTheme];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];

    
    
#ifdef JPushOpen
    //极光推送
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    NSLog(@"app do1");
#endif
    //友盟统计
//    NSString  *youMengTongJi_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"youMengTongJi_key"];
//    NSNumber *youMengTongJi_reportPolicy = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"youMengTongJi_reportPolicy"];
//    NSString *youMengTongJi_channelId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"youMengTongJi_channelId"];
//    [MobClick startWithAppkey:youMengTongJi_key reportPolicy:[youMengTongJi_reportPolicy integerValue] channelId:youMengTongJi_channelId];
//    [MobClick setAppVersion:XcodeAppVersion];
    
    [ShareSDK registerApp:@"1b359ff805fe"];
    
    [self initializePlat];
    
    //推送
    self.launchOptions = launchOptions;
    
    //安装渠道
    NSString *englishName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    [[MTAConfig getInstance] setChannel:englishName];
    
    // 腾讯云
    [MTA startWithAppkey:@"IV6WWB28M3SW"];
    
    [self startWindow];
    
    
    //在浏览器 userAgent最后添加 OpenCom以及版本 标识
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@/%@",@"OpenCom",@"2.8.19"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
    
    /**
     * 上传版本信息
     */
    
    NSString *mversion=[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    
    NSDictionary *kvs=@{@"uid":[HuaxoUtil getUdidStr],
                        @"wid":englishName,
                        @"isRegister":@"1",
                        @"inner":mversion};

    [MTA trackCustomKeyValueEvent:@"onGameLogin" props:kvs];
    
    
    return YES;
}

- (void)startWindow {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController=[[UIViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([ZBAppSetting isAppSettingFileExist]) {
        [[ZBAppSetting standardSetting] updateData];
        [self toViewController];
    } else {
        //获取匿名会话ID
        [NetRequest requestUdidInfoCompletion:^(BOOL finished) {
            if (finished) {
                [ZBAppSetting requestJsonCompletion:^(BOOL finished) {
                    
                    [[ZBAppSetting standardSetting] updateData];
                    [self toViewController];
                }];
            }else {
                [[ZBAppSetting standardSetting] updateData];

                [self toViewController];
            }
            
        }];
    }
}

- (void)toViewController {
    
    ZBAd *ad = [[ZBAppSetting standardSetting] ad];
    //是否进入广告
    if ([ad.imageID integerValue]>0) {
        
        [self toAdViewController];
        
    } else {
        
        [self toRootViewControllerWithIsGotoAd:NO];
    }
}

#pragma ZBAdVC - delegate
- (void)adVCIgnore:(ZBAdVC *)adVC {
    [adVC removeFromParentViewController];
    [self toRootViewControllerWithIsGotoAd:NO];
}
- (void)adVCClickedAd:(ZBAdVC *)adVC {

    adVC.isOpenedAd = YES;
    ZBAd *ad = [[ZBAppSetting standardSetting] ad];
    
    if (ad.urlStr) {
        [ZBPostJumpTool intoAdPageWithUrlStr:ad.urlStr vc:adVC];
    }
}
- (void)adVCOpenedWithBack:(ZBAdVC *)adVC {
    [adVC removeFromParentViewController];
    [self toRootViewControllerWithIsGotoAd:NO];
}

- (void)adVCTimerOver:(ZBAdVC *)adVC {
    if (adVC.isOpenedAd) {
        return;
    }
    [adVC removeFromParentViewController];
    [self toRootViewControllerWithIsGotoAd:NO];
}

- (void)toAdViewController {
    ZBAd *ad = [[ZBAppSetting standardSetting] ad];
    ZBAdVC *adVC = [[ZBAdVC alloc] init];
    adVC.imageID = ad.imageID;
    adVC.delegate = self;
    self.window.rootViewController = adVC;
    
    [self performSelector:@selector(adVCTimerOver:) withObject:adVC afterDelay:3];
}

- (void)toRootViewControllerWithIsGotoAd:(BOOL)isGotoAd {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.rootViewController = [board instantiateViewControllerWithIdentifier:@"RootViewController"];
    self.rootViewController.isGotoAd = isGotoAd;
    self.window.rootViewController = self.rootViewController;
    
    
    
    /**
     *  判断是否五次进入未登录，如果累计达到5次  则跳转到登录页面
     */

    if (![HuaxoUtil isLogined]) {

        NSString *homeDictionary2=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *homePath  = [homeDictionary2 stringByAppendingPathComponent:@"atany.archiver"];
        
        id count = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
        NSInteger  num=[count integerValue];
        
        if (num==4) {
            [NewLoginContoller tologinWithVC:self.window.rootViewController];
            num=0;
        }else{
            num++;
        }
        
        NSString *result=[NSString stringWithFormat:@"%ld",(long)num];
        BOOL success=[NSKeyedArchiver archiveRootObject:result toFile:homePath];
        
        if (success) {
            NSLog(@"ASDFASD");
        }
    }

    //推送
    if (self.launchOptions) {
        [self performSelector:@selector(delayJpuch:) withObject:self.launchOptions afterDelay:2];
        NSLog(@"app do2");
    }
}


- (void)delayJpuch:(NSDictionary *)dic {
    NSLog(@"dic:%@",dic);
    NSDictionary *notiDic = dic[@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if ([notiDic[@"type"] isEqualToString:@"topics"] && notiDic[@"post_id"]) {
        [self seePostbyPostId:notiDic[@"post_id"]];
    }
}

- (void)initializePlat
{
    
//    NSString *docStr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    
//    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
//
//    NSString *logFilePath = [docStr stringByAppendingPathComponent:fileName];
    
    
    // NSLog 的日志重定向到 logFilePath
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
    
    /**
     获取 URL Type --URL Scheme中保存的各开放平台的 app Key
     **/
    NSArray *urlArrs = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    //NSLog(@"urlArrs %@",urlArrs);
    NSDictionary *urlDic = urlArrs[1];
    NSArray *urlSchemes = urlDic[@"CFBundleURLSchemes"];
    
    
    /**
     1：微信      **/
     
    NSString *wechat_key = urlSchemes[0];
     
    if (!wechat_key || wechat_key.length<1) {
           wechat_key=@"wxc91062f19695fe22";
    }
    
    NSLog(@"WECHAR_KEY---:%@",wechat_key);
    
     /** 2：新浪微博 **/
       NSString *sina_key = urlSchemes[1];
       NSString *sina_secret = urlSchemes[2];
     
       if (!sina_key || sina_key.length<1) {
            sina_key=@"568898243";
            sina_secret=@"38a4f8204cc784f81f9f0daaf31e02e3";
       }
    
    
    
    if (sina_key && sina_key.length>4  && [sina_key hasPrefix:@"sina"]) {
        sina_key=[sina_key substringFromIndex:4];
        sina_secret=[sina_secret substringFromIndex:4];
    }
    
      NSLog(@"sina_key--sina_secret---:%@---%@",sina_key,sina_secret);
   /**  3：QQ应用 **/
    
    //tencent100371282
     
      NSString *tencent_key = urlSchemes[3];
    
    if (tencent_key && tencent_key.length>7) {
         tencent_key=[tencent_key substringFromIndex:7];
    }
    
      NSString *tencent_secret = urlSchemes[4];
      NSString *tencent_key16 = urlSchemes[5];
     
      if (!tencent_key || tencent_key.length<1) {
          tencent_key=@"1104671666";
          tencent_secret=@"qqKKttAHBGv7CpqA";
          tencent_key16=@"QQ41D7F3B2";
    
      }

         NSLog(@"tencent_key--tencent_secret---tencent_key16:%@---%@--%@",tencent_key,tencent_secret,tencent_key16);
    
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:sina_key
                               appSecret:sina_secret
                             redirectUri:@"http://www.sharesdk.cn"];
    
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:tencent_key
                           appSecret:tencent_secret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
//    [ShareSDK connectQZoneWithAppKey:@"100371282"
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];

    
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/

    
//    NSString *wx_key = urlSchemes[2];
//    //NSLog(@"wx %@",wx_key);
//    if (!wx_key || wx_key.length<1) {
//        wx_key=@"wxc91062f19695fe22";
//    }
    
    /**
     包含微信好友、微信朋友圈、微信收藏
     [ShareSDK connectWeChatWithAppId:wx_key wechatCls:[WXApi class]];
     **/
    
    //微信好友
    [ShareSDK connectWeChatSessionWithAppId:wechat_key wechatCls:[WXApi class]];
    //微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId:wechat_key wechatCls: [WXApi class]];
    
    
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
     [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    **/
    [ShareSDK connectQQWithQZoneAppKey:tencent_key
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
   
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"
                                   wbApiCls:[WeiboApi class]];
      **/
    
    //连接短信分享
    //[ShareSDK connectSMS];


    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
  
    [ShareSDK connectRenRenWithAppId:@"226427"
                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
                   renrenClientClass:[RennClient class]];
       **/
    
    /**
     连接易信应用以使用相关功能，此应用需要引用YiXinConnection.framework
     http://open.yixin.im/上注册易信开放平台应用，并将相关信息填写到以下字段
    
    
    [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
                           yixinCls:[YXApi class]];
      **/
    
    //连接邮件
   // [ShareSDK connectMail];
    
    /**
     连接网易微博应用以使用相关功能，此应用需要引用T163WeiboConnection.framework
     http://open.t.163.com上注册网易微博开放平台应用，并将相关信息填写到以下字段
   
    
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
       **/
    
    /**
     连接有道云笔记应用以使用相关功能，此应用需要引用YouDaoNoteConnection.framework
     http://note.youdao.com/open/developguide.html#app上注册应用，并将相关信息填写到以下字段
    
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
     
      **/
}
/**
 *	@brief	托管模式下的初始化平台
 */
- (void)initializePlatForTrusteeship
{
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //导入人人网需要的外部库类型,如果不需要人人网SSO可以不调用此方法
    [ShareSDK importRenRenClass:[RennClient class]];
    
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //导入易信需要的外部库类型，如果不需要易信分享可以不调用此方法
    [ShareSDK importYiXinClass:[YXApi class]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
    
}

//查看话题
- (void)seePostbyPostId:(NSString *)postId {
    PostViewController * pvc =[[PostViewController alloc] init];
    pvc.postID = postId;
    pvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:pvc action:@selector(back:)];
    [pvc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    pvc.hidesBottomBarWhenPushed = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pvc];
    
//    RootViewController *rootVC = (RootViewController *)self.window.rootViewController;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rootVC) return;
    //HotNavigationController *upVC = [rootVC.viewControllers objectAtIndex:0];
    //UIViewController *vc = [upVC topViewController];
    //[upVC pushViewController:pvc animated:YES];
    [rootVC presentViewController:navi animated:YES completion:nil];
}



#ifdef JPushOpen

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知 !ios7:%@", userInfo);
    //NSLog(@"8888 %d",[UIApplication sharedApplication].applicationState);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        NSLog(@"点击推送...");
        
        //页面跳转
        NSDictionary *notiDic = userInfo;
        if ([notiDic[@"type"] isEqualToString:@"topics"] && notiDic[@"post_id"]) {
            [self seePostbyPostId:notiDic[@"post_id"]];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知ios7:%@", userInfo);
    //NSLog(@"8888 %d",[UIApplication sharedApplication].applicationState);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        NSLog(@"点击推送...");
        
        //页面跳转
        NSDictionary *notiDic = userInfo;
        if ([notiDic[@"type"] isEqualToString:@"topics"] && notiDic[@"post_id"]) {
            [self seePostbyPostId:notiDic[@"post_id"]];
        }
    }

    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //APP前台运行时，仍然将通知显示出来
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}


#endif

@end
