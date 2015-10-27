//
//  ZBTUIWebViewController.m
//  UIWebViewTest
//
//  Created by huaxo2 on 15/9/10.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import "ZBTUIWebViewController.h"
#import "ZBTPostManagerView.h"


#import "TabPostManagerView.h"


#import "HudUtil.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface ZBTUIWebViewController ()<ZBTPostManagerViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,ISSShareViewDelegate,TabPostManagerViewDelegate>



@end

@implementation ZBTUIWebViewController

static NSString *saveImagePath;

bool changWebViewHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubView];
    
    
    self.view.backgroundColor=UIColorWithMobanTheme;
    
    _zbtWebView.scrollView.showsHorizontalScrollIndicator=NO;
    _zbtWebView.scrollView.showsVerticalScrollIndicator=NO;
    
    [self initGestureRecognizer];
    
    self.view.userInteractionEnabled=YES;
    
    [super.navigationController setNavigationBarHidden:true animated:TRUE];
    
    
    [self loadWebPageWithString:_webViewUrl];
    
    changWebViewHeight=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated{
    self.managerBtn.hidden = !self.isShowBall;
    
    if (!self.isShowTitle) {
        self.allSubView.hidden=YES;
        if (changWebViewHeight) {
            CGRect frame=_zbtWebView.frame;
            
            frame.origin.y=frame.origin.y-32;
            
            frame.size.height=frame.size.height+32;
            
            _zbtWebView.frame=frame;
            changWebViewHeight=NO;
        }
        
    }
}



-(void)initGestureRecognizer{
    UISwipeGestureRecognizer *upGR=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGrUp)];
    [upGR setDirection:UISwipeGestureRecognizerDirectionUp];
    upGR.delegate= self;
    
    [ self.view addGestureRecognizer:upGR];
    UISwipeGestureRecognizer *downGR=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGrDown)];
    downGR.delegate=self;

    [downGR setDirection:UISwipeGestureRecognizerDirectionDown];
    [ self.view addGestureRecognizer:downGR];
}

-(void)handleGrUp{
    if (!self.isShowTitle) {
        return;
    }
    
    
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight=[[UIScreen mainScreen] bounds].size.height;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _allSubView.frame=CGRectMake(0, 0, width,0);
        
        
        if (self.navigationController) {
             _zbtWebView.frame=CGRectMake(0,20, width, screenHeight-67);
        }else{
            _zbtWebView.frame=CGRectMake(0,20, width, screenHeight-20);
        }
    }];
}

-(void)handleGrDown{
    
    if (!self.isShowTitle) {
        return;
    }
    
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat height=32;
    CGFloat screenHeight=[[UIScreen mainScreen] bounds].size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        _allSubView.frame=CGRectMake(0, 20, width,height);
        
        if (self.navigationController) {
              _zbtWebView.frame=CGRectMake(0,height+20, width, screenHeight-height-67);
        }else{
               _zbtWebView.frame=CGRectMake(0,height+20, width, screenHeight-height-20);
        }
     
        
    }];
}


-(void)webViewDidFinishLoad:(UIWebView *)webview{
    
    NSString *js = @"javascript: var allLinks = document.getElementsByTagName('a');if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target');if (target && target == '_blank'){link.setAttribute('target','_self');link.setAttribute('href','newtab:'+link.href);}}}";
    //js=@"javascript:oc.success({\"accuracy\":1,\"latitude\":10.5,\"longitude\":20.5,\"speed\":0.0})";
    
    NSString *str = [webview stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"111 str:%@",str);
    
    //隐藏back按钮
    NSString *title = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [_titleBtn setTitle:title forState:UIControlStateNormal];
    
    
    if(webview.canGoBack){
        
        if(_backBtn.hidden){
            [UIView animateWithDuration:0.5 animations:^{
                 _closeBtn.frame=CGRectMake(32, 0, 32,32);
            }];
            
        }
        [_backBtn setHidden:NO];
    }else{
        [_backBtn setHidden:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
             _closeBtn.frame=CGRectMake(0, 0, 32,32);
        }];
    }
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


-(void)goBack{
    if(_zbtWebView.canGoBack){
            [_zbtWebView goBack];
    }else{
        [_backBtn setHidden:YES];
    }
}


-(void)clickClose{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)initSubView{
    
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight=[[UIScreen mainScreen] bounds].size.height;
    CGFloat height=32;
    
    _allSubView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,20, width, height)];

    
    if (self.navigationController) {
          _headView =[[UIView alloc] initWithFrame:CGRectMake(0,-20, width, height)];
    }else{
          _headView =[[UIView alloc] initWithFrame:CGRectMake(0,0, width, height)];
    }
    
  
    
    _backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32,height)];

    
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_back_ico.png"] forState:UIControlStateNormal];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_back_ico_.png"] forState:UIControlStateHighlighted];
    [_backBtn setHidden:YES];
    [_headView addSubview:_backBtn];
    
    _closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32,height)];
    
    
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_close_ico.png"] forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_close_ico_.png"] forState:UIControlStateHighlighted];
    
    if (self.navigationController) {
        [_closeBtn setHidden:YES];
    }
    
//    [_closeBtn setTitleColor:kHexRGBAlpha(0x74777a,1) forState:UIControlStateNormal];
//    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    
    
    [_closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    _closeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_headView addSubview:_closeBtn];
    
    _titleBtn=[[UIButton alloc]  initWithFrame:CGRectMake(CGRectGetMaxX(_closeBtn.frame),0, width-64-64, height)];
    _titleBtn.center=CGPointMake(width/2,height/2);

    
//    [_titleBtn addTarget:self action:@selector(toInputModel) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_headView addSubview:_titleBtn];

    _refreshBtn=[[UIButton alloc] initWithFrame:CGRectMake(width-64, 0, 32,height)];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_refresh_ico.png"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(reloadButtonPush) forControlEvents:UIControlEventTouchUpInside];
    [_refreshBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_refresh_ico_.png"] forState:UIControlStateHighlighted];
    [_headView addSubview:_refreshBtn];
    
    _moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(width-32, 0, 32,height)];
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_more_ico.png"] forState:UIControlStateNormal];
    
    [_moreBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"hyper_link_title_more_ico_.png"] forState:UIControlStateHighlighted];
    [_headView addSubview:_moreBtn];
    
    [_allSubView addSubview:_headView];
    
    
    
    _inputView =[[UIView alloc] initWithFrame:CGRectMake(8,0, width-64, height)];
    _inputView.backgroundColor= [UIColor colorWithRed:224 green:224 blue:224 alpha:0];
    [_inputView.layer setMasksToBounds:YES];
    [_inputView.layer setCornerRadius:5.0];
    
    _urlField=[[UITextField alloc] initWithFrame:CGRectMake(8,3,width-64-32-8,26)];
    _urlField.placeholder=@"输入网址";
//    _urlField.textColor=[UIColor colorWithRed:135 green:135 blue:135 alpha:1];
    
    _urlField.textColor=[UIColor  redColor];
    [_inputView addSubview:_urlField];
    
    
    _clearBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_urlField.frame), 0, 32,height)];
    [_clearBtn setBackgroundImage:[UIImage imageNamed:@"停止.png"] forState:UIControlStateNormal];
    [_clearBtn setBackgroundImage:[UIImage imageNamed:@"停止-点击.png"] forState:UIControlStateHighlighted];
    [_clearBtn addTarget:self action:@selector(clearInputField) forControlEvents:UIControlEventTouchUpInside];
    [_inputView addSubview:_clearBtn];
     [_inputView setHidden:YES];
    
    [_allSubView addSubview:_inputView];
    
    _cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_inputView.frame), 0, 64,height)];
    [_cancelBtn setTitle:GDLocalizedString(@"取消") forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(toNormalModel) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.titleLabel.textAlignment=UITextAlignmentCenter;
    
    [_cancelBtn setHidden:YES];
    [_allSubView addSubview:_cancelBtn];
    
    [self.view addSubview:_allSubView];
    
    if (self.navigationController) {
        _zbtWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0,height+20, width, screenHeight-height-67)];
    }else{
        _zbtWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0,height+20, width, screenHeight-height-20)];
    }
    
    
    _zbtWebView.userInteractionEnabled=YES;
    _zbtWebView.delegate=self;
    _zbtWebView.scalesPageToFit=YES;
   
    
    [self.view addSubview:_zbtWebView];
    
    
    
    UIButton *managerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height-110, 44, 44)];
    [managerBtn setImage:[UIImage imageNamed:@"tab_cs_更多操作.png"] forState:UIControlStateNormal];
    [managerBtn addTarget:self action:@selector(clickedZbtManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:managerBtn];
    self.managerBtn = managerBtn;
    
}





-(void)clickedZbtManagerBtn:(UIButton *)btn{
    
    
    
    NSArray *arr = @[@{@"title":GDLocalizedString(@"分享"),@"image":@"分享"},
                     @{@"title":GDLocalizedString(@"截图分享"),@"image":@"截图"},
                     @{@"title":GDLocalizedString(@"后退"),@"image":@"tab_cs_后退"},
                     @{@"title":GDLocalizedString(@"刷新"),@"image":@"tab_cs_刷新"},
                     @{@"title":GDLocalizedString(@"复制网址"),@"image":@"tab_cs_复制链接"},
                     @{@"title":GDLocalizedString(@"浏览器打开"),@"image":@"tab_cs_浏览器打开"}];
    
    TabPostManagerView *maView = [[TabPostManagerView alloc] initWithButtonTitles:arr delegate:self];
    CGRect frame = maView.viewFrame;
    frame.origin.x = self.managerBtn.frame.origin.x;
    frame.origin.y = self.managerBtn.frame.origin.y - frame.size.height - 10;
    maView.viewFrame = frame;
    [maView show];
    
}




#pragma 回到常规模式
-(void)toNormalModel{
    [UIView animateWithDuration:1 animations:^{
        [_headView setHidden:NO];
        [_inputView setHidden:YES];
        [_cancelBtn setHidden:YES];
    }];
}


#pragma  去到输入模式
-(void)toInputModel{
    
    [UIView animateWithDuration:1 animations:^{
        [_headView setHidden:YES];
        [_inputView setHidden:NO];
        [_cancelBtn setHidden:NO];
    }];
    
    _urlField.text=[_zbtWebView.request.URL absoluteString];
   
}

- (void)reloadButtonPush {
    [_zbtWebView reload];
}



-(void)clearInputField{
    _urlField.text=@"";
}



-(void)clickMore{
    NSArray *arr = @[@{@"title":GDLocalizedString(@"分享"),@"image":@"分享"},
                     @{@"title":@"复制链接",@"image":@"复制链接"},
                     @{@"title":GDLocalizedString(@"浏览器打开"),@"image":@"在浏览器打开"},
                     @{@"title":GDLocalizedString(@"截图分享"),@"image":@"截图"}];
    
    ZBTPostManagerView *managerView = [[ZBTPostManagerView alloc] initWithButtonTitles:arr imageWidth:(CGFloat)35  delegate:self];
    managerView.delegate=self;
    [managerView show];
    
}



- (void)zbtPostManagerView:(PostManagerView *)view selectedButtonTitle:(NSString *)title {
    
    if ([title isEqualToString:GDLocalizedString(@"分享")]) {
        
        NSString *tempStr=[ZBTSuperCSWebVC stringRemoveToken:[_zbtWebView.request.URL absoluteString]];
        
        [ZBTUIWebViewController shareWithUrl:tempStr title:_titleBtn.titleLabel.text content:tempStr  imageData:nil view:_zbtWebView];
    }else if ([title isEqualToString:GDLocalizedString(@"浏览器打开")]) {
        
        
        NSString *tempStr=[ZBTSuperCSWebVC stringRemoveToken:[_zbtWebView.request.URL absoluteString]];
        
        NSURL *tempUrl=[NSURL URLWithString:tempStr];
        
        [[UIApplication sharedApplication] openURL:tempUrl];
        
    }else if ([title isEqualToString:GDLocalizedString(@"截图分享")]) {
        
        UIImage *image=[ZBTUIWebViewController imageWithscreenShot];
        
        NSData *data;
        if(UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
          [ZBTUIWebViewController shareWithUrl:nil title:nil content:nil imageData:data view:_zbtWebView type:SSPublishContentMediaTypeImage];
    }else if ([title isEqualToString:GDLocalizedString(@"复制链接")]) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [ZBTSuperCSWebVC stringRemoveToken:[_zbtWebView.request.URL absoluteString]];
        [HudUtil showTextDialog:GDLocalizedString(@"复制网址成功!") view:_zbtWebView showSecond:1];
    }
}


- (void)tabPostManagerView:(TabPostManagerView *)view selectedButtonTitle:(NSString *)title{
    if ([title isEqualToString:GDLocalizedString(@"分享")]) {
        
          NSString *tempStr=[ZBTSuperCSWebVC stringRemoveToken:[_zbtWebView.request.URL absoluteString]];
        
        [ZBTUIWebViewController shareWithUrl:tempStr title:_titleBtn.titleLabel.text content:tempStr imageData:nil view:_zbtWebView];
    }else if ([title isEqualToString:GDLocalizedString(@"截图分享")]) {
        
        UIImage *image=[ZBTUIWebViewController imageWithscreenShot];
        
        NSData *data;
        if(UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
         [ZBTUIWebViewController shareWithUrl:nil title:nil content:nil imageData:data view:_zbtWebView type:SSPublishContentMediaTypeImage];
    }else if ([title isEqualToString:GDLocalizedString(@"后退")]) {
        [_zbtWebView goBack];
    }else if ([title isEqualToString:GDLocalizedString(@"刷新")]) {
        [_zbtWebView reload];
    }else if ([title isEqualToString:GDLocalizedString(@"浏览器打开")]) {
        
       NSString *tempStr=[ZBTSuperCSWebVC stringRemoveToken:[_zbtWebView.request.URL absoluteString]];
        
       NSURL *tempUrl=[NSURL URLWithString:tempStr];
        
        [[UIApplication sharedApplication] openURL:tempUrl];
        
    }else if ([title isEqualToString:GDLocalizedString(@"复制网址")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [ZBTSuperCSWebVC stringRemoveToken:[_zbtWebView.request.URL absoluteString]];
        [HudUtil showTextDialog:GDLocalizedString(@"复制网址成功!") view:_zbtWebView showSecond:1];
    }
}


- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_zbtWebView loadRequest:request];
}



+(void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content imageData:(NSData*)imageData view:(UIView *)uiView type:(SSPublishContentMediaType)type{
    
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPadContainerWithView:uiView arrowDirect:UIPopoverArrowDirectionUp];
    SSPublishContentMediaType mediaType = type;
    
    
    //    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[imgId integerValue]]]];
    //
    id<ISSCAttachment> imageAttach=nil;
    if (imageData) {
        imageAttach=[ShareSDK imageWithData:imageData fileName:@"share.jpg" mimeType:@"jpg"];
    }
    
    NSString *redesc=[NSString stringWithFormat:@"描述//%@",content];
    
    id<ISSContent> publishContent = [ShareSDK content:redesc
                                       defaultContent:@""
                                                image:imageAttach
                                                title:title
                                                  url:url
                                          description:nil
                                            mediaType:mediaType];
    
    
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
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [Praise hudShowTextOnly:GDLocalizedString(@"分享成功") delegate:self];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"分享失败"),[error errorDescription]] delegate:self];
                                }
                            }];
}



+(void)shareWithUrl:(NSString *)url title:(NSString *)title content:(NSString *)content imageData:(NSData*)imageData view:(UIView *)uiView{
    [self shareWithUrl:url title:title content:content imageData:imageData view:uiView type:SSPublishContentMediaTypeNews];
}




/**
 *截图功能
 */
+(UIImage *)imageWithscreenShot{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(DeviceWidth, DeviceHeight), YES, 0);
    
    //设置截屏大小
    
    //[[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, DeviceWidth*scale_screen, DeviceHeight*scale_screen);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    //以下为图片保存代码
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= @"screenShow.png";
    NSString *savedImagePathTemp = [documentsDirectory stringByAppendingPathComponent:pictureName];
    [imageViewData writeToFile:savedImagePathTemp atomically:YES];//保存照片到沙盒目录
    
    CGImageRelease(imageRefRect);
    
    saveImagePath = savedImagePathTemp;
    
    //    //从手机本地加载图片
    //
    //    UIImage *bgImage2 = [[UIImage alloc]initWithContentsOfFile:savedImagePath];
    return sendImage;
    
}




#pragma mark UIWebView -delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [self.progressView endProgress];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL] ;
    NSString *urlStr = [url relativeString];
    
    //超链规则限制
    if ([ZBHtmlToApp isSupCSRuleWithUrlStr:urlStr vc:self webView:webView]) {
        return NO;
    }
    //开始加载进度
//    [self.progressView startProgress];
    
    return YES;
    
}




@end
