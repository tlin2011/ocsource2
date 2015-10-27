//
//  ZBSuperCS.h
//  ZBSuperCS
//
//  Created by huaxo on 15-2-3.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CustomBlock)(NSDictionary * customDict);

@class ZBSuperCS;
@protocol ZBSuperCSDelegate <NSObject>

@required
- (void)superCS:(ZBSuperCS *)cs clickedImageWithInfo:(NSDictionary *)info;
- (void)superCS:(ZBSuperCS *)cs webDidFinishLoad:(UIWebView *)webView;
- (BOOL)superCS:(ZBSuperCS *)cs webShouldStartLoad:(UIWebView *)webView request:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

/**
 *  显示图片超链的图片
 */
- (void)superCS:(ZBSuperCS *)cs displayPhotoCSWithButton:(UIButton *)button andImageId:(NSString *)imageId;
@end

@interface ZBSuperCS : UIView
@property (nonatomic, weak) id<ZBSuperCSDelegate>delegate;


@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *app_kind;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *token_msg;

- (void)loadRequest;
- (void)setViewFrame:(CGRect)rect;

+ (NSDictionary *)parameterWithcs:(NSString *)cs uid:(NSString *)uid sid:(NSString *)sid gps:(NSString *)gps;

+ (void)startRequestSuperCS:(NSDictionary *)parameter haveTokenBlock:(CustomBlock)sender;
//请求超链并解析
- (void)startRequestSuperCS:(NSDictionary *)parameter passBlock:(CustomBlock)sender;
@end
