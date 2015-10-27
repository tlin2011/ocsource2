//
//  ZBHtmlToApp.m
//  DaGangCheng
//
//  Created by huaxo on 15-4-13.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBHtmlToApp.h"

#import "CFAccountInfo.h"


#import <ShareSDK/ShareSDK.h>

#import "MyIntegralViewController.h"
#import "MyGiftTableViewController.h"
#import "MyNoEnoughTableViewController.h"
#import "MJExtension.h"

#import "ZBTUIWebViewController.h"

#import "NewGiftChargeTableViewController.h"

#import "NewNoEnoughTabelViewController.h"

#import "NewLoginContoller.h"

NSString *scanParam;

NSNumber *userPoint;

CFAccountInfo *accountInfo;

BOOL flag=false;

MBProgressHUD *hud2;

@implementation ZBHtmlToApp
singleton_implementation(ZBHtmlToApp)


+ (BOOL)isSupCSRuleWithUrlStr:(NSString *)string vc:(UIViewController *)vc webView:(UIWebView *)webView {

    if ([self isGotoAppWithUrlStr:string vc:vc]) {
        return YES;
    }
    
    if ([self isNewWebOpenWithUrlStr:string vc:vc]) {
        return YES;
    }
    
    if ([self isSupCSWithUrlStr:string webView:webView]) {
        return YES;
    }
    
    if ([self isJsWithUrlStr:string vc:vc webView:webView]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isSupCSWithUrlStr:(NSString *)string webView:(UIWebView *)webView {
    
    NSString *urlStr = string;
    
    
    
    if ([urlStr hasPrefix:@"http://cs.opencom.cn/"] && [ZBCoreTextRegularMatch coreTextKindFromString:string] == ZBCoreTextKindSuperCS) {
        __block UIWebView *bWeb = webView;
        
        //查询数据库
        SQLDataBase * sql =[[SQLDataBase alloc] init];
        NSString* s_id = [sql queryWithCondition:@"session_id"];
        s_id = s_id?s_id:@"";
        ZBAppSetting* appSetting = [ZBAppSetting standardSetting];
        NSString* lng = [appSetting longitudeStr];
        NSString* lat = [appSetting latitudeStr];
        NSDictionary *gpsDic = @{@"gps_lng":lng,@"gps_lat":lat};
        NSString *gpsStr = [gpsDic JSONString];
        gpsStr = gpsStr ? gpsStr : @"";
        
        NSDictionary *param = [ZBSuperCS parameterWithcs:urlStr uid:[HuaxoUtil getUdidStr] sid:s_id gps:gpsStr];
        
        [ZBSuperCS startRequestSuperCS:param haveTokenBlock:^(NSDictionary *customDict) {
            if (!customDict) return;
            
            NSString *cs = customDict[@"cs"];
            //NSString *name = customDict[@"linkName"];
//            if ([ZBCoreTextRegularMatch coreTextKindFromString:cs] == ZBCoreTextKindSuperCS) {
//                cs = [NSString stringWithFormat:<#(NSString *), ...#>]
//            }
            cs = cs ? cs:@"";
            
            if (scanParam && ![scanParam isEqualToString:@""]) {
                cs=[cs stringByAppendingString:scanParam];
                scanParam=@"";
            }
            
            NSURL* url = [NSURL URLWithString:cs];
            NSURLRequest* request =[NSURLRequest requestWithURL:url];
            [bWeb loadRequest:request];
        }];
        return YES;
        
    }
    return NO;
}

/**
 *  html跳转app
 */
+ (BOOL)isGotoAppWithUrlStr:(NSString *)string vc:(UIViewController *)vc{
    
    NSString *urlStr = string;
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSString *appName = [app_kind substringFromIndex:7];
    
    if([appName isEqualToString:@""]){
        appName = @"opencom";
    }
    
    NSString *baseUrlStr = [NSString stringWithFormat:@"http://cs.opencom.cn/bbs/%@",appName];
    NSString *baseUrlStr1 = [NSString stringWithFormat:@"http://cs.opencom.cn/app/%@",appName];
    
    
    NSRange range = [urlStr rangeOfString:baseUrlStr];
    NSRange range1 = [urlStr rangeOfString:baseUrlStr1];
    
    if (range.length>0) {
        urlStr = [urlStr substringFromIndex:range.location+range.length];
    } else if (range1.length>0) {
        urlStr = [urlStr substringFromIndex:range1.location+range1.length];
    } else {
        return NO;
    }
    
    NSString *pindaoUrlStr = [NSString stringWithFormat:@"/channel/"];
    NSString *postUrlStr = [NSString stringWithFormat:@"/post/"];
    NSString *nePostUrlStr = [NSString stringWithFormat:@"/newpost"];
    NSString *chatUrlStr = [NSString stringWithFormat:@"/chat/"];
    NSString *aboutUrlStr = [NSString stringWithFormat:@"/about"];
    NSString *atMeUrlStr = [NSString stringWithFormat:@"/atme"];
    NSString *talkUrlStr = [NSString stringWithFormat:@"/friends"];
    NSString *personalUrlStr = [NSString stringWithFormat:@"/personalpage/"];
    NSString *sectionUrlStr = [NSString stringWithFormat:@"/section"];
    NSString *pointsUrlStr = [NSString stringWithFormat:@"/points"];
    
    // 跳转
    if ([urlStr hasPrefix:pindaoUrlStr]) {
        NSString *pindaoId = [urlStr substringFromIndex:pindaoUrlStr.length];
        if ([pindaoId length]>1) {
            [self toPindaoVCWithPindaoId:[pindaoId integerValue] vc:vc];
            return YES;
        }
    } else if ([urlStr hasPrefix:postUrlStr]) {
        NSString *postId = [urlStr substringFromIndex:postUrlStr.length];
        if ([postId length]>1) {
            [self toPostVCWithPostId:[postId integerValue] vc:vc];
            return YES;
        }
    } else if ([urlStr hasPrefix:nePostUrlStr]) {
        [self toNewPostVCWithVC:vc];
        return YES;
    } else if ([urlStr hasPrefix:chatUrlStr]) {
        NSString *enString = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [enString componentsSeparatedByString:@"/"];
        if (arr.count >=4) {
            NSString *uid = [NSString stringWithFormat:@"%@", arr[2]];
            NSString *name = [NSString stringWithFormat:@"%@",arr[3]];
            //name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self toChatVCWithUid:uid name:name vc:vc];
            return YES;
        }
        
    } else if ([urlStr hasPrefix:aboutUrlStr]) {
        [self toAboutAppWithVC:vc];
        return YES;
    } else if ([urlStr hasPrefix:atMeUrlStr]) {
        [self toAtMeWithVC:vc];
        return YES;
    } else if ([urlStr hasPrefix:talkUrlStr]) {
        [self toTalkWithVC:vc];
        return YES;
    } else if ([urlStr hasPrefix:personalUrlStr]) {
        
        NSString *personalId = [urlStr substringFromIndex:personalUrlStr.length];
        if ([personalId length]>1) {
            [self toPersonageSlideVCWithUserId:personalId vc:vc];
            return YES;
        }
        
    } else if ([urlStr hasPrefix:sectionUrlStr]) {
        [self toShequVCWithVC:vc];
        return YES;
    } else if([urlStr hasPrefix:pointsUrlStr]){
        
        NSString *enString = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [enString componentsSeparatedByString:@"/"];
        if (arr.count >=4) {
            NSString *cid = [NSString stringWithFormat:@"%@", arr[2]];
            NSString *ctype = [NSString stringWithFormat:@"%@",arr[3]];
            [self toIntegraDetailVCWithVC:vc currencyId:cid currencyType:ctype];
            return YES;
        }
        
       

    }else {}
    
    return NO;
}



+ (void)toCFDetailVCWithCurrencyId:(NSString *)currencyId currencyType:(NSString *)currencyType vc:(UIViewController *)vc{
    
    
    NSDictionary *dict =@{
                          @"currency_id":currencyId,
                          @"currency_type":currencyType
                          };
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFAccountInfo] parameters:dict success:^(id responseObject) {
        
        NSDictionary *dict2 =responseObject;
        
        if ([dict2[@"ret"] intValue]>0) {
            accountInfo = [CFAccountInfo objectWithKeyValues:dict2];
            
            MyIntegralViewController *mivc=[[MyIntegralViewController alloc] initWithCurrencyId:currencyId  accountId:[MyIntegralViewController getAccountId] currencyType:currencyType currencyName:accountInfo.currency_name];
            
            mivc.title=[NSString stringWithFormat:@"我的%@",accountInfo.currency_name];
            mivc.hidesBottomBarWhenPushed=NO;
            [vc.navigationController pushViewController:mivc animated:YES];
            
            
        }else{
            [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
    

}

+ (BOOL)isNewWebOpenWithUrlStr:(NSString *)string vc:(UIViewController *)vc {
    
    NSString *urlStr = string;
    
    if ([urlStr hasPrefix:@"newtab:"]) {
        
        while ([urlStr hasPrefix:@"newtab:"]) {
            urlStr = [urlStr substringFromIndex:[@"newtab:" length]];
        }
        
        [self toWebVCWithUrlStr:urlStr vc:vc];
        return YES;
    }
    return NO;
}

/**
 *  频道跳转
 */
+ (void)toPindaoVCWithPindaoId:(NSInteger)ID vc:(UIViewController *)vc {
    //1.得到总故事版
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PindaoIndexViewController *next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    
    //2.属性传值
    next.kind_id = [NSString stringWithFormat:@"%ld", (long)ID];
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  查看话题跳转
 */
+ (void)toPostVCWithPostId:(NSInteger)ID vc:(UIViewController *)vc {
    
    PostViewController * next = [[PostViewController alloc] init];
    next.postID = [NSString stringWithFormat:@"%ld",(long)ID];
    next.title = GDLocalizedString(@"查看话题");
    next.hidesBottomBarWhenPushed = YES;
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  发帖跳转
 */
+ (void)toNewPostVCWithVC:(UIViewController *)vc {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return;
    }
    
    NewPostViewController *next = [[NewPostViewController alloc] init];
    next.title = GDLocalizedString(@"发帖");
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    
    [vc presentViewController:navi animated:YES completion:nil];
}




/**
 *  发帖跳转
 */
+ (void)toNewPostVCWithVC:(UIViewController *)vc subTitle:(NSString *)subTitle subContent:(NSString *)subContent{
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return;
    }
    
    NewPostViewController *next = [[NewPostViewController alloc] init];
    
    next.subTitle=subTitle;
    next.subContent=subContent;
    
    next.title = GDLocalizedString(@"发帖");
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  私信聊天跳转
 */
+ (void)toChatVCWithUid:(NSString *)uid name:(NSString *)name vc:(UIViewController *)vc {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return;
    }
    
    if (![uid integerValue]) {
        ZBLog(@"toChatVC uid 为空!");
        return;
    }
    
    MyMsgViewController * next =[[MyMsgViewController alloc] init];
    next.title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"私信"),name];
    next.to_name= name;
    next.to_uid = [NSString stringWithFormat:@"%ld",(long)[uid integerValue]];
    
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    
    
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  关于应用跳转
 */
+ (void)toAboutAppWithVC:(UIViewController *)vc {
    
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    aboutVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStylePlain target:aboutVC action:@selector(back:)];
    [aboutVC.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    aboutVC.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  @我页面跳转
 */
+ (void)toAtMeWithVC:(UIViewController *)vc {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return;
    }
    
    //删除feed_cnt
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"feed_cnt"];
    
    NSMutableArray *vcs = [NSMutableArray array];
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZBTMyFeedTableVC *vc1 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
    vc1.title = GDLocalizedString(@"@我的动态");
    vc1.anyFeedStr = @"me";
    ZBTMyFeedTableVC *vc2 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
    vc2.title = GDLocalizedString(@"朋友动态");
    vc2.anyFeedStr = @"friend";
    ZBTMyFeedTableVC *vc3 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
    NSString *vc3Title = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].unfocusName, GDLocalizedString(@"动态")];
    vc3.title = vc3Title;
    vc3.anyFeedStr = @"all";
    [vcs addObject:vc1];
    [vcs addObject:vc2];
    [vcs addObject:vc3];
    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    sc.title = GDLocalizedString(@"动态");
    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    sc.indicator.backgroundColor = UIColorWithMobanTheme;
    
    sc.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:sc animated:YES];
    sc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStylePlain target:sc action:@selector(back:)];
    [sc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    //sc.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sc];
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  聊天页面跳转
 */
+ (void)toTalkWithVC:(UIViewController *)vc {
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return;
    }
    
    NSMutableArray *vcs = [NSMutableArray array];
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyMsgTableVC *vc1 = [[MyMsgTableVC alloc] initWithStyle:UITableViewStylePlain];
    vc1.title = GDLocalizedString(@"私信");
    
    FriendViewController *vc2 = [board instantiateViewControllerWithIdentifier:@"FriendViewController"];
    vc2.title = GDLocalizedString(@"通讯录");
    
    NearbyUsersViewController *vc3 = [board instantiateViewControllerWithIdentifier:@"NearbyUsersViewController"];
    vc3.title = GDLocalizedString(@"附近的人");
    
    [vcs addObject:vc1];
    [vcs addObject:vc2];
    [vcs addObject:vc3];
    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    sc.title = GDLocalizedString(@"聊天");
    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    sc.indicator.backgroundColor = UIColorWithMobanTheme;
    
    //sc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加人_附近的人.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchUser)];
    sc.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:sc animated:YES];
    sc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStylePlain target:sc action:@selector(back:)];
    [sc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    //sc.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sc];
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  跳转到网页
 */
+ (void)toWebVCWithUrlStr:(NSString *)urlStr vc:(UIViewController *)vc
{
    
//    ZBSuperCSTabJumpVC *webVC = [[ZBSuperCSTabJumpVC alloc] init];
//    webVC.urlStr = urlStr;
//    //
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_cs_关闭页面.png"] style:UIBarButtonItemStyleBordered target:webVC action:@selector(back:)];
//    [backBtn setImageInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
//    
//    UIBarButtonItem *webBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_cs_返回上页.png"] style:UIBarButtonItemStyleBordered target:webVC action:@selector(clickedWebBackBtn:)];
//    [webBackBtn setImageInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
//    
//    webVC.navigationItem.leftBarButtonItems = @[webBackBtn, backBtn];
//    
//    webVC.hidesBottomBarWhenPushed = YES;
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webVC];
//    [vc presentViewController:navi animated:YES completion:nil];

    
        ZBTUIWebViewController *mptvc=[[ZBTUIWebViewController alloc]  init];
        mptvc.hidesBottomBarWhenPushed=YES;
        mptvc.isShowBall=YES;
        mptvc.isShowTitle=YES;
        mptvc.webViewUrl=urlStr;
        [vc presentViewController:mptvc animated:true completion:nil];
}

/**
 *  跳转到个人主页
 */
+ (void)toPersonageSlideVCWithUserId:(NSString *)userId vc:(UIViewController *)vc {
//    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:vc];
//        return;
//    }
    
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:userId];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    
    sc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:sc action:@selector(back:)];
    [sc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sc];
    
    [vc presentViewController:navi animated:YES completion:nil];
}

/**
 *  跳转到社区
 */
+ (void)toShequVCWithVC:(UIViewController *)vc {
    
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    int i = 0;
//    for (UIViewController *vc in app.rootViewController.viewControllers) {
//        UINavigationController *navVC = (UINavigationController *)vc;
//        if ([navVC.topViewController isMemberOfClass:[PlateTableViewController class]]) {
//            app.rootViewController.selectedIndex = i;
//            break;
//        }
//        i ++;
//    }

    NSMutableArray *vcs = [NSMutableArray array];
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([ZBAppSetting standardSetting].isOpenPindaoKind) {
        ShequPindaoKindVC *vc1 = [[ShequPindaoKindVC alloc] init];
        NSString *title = [NSString stringWithFormat:@"%@%@", GDLocalizedString(@"社区"),[ZBAppSetting standardSetting].pindaoName];
        vc1.title = title;
        [vcs addObject:vc1];
    } else
    {
        ShequPindaoTableVC *vc1 = [[ShequPindaoTableVC alloc] init];
        NSString *title = [NSString stringWithFormat:@"%@%@", GDLocalizedString(@"社区"), [ZBAppSetting standardSetting].pindaoName];
        vc1.title = title;
        [vcs addObject:vc1];
    }
    
    NearHotPindaoTableVC *vc2 = [[NearHotPindaoTableVC alloc] init];
    vc2.title = GDLocalizedString(@"附近热点");
    [vcs addObject:vc2];
    
    if (![ZBAppSetting standardSetting].isCreatePindaoLimit) {
        CreatePindaoTableVC *vc3 = [board instantiateViewControllerWithIdentifier:@"CreatePindaoTableVC"];
        NSString *title = [NSString stringWithFormat:@"%@%@", GDLocalizedString(@"创建"), [ZBAppSetting standardSetting].pindaoName];
        vc3.title = title;
        [vcs addObject:vc3];
    }
    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    sc.title = [ZBAppSetting standardSetting].pindaoName;
    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    sc.indicator.backgroundColor = UIColorWithMobanTheme;
    
//    sc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchPindao)];
    sc.hidesBottomBarWhenPushed = YES;
    sc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStylePlain target:sc action:@selector(back:)];
    [sc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sc];
    [vc presentViewController:navi animated:YES completion:nil];

}

+ (void)toIntegraDetailVCWithVC:(UIViewController *)vc currencyId:cid currencyType:ctype{
    
    MyIntegralViewController  *mivc=[[MyIntegralViewController alloc] initWithCurrencyId:cid  accountId:[MyIntegralViewController getAccountId] currencyType:ctype currencyName:@"积分"];
    mivc.title=@"我的积分";
    mivc.hidesBottomBarWhenPushed=NO;
        
    [vc.navigationController pushViewController:mivc animated:YES];
    
}



/**
 *  js注入
 */
+ (BOOL)isJsWithUrlStr:(NSString *)string vc:(UIViewController *)vc webView:(UIWebView *)webView {
    NSString *urlStr = string;
    if ([urlStr hasPrefix:@"ixq://xq.getLocation"]) {
        //获取地址
        CGFloat lat = [[[ZBAppSetting standardSetting] latitudeStr] floatValue];
        NSNumber *latNum = [NSNumber numberWithFloat:lat];
        CGFloat lng = [[[ZBAppSetting standardSetting] longitudeStr] floatValue];
        NSNumber *lngNum = [NSNumber numberWithFloat:lng];
        NSString *address = [[ZBAppSetting standardSetting] address];
        NSDictionary *locDic = @{@"accuracy":@(1),@"latitude":latNum,@"longitude":lngNum,@"speed":@(0.0),@"address":address};
        
        NSString *locStr = [locDic JsonString];
        
        NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('getLocation',%@);",locStr];
        NSString *result = [webView stringByEvaluatingJavaScriptFromString:jsStr];
        NSLog(@"result %@",result);
        return YES;
        
    } else if ([urlStr hasPrefix:@"ixq://xq.previewImage"]) {
        
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"str :%@",str);
        NSString *temp = @"ixq://xq.previewImage";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
        
        //图片预览
        NSString *imgUrl = dic[@"current"];
        NSArray *imgUrls = dic[@"urls"];
        if ([imgUrls isKindOfClass:[NSArray class]] && [imgUrl isKindOfClass:[NSString class]] && imgUrl && imgUrls.count>=1) {
            
            BOOL isExist = [imgUrls containsObject:imgUrl];
            if (isExist) {
                
                NSUInteger index = [imgUrls indexOfObject:imgUrl];
                LookPictureVC *picVC = [[LookPictureVC alloc] initWithImageStrs:imgUrls index:index];
                picVC.hidesBottomBarWhenPushed = YES;
                [vc presentViewController:picVC animated:YES completion:nil];
            }
            
        }
        
        return YES;
        
    } else if ([urlStr hasPrefix:@"ixq://xq.choseImage?0"]) {
        
        //图片多选
        ZBHtmlToApp *app = [ZBHtmlToApp sharedZBHtmlToApp];
        app.webView = webView;
        app.vc = vc;
        [app choseImageWithNum:9 vc:app.vc];
        return YES;
        
    } else if ([urlStr hasPrefix:@"ixq://xq.choseImage?1"]) {
        
        //图片单选
        ZBHtmlToApp *app = [ZBHtmlToApp sharedZBHtmlToApp];
        app.webView = webView;
        app.vc = vc;
        [app choseImageWithNum:1 vc:app.vc];
        return YES;
        
    } else if ([urlStr hasPrefix:@"ixq://xq.getLogin"]) {
        
        //登录
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return YES;
        
    } else if ([urlStr hasPrefix:@"ixq://xq.register"]) {
        
        //注册
//        [LoginViewController tologinWithVC:vc];
         [NewLoginContoller tologinWithVC:vc];
        return YES;
        
    } else if ([urlStr hasPrefix:@"ixq://xq.getAppSettings"]) {
        
        //客户version
        UIColor *themeColor = [[ZBAppSetting standardSetting] themeColor];
        NSString *htmlColorStr = [UIColor changeUIColorToRGB:themeColor];
        NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
        NSString *app_name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
        NSDictionary *verDic = @{@"theme_colors":htmlColorStr,@"app_kind":app_kind,@"app_name":app_name};
        
        NSString *locStr = [verDic JsonString];
        
        NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('getAppSettings',%@);",locStr];
        [webView stringByEvaluatingJavaScriptFromString:jsStr];
        return YES;
    } else if ([urlStr hasPrefix:@"ixq://xq.uploadImage"]) {
        //图片上传
        NSArray *arr = [urlStr componentsSeparatedByString:@"?"];
        if ([arr count] != 3 || [arr[2] length]<8) {
            return NO;
        }
        
        NSString *imagePath = arr[2];
        BOOL isShowProgress = [arr[1] isEqualToString:@"1"] ? YES : NO;
        
        imagePath = [imagePath substringFromIndex:7];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        //显示进度条
        MBProgressHUD *hud = nil;
        if (isShowProgress) {
            hud = [[MBProgressHUD alloc] initWithView:vc.view];
            [vc.view addSubview:hud];
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            hud.removeFromSuperViewOnHide = YES;
            [hud show:YES];
        }
        __block MBProgressHUD *bHud = hud;
        
        [UploadImage uploadWithImage:image progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            //
            if (isShowProgress) {
                float progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
                NSLog(@"progress = %f",progress);
                hud.progress = progress;
            }
            
        } completed:^(NSString *imageStr, NSError *error) {
            //
            if(bHud) {
                [bHud hide:YES afterDelay:0.5];
            }
            
            if (imageStr) {
                NSString *imageId = [imageStr substringWithRange:NSMakeRange(5, imageStr.length - 6)];
                NSDictionary *dic = @{@"serverId":imageId};
                NSString *str = [dic JsonString];
                
                NSArray *array=[NSArray arrayWithObjects:@"uploadImage",str,nil];
                
                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleSuccess:) withObject:array waitUntilDone:NO];
                
            }
        }];
        return YES;

    } else if ([urlStr hasPrefix:@"ixq://xq.ajax"]) {
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"str :%@",str);
        NSString *temp = @"ixq://xq.ajax";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
        
        NSDictionary *value = dic[@"value"];
        NSString *tempUrlStr=dic[@"url"];
        NSString *host = dic[@"host"];
        NSString *method = dic[@"method"];
        if ([tempUrlStr isKindOfClass:[NSNull class]] || [value isKindOfClass:[NSNull class]] || [host isKindOfClass:[NSNull class]]) {
            return NO;
        }
            
        //管理者
        AFHTTPRequestOperationManager * aManager =[AFHTTPRequestOperationManager manager];
        //格式
        aManager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/html"];//text/html
        aManager.requestSerializer.timeoutInterval = 45;    //网络超时45秒
        // [aManager.responseSerializer add:[NSSet setWithObject:@"text/plain"]];
        //请求
        //NSLog(@"base: %@-> url:%@",[ApiUrl baseUrlStr], allParameters);
        method = [method uppercaseString];
        if ([method isEqualToString:@"POST"]) {
            [aManager POST:tempUrlStr parameters:value success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *str = [responseObject JsonString];
                
                
                NSArray *array=[NSArray arrayWithObjects:tempUrlStr,str,webView,nil];
                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleSuccess2:) withObject:array waitUntilDone:NO];
                
                
//                NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('%@',%@);",tempUrlStr, str];
//                [webView stringByEvaluatingJavaScriptFromString:jsStr];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                

                
                NSArray *array=[NSArray arrayWithObjects:tempUrlStr,@"",webView,nil];
                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleFail:) withObject:array waitUntilDone:NO];
                
                
//                NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.fail('%@',%@);",tempUrlStr, @""];
//                [webView stringByEvaluatingJavaScriptFromString:jsStr];
//                
//                ZBLog(@"%@", error);
            }];
        } else
        {
            [aManager GET:tempUrlStr parameters:value success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *str = [responseObject JsonString];
                
                
                
                NSArray *array=[NSArray arrayWithObjects:tempUrlStr,str,webView,nil];
                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleSuccess2:) withObject:array waitUntilDone:NO];
                
                //                NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('%@',%@);",tempUrlStr, str];
//                [webView stringByEvaluatingJavaScriptFromString:jsStr];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                NSArray *array=[NSArray arrayWithObjects:tempUrlStr,@"",webView,nil];
                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleFail:) withObject:array waitUntilDone:NO];
                
                
                
//                NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.fail('%@',%@);",tempUrlStr, @""];
//                [webView stringByEvaluatingJavaScriptFromString:jsStr];
//                ZBLog(@"%@", error);
            }];
        }
        return YES;
    }else if ([urlStr hasPrefix:@"ixq://xq.ocApi"]) {
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp = @"ixq://xq.ocApi";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
        
        NSDictionary *value = dic[@"value"];
        NSString *tempUrlStr=dic[@"action"];
        NSString *host = dic[@"host"];
        if ([tempUrlStr isKindOfClass:[NSNull class]] || [value isKindOfClass:[NSNull class]] || [host isKindOfClass:[NSNull class]]) {
            return NO;
        }
        
        [NetRequest urlStr:tempUrlStr parameters:value success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *str = [responseObject JsonString];
            
            NSArray *array=[NSArray arrayWithObjects:tempUrlStr,str,webView,nil];
            [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleSuccess2:) withObject:array waitUntilDone:NO];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSArray *array=[NSArray arrayWithObjects:tempUrlStr,@"",webView,nil];
            [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleFail:) withObject:array waitUntilDone:NO];
            
//            NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.fail('%@',%@);",tempUrlStr, @""];
//            [webView stringByEvaluatingJavaScriptFromString:jsStr];
//            ZBLog(@"%@", error);
        }];
        
        return YES;
        
    }  else if ([urlStr hasPrefix:@"ixq://xq.shareToWechatMoments"]) {
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp = @"ixq://xq.shareToWechatMoments";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }

//        imgUrl = "http://demo.open.weixin.qq.com/jssdk/images/p2166127561.jpg";
//        musicUrl = "";
//        shareType = 2;
//        text = "ha--ha";
//        title = "\U4e92\U8054\U7f51\U4e4b\U5b50";
//        url = "http://www.opencom.cn";
        
        
       // [self shareWith:ShareTypeWeixiTimeline imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"]];
        
        
        [self shareWith:ShareTypeWeixiTimeline imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"] uiwebview:webView jsCode:@"shareToWechatMoments"];
        
          return YES;
    }else if ([urlStr hasPrefix:@"ixq://xq.shareToQZone"]){
        
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp = @"ixq://xq.shareToQZone";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
        //[self shareWith:ShareTypeQQSpace imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"]];
        
        [self shareWith:ShareTypeQQSpace imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"] uiwebview:webView jsCode:@"shareToQZone"];
        return YES;
        
    }else if([urlStr hasPrefix:@"ixq://xq.shareToQQ"]){
      
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp = @"ixq://xq.shareToQQ";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
       // [self shareWith:ShareTypeQQ imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"]];
        
        [self shareWith:ShareTypeQQ imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"] uiwebview:webView jsCode:@"shareToQQ"];
        
        return YES;
        
    }else if([urlStr hasPrefix:@"ixq://xq.shareToWechat"]){
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp = @"ixq://xq.shareToWechat";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
        //[self shareWith:ShareTypeWeixiSession imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"]];
        
        [self shareWith:ShareTypeWeixiSession imageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"] uiwebview:webView jsCode:@"shareToWechat"];
        
        return YES;
        
    }else if ([urlStr hasPrefix:@"ixq://xq.onShare"]){
        NSString *str = urlStr;
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp = @"ixq://xq.onShare";
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            //转换失败
            return NO;
        }
        
        [self shareToAllWithImageUrl:dic[@"imgUrl"] title:dic[@"title"] text:dic[@"text"] url:dic[@"url"] uiwebview:webView jsCode:@"onShare"];
        
        return YES;
        
    }else if([urlStr hasPrefix:@"ixq://xq.scanQRCode"]){
            
        //JS 调用原生的扫描二维码，(签到)
         ZBHtmlToApp *app = [ZBHtmlToApp sharedZBHtmlToApp];
         app.webView = webView;
         app.vc = vc;
         [app scanViewResultCodeWithVc:vc handleCode:urlStr];
         return YES;
    }else if([urlStr hasPrefix:@"ixq://xq.hideTitleView"]){
    
        [vc.navigationController setNavigationBarHidden:true animated:TRUE];
        //[vc.navigationController setToolbarHidden:true animated:TRUE];
        
    }else if ([urlStr hasPrefix:@"ixq://xq.showTitleView"]){
        [vc.navigationController setNavigationBarHidden:false animated:TRUE];
        //[vc.navigationController setToolbarHidden:false animated:TRUE];
        
    }else if([urlStr hasPrefix:@"ixq://xq.closeWindow"]){
        
        //判断是否需要再按一次 如果是超链 并且又是导航根控制器
        if ([vc isKindOfClass:[ZBSuperCSTabVC class]]) {
            if(hud2==nil){
                [self showTextDialog:GDLocalizedString(@"再按一次退出") controller:webView];
            }else{
                [self exitApplication:vc];
            }
            return NO;
        }
        
        if (vc.navigationController) {
            [vc.navigationController popViewControllerAnimated:YES];
            return NO;
        }
    }else if([urlStr hasPrefix:@"ixq://xq.showMsg"]){
        NSArray *arr = [urlStr componentsSeparatedByString:@"?"];
        [self showTextDialog:arr[1] controller:webView];
        
    }else if([urlStr hasPrefix:@"ixq://xq.exchange"]){
        NSString *str = urlStr;
        NSString *temp = @"ixq://xq.exchange";
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 1)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
        
        NSString *goodsId = dic[@"goods_id"];
        NSString *goodsName=dic[@"goods_name"];
        NSString *goodsNum = dic[@"goods_num"];
        NSString *integral = dic[@"integral"];
        NSString *currencyId=dic[@"currency_id"];
        NSString *currencyType = dic[@"currency_type"];
        
        NSString *uid = dic[@"uid"];
        NSString *appKind=dic[@"app_kind"];
        NSString *token = dic[@"token"];
        
        NSString *info = dic[@"info"];
        NSString *callbackUrl=dic[@"callback_url"];
        NSString *appId=dic[@"app_id"];
        
    
        [self getUserIntegralWithCurrencyId:currencyId currencyType:currencyType integral:integral successBlock:^{
                MyGiftTableViewController *mgtvc=[[MyGiftTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
                mgtvc.goodsId=goodsId;
                mgtvc.goodsName=goodsName;
                mgtvc.goodsNum=goodsNum;
                mgtvc.integral=integral;
                mgtvc.currencyId=currencyId;
                mgtvc.currencyType=currencyType;
                mgtvc.uid=uid;
                mgtvc.appKind=appKind;
                mgtvc.token=token;
                mgtvc.info=info;
                mgtvc.callbackUrl=callbackUrl;
                mgtvc.appId=appId;
                mgtvc.userPoint=userPoint;
            
                mgtvc.accountInfo=accountInfo;
            
                mgtvc.hidesBottomBarWhenPushed=NO;
                
                mgtvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:mgtvc action:@selector(back:)];
                [mgtvc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mgtvc];
                [vc presentViewController:navi animated:YES completion:Nil];
         
        } failBlock:^{
            MyNoEnoughTableViewController *mnetvc=[[MyNoEnoughTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            mnetvc.hidesBottomBarWhenPushed=NO;
            mnetvc.goodsName=goodsName;
            mnetvc.integral=integral;
            mnetvc.currencyId=currencyId;
            mnetvc.accountInfo=accountInfo;

            mnetvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:mnetvc action:@selector(back:)];
            [mnetvc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mnetvc];
            
            [vc presentViewController:navi animated:YES completion:Nil];
        }];
        return  YES;
        
    }else if([urlStr hasPrefix:@"ixq://xq.shareToPost"]){
        
        NSString *str = urlStr;
        NSString *temp = @"ixq://xq.shareToPost";
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 2)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
        
        NSString *subTitle = dic[@"title"];
        NSString *subText = dic[@"text"];
        
        
        [self toNewPostVCWithVC:vc subTitle:subTitle subContent:subText];
        
    }else if([urlStr hasPrefix:@"ixq://xq.pointsPay"]){
        NSString *str = urlStr;
        NSString *temp = @"ixq://xq.pointsPay";
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        str = [str substringWithRange:NSMakeRange(temp.length + 1, str.length - temp.length - 1)];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return NO;
        }
        
        NSString *goodsId = dic[@"goods_id"];
        NSString *goodsName=dic[@"goods_name"];
        NSString *goodsNum = dic[@"goods_num"];
        
        NSString *integral = dic[@"integral"];
        NSString *currencyId=dic[@"currency_id"];
        NSString *currencyType = dic[@"currency_type"];
        
        NSString *uid = dic[@"uid"];
        NSString *appKind=dic[@"app_kind"];
        NSString *token = dic[@"token"];
        
        NSString *info = dic[@"info"];
        NSString *param = dic[@"param"];
        NSString *callbackUrl=dic[@"callback_url"];
        NSString *appId=dic[@"app_id"];
        
        NSArray *mlist=dic[@"list"];
        
        NSString *mtitle=dic[@"title"];
        
        NSString *mdetailUrl=dic[@"details_url"];
        
        
        NSString *mmoney=dic[@"money"];
        
        
        NSString *mdiyTitle=dic[@"diy_title"];
        NSString *mdiyName = dic[@"diy_name"];
        NSString *mdiyMoney = dic[@"diy_money"];
        NSString *mdiyPassWord=dic[@"diy_password"];
        NSString *mdiySureText=dic[@"diy_sure_text"];
        NSString *mdiyCancelText=dic[@"diy_cancel_text"];
        
        NSString *morderName=dic[@"order_name"];
        
        
    
        
        [self getUserIntegralWithCurrencyId:currencyId currencyType:currencyType integral:integral successBlock:^{
//            MyGiftTableViewController *mgtvc=[[MyGiftTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            NewGiftChargeTableViewController *mgtvc=[[NewGiftChargeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
//            mgtvc.goodsId=goodsId;
//            mgtvc.goodsName=goodsName;
//            mgtvc.goodsNum=goodsNum;
            mgtvc.integral=integral;
            mgtvc.currencyId=currencyId;
            mgtvc.currencyType=currencyType;
            mgtvc.uid=uid;
            mgtvc.appKind=appKind;
            mgtvc.token=token;
            mgtvc.info=info;
            mgtvc.list=mlist;
            
            mgtvc.money=mmoney;
            
            mgtvc.param=param;
            
            mgtvc.info=info;
            
            mgtvc.mtitle=mtitle;
            
              mgtvc.detailsUrl=mdetailUrl;
            
            
            mgtvc.callbackUrl=callbackUrl;
            mgtvc.appId=appId;
//            mgtvc.userPoint=userPoint;
            
            
            mgtvc.orderName=morderName;
            
            
            mgtvc.diyTitle=mdiyTitle;
            
            mgtvc.diyName=mdiyName;
            
            
            mgtvc.diyPassword=mdiyPassWord;
            
            mgtvc.diyMoney=mdiyMoney;
            
            mgtvc.diySureText=mdiySureText;
            mgtvc.diyCancelText=mdiyCancelText;
            
            mgtvc.userPoint=userPoint;
            
            mgtvc.accountInfo=accountInfo;
            
            mgtvc.hidesBottomBarWhenPushed=NO;
            
            mgtvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:mgtvc action:@selector(back:)];
            [mgtvc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mgtvc];
            [vc presentViewController:navi animated:YES completion:Nil];
            
            NSArray *array=[NSArray arrayWithObjects:@"pointsPay",@"success",webView,nil];
            [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleSuccess2:) withObject:array waitUntilDone:NO];
            
        } failBlock:^{
            NewNoEnoughTabelViewController *mnetvc=[[NewNoEnoughTabelViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            mnetvc.hidesBottomBarWhenPushed=NO;
            mnetvc.integral=integral;
            mnetvc.currencyId=currencyId;
            mnetvc.accountInfo=accountInfo;
                        
            mnetvc.diyTitle=mdiyTitle;
            mnetvc.diyName=mdiyName;
            mnetvc.diyPassword=mdiyPassWord;
            mnetvc.diyMoney=mdiyMoney;
            mnetvc.diySureText=mdiySureText;
            mnetvc.diyCancelText=mdiyCancelText;
            
            mnetvc.list=mlist;
            
            
            mnetvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:mnetvc action:@selector(back:)];
            [mnetvc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:mnetvc];
            
            [vc presentViewController:navi animated:YES completion:Nil];
            
            NSArray *array=[NSArray arrayWithObjects:@"pointsPay",@"cancel",webView,nil];
            [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(handleFail:) withObject:array waitUntilDone:NO];
            
        }];
        return  YES;
        
    }
    return NO;
}



+(void)getUserIntegralWithCurrencyId:(NSString *)currencyId currencyType:(NSString *)currencyType integral:(NSString *)integral  successBlock:(void (^)())sb failBlock:(void (^)())fb{

    NSDictionary *dict =@{
                          @"currency_id":currencyId,
//                          @"account_id":[MyIntegralViewController getAccountId],
                          @"currency_type":currencyType
                          };
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFAccountInfo] parameters:dict success:^(id responseObject) {
        
        NSDictionary *dict2 =responseObject;
        
        if ([dict2[@"ret"] intValue]>0) {
            
            accountInfo = [CFAccountInfo objectWithKeyValues:dict2];
            userPoint=accountInfo.sum;
            
            if([userPoint intValue] > [integral intValue]){
                if (sb) {
                    sb();
                }
            }else{
                if (fb) {
                    fb();
                }
            }
            
        }
        
    } fail:^(NSError *error) {
        
    }];
}

+(void)showTextDialog:(NSString *)str controller:(UIWebView *)webView{

    hud2=[[MBProgressHUD alloc] initWithView:webView];
    
    [webView addSubview:hud2];
    
    hud2.detailsLabelText = str;
    hud2.labelFont = [UIFont systemFontOfSize:13];
    
    hud2.userInteractionEnabled=NO;
    hud2.mode=MBProgressHUDModeCustomView;

    [hud2 showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud2 removeFromSuperview];
        hud2=nil;
    }];
    
}



+ (void)exitApplication:(UIViewController *)vc {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:vc.view.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    vc.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
    
}



//+ (void)shareWith:(ShareType)shareType imageUrl:(NSString *)imageUrl title:(NSString *)title text:(NSString *)text url:(NSString *)url completionBlock:(void (^)())completion cancelBlock:(void(^)())cancelBlock
//{
//    //发送内容给微信
//    id<ISSContent> content = [ShareSDK content:text
//                                defaultContent:text
//                                         image:[ShareSDK imageWithUrl:imageUrl]
//                                         title:title
//                                           url:url
//                                   description:nil
//                                     mediaType:SSPublishContentMediaTypeNews];
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
//    
//    
//    [ShareSDK shareContent:content
//                      type:shareType
//               authOptions:authOptions
//             statusBarTips:YES
//                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                        
//                        if (state == SSPublishContentStateSuccess)
//                        {
//                            
//                            
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                
//                         
//                                //[[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(abcdeWithUIWebView) withObject:self waitUntilDone:YES];
//                              
//                            });
//                        }
//                        else if(state==SSPublishContentStateCancel){
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                cancelBlock();
//                            });
//                        }
//                        else if (state == SSPublishContentStateFail)
//                        {
//                            if ([error errorCode] == -22003)
//                            {
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
//                                                                                    message:[error errorDescription]
//                                                                                   delegate:nil
//                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
//                                                                          otherButtonTitles:nil];
//                                [alertView show];
//                            }
//                        }
//                    }];
//    
//    
//    
//}
//
//
//


+ (void)shareWith:(ShareType)shareType imageUrl:(NSString *)imageUrl title:(NSString *)title text:(NSString *)text url:(NSString *)url uiwebview:(UIWebView *)webview jsCode:(NSString *)jsCode
{
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:text
                                defaultContent:text
                                         image:[ShareSDK imageWithUrl:imageUrl]
                                         title:title
                                           url:url
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    [ShareSDK shareContent:content
                      type:shareType
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        NSArray *array=[NSArray arrayWithObjects:webview,jsCode,nil];
                        if (state == SSPublishContentStateSuccess)
                        {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(successWithUIWebView:) withObject:array waitUntilDone:NO];
                                
                            });
                        }
                        else if(state==SSPublishContentStateCancel){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(cancelWithUIWebView:) withObject:array waitUntilDone:NO];
                                
                            });
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    }];
    
    
}

-(void)successWithUIWebView:(NSArray *)array{
    NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success(\"%@\",'success');",array[1]];
    [array[0] stringByEvaluatingJavaScriptFromString:jsStr];
}



-(void)cancelWithUIWebView:(NSArray *)array{
    NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.cancel(\"%@\",'cancel');",array[1]];
    [array[0] stringByEvaluatingJavaScriptFromString:jsStr];
}




+(void)shareToAllWithImageUrl:(NSString *)imageUrl title:(NSString *)title text:(NSString *)text url:(NSString *)url uiwebview:(UIWebView *)webview jsCode:(NSString *)jsCode

{
    
    id<ISSContainer> container = [ShareSDK container];
    
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:text
                                defaultContent:text
                                         image:[ShareSDK imageWithUrl:imageUrl]
                                         title:title
                                           url:url
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
        //自定义标题栏相关委托
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:GDLocalizedString(@"分享话题")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
    
    
        NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,nil];
    
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:content
                         statusBarTips:NO
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                       NSArray *array=[NSArray arrayWithObjects:webview,jsCode,nil];
                                    if (state == SSResponseStateSuccess)
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(successWithUIWebView:) withObject:array waitUntilDone:NO];

                                        });
                                        
                                       //[Praise hudShowTextOnly:GDLocalizedString(@"分享成功") delegate:self];
                                    }
                                    else if(state==SSPublishContentStateCancel){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                             [[ZBHtmlToApp sharedZBHtmlToApp] performSelectorOnMainThread:@selector(cancelWithUIWebView:) withObject:array waitUntilDone:NO];
                                        });
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                        [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"分享失败"),[error errorDescription]] delegate:self];
                                    }
                                }];

}




//    id<ISSContainer> container = [ShareSDK container];
//



//
//    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];

//
//    id<ISSCAttachment> imageAttach=[ShareSDK imageWithData:imageData fileName:@"test22.jpg" mimeType:@"jpg"];
//
//
//    
//    NSString *redesc=[NSString stringWithFormat:@"描述//%@",text];
//    
//    id<ISSContent> publishContent = [ShareSDK content:redesc
//                                       defaultContent:text
//                                                image:[ShareSDK imageWithUrl:imageUrl]
//                                                title:title
//                                                  url:url
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
//
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                     allowCallback:YES
//                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                      viewDelegate:nil
//                                           authManagerViewDelegate:nil];

    
//    //自定义标题栏相关委托
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:GDLocalizedString(@"分享话题")
//                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:YES
//                                                       wxTimelineButtonHidden:YES
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil
//                                                        picViewerViewDelegate:nil];
//    
//    
//    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,nil];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:NO
//                       authOptions:authOptions
//                      shareOptions:shareOptions
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    [Praise hudShowTextOnly:GDLocalizedString(@"分享成功") delegate:self];
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
//                                    [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"分享失败"),[error errorDescription]] delegate:self];
//                                }
//                            }];

//}





+ (void)shareImageToWechatMomentsWithImageUrl:(NSString *)imageUrl title:(NSString *)title text:(NSString *)text url:(NSString *)url
{
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:text
                                defaultContent:text
                                         image:[ShareSDK imageWithUrl:imageUrl]
                                         title:title
                                           url:url
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
                                                                                    message:[error errorDescription]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    }];
    
//    [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline container:nil content:content statusBarTips:YES authOptions:authOptions shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSPublishContentStateSuccess)
//        {
//            NSLog(@"success");
//        }
//        else if (state == SSPublishContentStateFail)
//        {
//            if ([error errorCode] == -22003)
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TEXT_TIPS", @"提示")
//                                                                    message:[error errorDescription]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:NSLocalizedString(@"TEXT_KNOW", @"知道了")
//                                                          otherButtonTitles:nil];
//                [alertView show];
//            }
//        }
//
//    }];
}

- (void)choseImageWithNum:(int)num vc:(UIViewController *)vc{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = num;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.title = GDLocalizedString(@"照片");
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [vc presentViewController:navigationController animated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    
    NSLog(@"assets %@",assets);
    //[self addJsWithAssets:assets];
    
    //[self dismissImagePickerController];
    [self.vc dismissViewControllerAnimated:YES completion:^{
        [self addJsWithAssets:assets];
    }];
}

- (void)dismissImagePickerController
{
    if (self.vc.presentedViewController) {
        [self.vc dismissViewControllerAnimated:YES completion:Nil];
    } else {
        [self.vc.navigationController popToViewController:self.vc animated:YES];
    }
}

- (void)addJsWithAssets:(NSArray *)assets {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<[assets count]; i++) {
        ALAsset *asset = assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        image = image ? image : [UIImage imageWithCGImage:asset.thumbnail];
        NSString *imagePath = [self.class filePathWithImage:image];
        NSString *imageUrlStr = [NSString stringWithFormat:@"file://%@",imagePath];
        [images addObject:imageUrlStr];
    }
    

    NSDictionary *dic = @{@"localIds":[images copy]};
    
    NSString *dicStr = [dic JsonString];
    
    
    NSArray *array=[NSArray arrayWithObjects:@"choseImage",dicStr,nil];
    
    [self performSelectorOnMainThread:@selector(handleSuccess:) withObject:array waitUntilDone:NO];
    
}



-(void)handleSuccess:(NSArray *)array{
    NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('%@',%@);",array[0],array[1]];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}



-(void)handleSuccess2:(NSArray *)array{
    NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('%@',%@);",array[0],array[1]];
    [array[2] stringByEvaluatingJavaScriptFromString:jsStr];
}



-(void)handleFail:(NSArray *)array{
    NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.fail('%@',%@);",array[0],array[1]];
    [array[2] stringByEvaluatingJavaScriptFromString:jsStr];
}





+ (NSString *)filePathWithImage:(UIImage *)image {
    //压缩
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: [[NSTimeZone systemTimeZone] secondsFromGMTForDate:datenow]];
    NSString *tmpFile= [NSString stringWithFormat:@"%@tmp%ld.jpg",NSTemporaryDirectory(),(long)[localeDate timeIntervalSince1970]] ;
    [data writeToFile:tmpFile atomically:NO];
    
    return tmpFile;
}


-(void)scanViewResultCodeWithVc:(UIViewController *)vc handleCode:(NSString *)handleCode{
    ScanViewController *scanController=[[ScanViewController alloc] init];
    scanController.handleCode=handleCode;
    scanController.delegate=self;
    [vc presentViewController:scanController animated:YES completion:NULL];
}



//代理方法
- (void)scanViewController:(ScanViewController *)vc DidFinishedWithString:(NSString *)string{
    
    
    NSArray *array = [vc.handleCode componentsSeparatedByString:@"?"];

    NSString *code=array[1];
    
    if ([code isEqualToString:@"0"]) {
        
        [ScanViewController resultDispalyByString:string viewController:vc];
        
    }else if ([code isEqualToString:@"1"]){
        NSString *jsStr = [NSString stringWithFormat:@"javascript:oc.success('scanQRCode',{'resultStr':\"%@\"});",string];
        [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
        
    }else{
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
        scanParam=array[2];
        scanParam=[NSString stringWithFormat:@"%@%@",@"&",scanParam];
        [self.webView loadRequest:request];
    }
}


- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}
@end
