//
//  ZBPostJumpTool.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/29.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostViewController.h"
#import "ZBHtmlToApp.h"

@interface ZBPostJumpTool : NSObject

/**
 *  跳转查看话题页面
 */
+ (void)intoPostPage:(NSString*) postId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc;



+ (void)intoPostPage:(NSString*) postId kindId:(NSString *)kindId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc;
/**
 *  跳转web页面
 */
+ (void)intoWebPage:(NSString *)urlStr vc:(UIViewController *)vc;

/**
 *  跳转页面
 */
+ (void)intoPage:(NSString*) postId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc urlStr:(NSString *)urlStr;


/**
 *  跳转页面
 */
+ (void)intoPage:(NSString*) postId  kindId:(NSString *)kindId withIndex:(NSInteger)index delegate:(id<PostViewControllerDelegate>)delegate vc:(UIViewController *)vc urlStr:(NSString *)urlStr;

/**
 *  广告跳转
 */
+ (void)intoAdPageWithUrlStr:(NSString *)urlStr vc:(UIViewController *)vc;

@end
