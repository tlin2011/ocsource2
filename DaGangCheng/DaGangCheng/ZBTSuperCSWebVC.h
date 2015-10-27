//
//  ZBTSuperCSWebVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-9.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTWebVC.h"
#import "AppDelegate.h"
#import "PostManagerView.h"
#import "ZBTSuperCSReplyView.h"
#import "Praise.h"

@interface ZBTSuperCSWebVC : ZBTWebVC
@property (nonatomic, copy) NSString *postId;

//去除字符串中的token
+ (NSString *)stringRemoveToken:(NSString *)string;

//刷新页面
- (void)clickedWebBackBtn:(id)sender;
@end
