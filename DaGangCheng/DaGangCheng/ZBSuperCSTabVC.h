//
//  ZBSuperCSTabVC.h
//  DaGangCheng
//
//  Created by huaxo on 15-2-6.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTWebVC.h"
#import "ZBSuperCS.h"

#import "ScanViewController.h"

@interface ZBSuperCSTabVC : UIViewController <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, assign) BOOL isShowTitle;
@property (nonatomic, assign) BOOL isShowBall;
@end
