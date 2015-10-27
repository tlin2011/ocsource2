//
//  ZBTWebVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBWebProgressView.h"
#import "ZBHtmlToApp.h"

@interface ZBTWebVC : UIViewController
@property (nonatomic, strong) ZBWebProgressView *progressView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *urlStr;
@end
