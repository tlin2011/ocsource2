//
//  ZBSuperCSView.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-18.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBSuperCSView.h"

@implementation ZBSuperCSView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    //
    self.text = GDLocalizedString(@"加载中...");
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [UIColor grayColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = YES;
}

//懒加载webView
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.scrollView.scrollEnabled = NO;
        self.webView.delegate = self;
        [self addSubview:_webView];
    }
    return _webView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [_imageView addGestureRecognizer:tap];

        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ZBSuperCS *cs = self.coreText.kindData;
    if (!self.coreText.state) {
        //
        [self getSuperCSHeight];
        
    } else if (cs && self.coreText.state==2){
        
        //
        //self.view = [cs view];
        //self.view.frame = CGRectMake(0, 0, self.coreText.rect.size.width, self.coreText.rect.size.height);
//        NSLog(@"cs view frame %@", NSStringFromCGRect(self.frame));
        //[self addSubview:self.view];
        
        self.imageView.frame = CGRectMake(0, 4, self.coreText.rect.size.width, self.coreText.rect.size.height-2*4);
        NSLog(@"imgView.frame %@",NSStringFromCGRect(self.imageView.frame));
        //[self addSubview:self.button];
        
    }else if (cs && self.coreText.state==3) {
        
        self.webView.frame = CGRectMake(0, 0, self.coreText.rect.size.width, self.coreText.rect.size.height);
        //
        NSLog(@"webview frame = %@", NSStringFromCGRect(self.webView.frame));
        //[self addSubview:self.webView];
    }

}

- (void)getSuperCSHeight {
    self.coreText.state = 1;
    NSString *urlStr = self.coreText.string;
    
    ZBSuperCS *supCS = [[ZBSuperCS alloc] init];
    supCS.delegate = self;
    
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
    
    
    
    [supCS startRequestSuperCS:param passBlock:^(NSDictionary *customDict) {
        if (customDict) {
            NSLog(@"customDict %@",customDict);
            ZBSuperCS *cs = customDict[@"cs"];
            
            if (cs) {
                
                
                
                //如果是图片就刷新
                UIView *v = cs.view;
                if ([v isKindOfClass:[UIButton class]] && [self.delegate respondsToSelector:@selector(supCSViewShouldRefresh:)]) {
                    
                    self.coreText.kindData = cs;
                    CGRect rect = self.coreText.rect;
                    NSInteger w = rect.size.width;
                    NSInteger h = cs.size.height/cs.size.width*w;
                    rect.size.height = h;
                    self.coreText.rect = rect;
                    self.coreText.state = 2;
                    
                    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[self.imageID integerValue] w:400]] placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
                    
                    [self.delegate supCSViewShouldRefresh:self];
                }else if ([v isKindOfClass:[UIWebView class]]){
                    //[cs loadRequest];

                    //self.coreText.state = 1;
                    self.coreText.kindData = cs;
                    
                    self.webView.frame = CGRectMake(0, 0, self.coreText.rect.size.width, self.coreText.rect.size.height);
                    
                    if (![self.webView isLoading]) {
                        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:cs.urlStr]];
                        [self.webView loadRequest:request];
                    }
                }
                
            }
        } else {
            //bself.coreText.state = 0;
        }
    }];
    
}

#pragma mark -- ZBSuperCS
- (void)superCS:(ZBSuperCS *)cs displayPhotoCSWithButton:(UIButton *)button andImageId:(NSString *)imageId {
    self.imageID = imageId;
}


#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    /*
     * 页面跳转
     */
    NSString *targetJs = @"javascript: var allLinks = document.getElementsByTagName('a');if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target');if (target && target == '_blank'){link.setAttribute('target','_self');link.setAttribute('href','newtab:'+link.href);}}}";
    
    [webView stringByEvaluatingJavaScriptFromString:targetJs];

    /**
     *  返回页面高度
     */
    NSString *js = @"javascript: Math.max(document.body.scrollHeight,document.documentElement.scrollHeight);";
    
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:js];
    //NSLog(@"111 str:%@",str);
    CGSize size = CGSizeMake(0, [str integerValue]);
    
    if (self.coreText.kindData) {
        
        //ZBSuperCS *cs = (ZBSuperCS *)self.coreText.kindData;
        
        CGRect rect = self.coreText.rect;
        rect.size.height = size.height;
        if (rect.origin.x == 0) {
            rect.origin.x = -10;
            rect.size.width += 20;
        }
        self.coreText.rect = rect;
        self.coreText.state = 3;
        
    }
    
    
    //如果是网页就刷新
    if ([self.delegate respondsToSelector:@selector(supCSViewShouldRefresh:)]) {
        [self.delegate supCSViewShouldRefresh:self];
    }
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSURL *url = [request URL] ;
    NSString *urlStr = [url relativeString];
    
    UIViewController *vc = [ZBAppSetting standardSetting].postController;
    if (vc) {
        //遵守超链规则
        if ([ZBHtmlToApp isSupCSRuleWithUrlStr:urlStr vc:vc webView:webView]) {
            //取消网页请求
            return NO;
        }
    }
    return YES;
    
}


- (void)imageViewClicked:(id)sender {
    NSLog(@"点击超链图片");
    ZBSuperCS *cs = (ZBSuperCS *)self.coreText.kindData;
    UIViewController *vc = [ZBAppSetting standardSetting].postController;
    [ZBHtmlToApp toWebVCWithUrlStr:cs.urlStr vc:vc];
}

- (void)dealloc {
    self.webView = nil;
    self.imageView = nil;
}

@end
