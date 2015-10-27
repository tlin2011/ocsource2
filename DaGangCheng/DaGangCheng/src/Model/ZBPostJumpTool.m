//
//  ZBPostJumpTool.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/29.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPostJumpTool.h"

@implementation ZBPostJumpTool

+ (void)intoPostPage:(NSString*) postId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc;
{
    PostViewController * next =[[PostViewController alloc] init];
    next.delegate = delegate;
    next.index = index;
    next.postID = postId;
    next.title = GDLocalizedString(@"查看话题");
    next.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:next animated:YES];
}

+ (void)intoPostPage:(NSString*) postId kindId:(NSString *)kindId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc{
    PostViewController * next =[[PostViewController alloc] init];
    next.delegate = delegate;
    next.index = index;
    next.postID = postId;
    next.kindId=kindId;
    next.title = GDLocalizedString(@"查看话题");
    next.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:next animated:YES];
}

+ (void)intoWebPage:(NSString *)urlStr vc:(UIViewController *)vc
{
    ZBSuperCSTabJumpVC *webVC = [[ZBSuperCSTabJumpVC alloc] init];
    webVC.urlStr = urlStr;
    webVC.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:webVC animated:YES];
}

+ (void)intoPage:(NSString*) postId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc urlStr:(NSString *)urlStr;
{
    if ([urlStr hasPrefix:@"http"]) {
        [self intoWebPage:urlStr vc:vc];
    } else
    {
        [self intoPostPage:postId withIndex:index delegate:delegate vc:vc];
    }
}

+ (void)intoPage:(NSString*) postId  kindId:(NSString *)kindId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc urlStr:(NSString *)urlStr{
    if ([urlStr hasPrefix:@"http"]) {
        [self intoWebPage:urlStr vc:vc];
    } else
    {
        [self intoPostPage:postId kindId:kindId  withIndex:index delegate:delegate vc:vc];
    }
}


+ (void)intoAdPageWithUrlStr:(NSString *)urlStr vc:(UIViewController *)vc {
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSString *appName = app_kind;
    
    NSString *pindaoUrlStr = [NSString stringWithFormat:@"http://cs.opencom.cn/bbs/%@/channel/",appName];
    NSString *postUrlStr = [NSString stringWithFormat:@"http://cs.opencom.cn/bbs/%@/post/",appName];
    
    if ([urlStr hasPrefix:pindaoUrlStr]) {
        NSString *pindaoId = [urlStr substringFromIndex:pindaoUrlStr.length];
        if ([pindaoId length]>1) {
            [ZBHtmlToApp toPindaoVCWithPindaoId:[pindaoId integerValue] vc:vc];
            return;
        }
    } else if ([urlStr hasPrefix:postUrlStr]) {
        NSString *postId = [urlStr substringFromIndex:postUrlStr.length];
        if ([postId length]>1) {
            [ZBHtmlToApp toPostVCWithPostId:[postId integerValue] vc:vc];
            return;
        }
    } else if ([urlStr hasPrefix:@"http"]) {
        [ZBHtmlToApp toWebVCWithUrlStr:urlStr vc:vc];
    }
    
}



@end