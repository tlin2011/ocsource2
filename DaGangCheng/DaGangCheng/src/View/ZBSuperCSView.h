//
//  ZBSuperCSView.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-18.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCoreText.h"
#import "AFNetworking.h"
#import "ZBSuperCS.h"
#import "ZBHtmlToApp.h"

@class ZBSuperCSView;
@protocol ZBSuperCSViewDelegate <NSObject>
@required
- (void)supCSViewShouldRefresh:(ZBSuperCSView *)csView;
@end

@interface ZBSuperCSView : UILabel <UIWebViewDelegate, ZBSuperCSDelegate>

@property (strong, nonatomic) ZBCoreText *coreText;
@property (weak,   nonatomic) id<ZBSuperCSViewDelegate>delegate;
@property (copy, nonatomic) NSString *imageID;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIImageView *imageView;

@end
