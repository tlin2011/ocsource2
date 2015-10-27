//
//  ZBTUIWebViewController.h
//  UIWebViewTest
//
//  Created by huaxo2 on 15/9/10.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZBTUIWebViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIScrollView *allSubView;

@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)UIButton *titleBtn;

@property(nonatomic,strong)UIButton *refreshBtn;

@property(nonatomic,strong)UIButton *moreBtn;

@property(nonatomic,strong)UIView *inputView;
@property(nonatomic,strong)UITextField *urlField;
@property(nonatomic,strong)UIButton *clearBtn;

@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)UIWebView *zbtWebView;




@property(nonatomic,strong)NSString *webViewUrl;


+(void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content imageData:(NSData*)imageData view:(UIView *)uiView type:(SSPublishContentMediaType)type;

+(void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content imageData:(NSData*)imageData view:(UIView *)uiView;

+(UIImage *)imageWithscreenShot;


@property(nonatomic,strong)UIButton *managerBtn;


@property (nonatomic, assign) BOOL isShowBall;


@property (nonatomic, assign) BOOL isShowTitle;


@end
