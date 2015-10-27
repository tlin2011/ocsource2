//
//  ZBSuperCSTabVC.m
//  DaGangCheng
//
//  Created by huaxo on 15-2-6.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBSuperCSTabVC.h"
#import "NotifyCenter.h"
#import "TabPostManagerView.h"
#import "ZBWebProgressView.h"
#import "PostManagerView.h"
#import "ZBHtmlToApp.h"

@interface ZBSuperCSTabVC ()<TabPostManagerViewDelegate, PostManagerViewDelegate>
@property (nonatomic, strong) UIButton *managerBtn;

@property (nonatomic, strong) NSString *oldUrlStr;

@property (nonatomic, strong) ZBWebProgressView  *progressView;
@property (nonatomic, strong) UIImageView *statusIv;      //填充状态栏
@end

@implementation ZBSuperCSTabVC

- (void)viewDidLoad
{
    
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
    
    CGRect frame = self.view.frame;
    
//    if (DeviceVersion >= 8.0) {
//        
//    }else {
//        frame.origin.y = 64;
//        frame.size.height = frame.size.height - 64;
//    }
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    
    self.webView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    [self loadData:self.urlStr];
    
    UIButton *managerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.view.frame.size.height-110, 44, 44)];
    //managerBtn.backgroundColor = [UIColor redColor];
    [managerBtn setImage:[UIImage imageNamed:@"tab_cs_更多操作.png"] forState:UIControlStateNormal];
    [managerBtn addTarget:self action:@selector(clickedManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:managerBtn];
    self.managerBtn = managerBtn;
    //
    ZBWebProgressView *progress = [[ZBWebProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progress.frame = CGRectMake(0, 20, self.view.bounds.size.width, 2);
    [self.view addSubview:progress];
    self.progressView = progress;
}

//
- (void)initSubviews {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab_cs_返回上页.png"] style:UIBarButtonItemStylePlain target:self action:@selector(webBack)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多操作_帖子_查看话题.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedManagerBtn)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:[NotifyCenter userLoginStatusKey] object:nil];
    
    self.statusIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.statusIv.backgroundColor = UIColorFromRGB(0xbdbdc2);
    
    self.statusIv.backgroundColor = [UIColor redColor];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:self.statusIv];
    //
    self.navigationController.navigationBarHidden = !self.isShowTitle;
    self.managerBtn.hidden = !self.isShowBall;
}

- (void)clickedManagerBtn {

    NSArray *arr2 = @[//@{@"title":@"后退",@"image":@"tab_cs_后退"},
                     @{@"title":GDLocalizedString(@"刷新"),@"image":@"tab_cs_刷新"},
                     //@{@"title":@"截图分享",@"image":@"tab_cs_剪切分享"},
                     @{@"title":GDLocalizedString(@"复制网址"),@"image":@"tab_cs_复制链接"},
                     @{@"title":GDLocalizedString(@"浏览器打开"),@"image":@"tab_cs_浏览器打开"}];
    
    PostManagerView *managerView = [[PostManagerView alloc] initWithButtonTitles:arr2 delegate:self];
    [managerView show];
}

- (void)postManagerView:(PostManagerView *)view selectedButtonTitle:(NSString *)title {
    
    
    if ([title isEqualToString:GDLocalizedString(@"后退")]) {
        //
        [self.webView goBack];
    } else if ([title isEqualToString:GDLocalizedString(@"刷新")]) {
        //
        [self.webView reload];
    } else if ([title isEqualToString:GDLocalizedString(@"截图分享")]) {
        //
    } else if ([title isEqualToString:GDLocalizedString(@"复制网址")]) {
        //
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [ZBTSuperCSWebVC stringRemoveToken:self.urlStr];
        [Praise hudShowTextOnly:GDLocalizedString(@"复制网址成功!") delegate:self];
    } else if ([title isEqualToString:GDLocalizedString(@"浏览器打开")]) {
        //
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    }
}

- (void)login {
    //刷新页面
    [self loadData:self.urlStr];
}

- (void)webBack {
    [self.webView goBack];
}


- (void)loadData:(NSString *)urlStr {
    
    NSString *cs = urlStr;
    cs = cs ? cs:@"";
    NSURL* url = [NSURL URLWithString:cs];
    self.oldUrlStr = [url relativeString];
    NSURLRequest* request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

#pragma mark UIWebView -delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.progressView endProgress];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL] ;
    NSString *urlStr = [url relativeString];
    
    //超链规则限制
    if ([ZBHtmlToApp isSupCSRuleWithUrlStr:urlStr vc:self webView:webView]) {
        return NO;
    }    
    //开始加载进度
    [self.progressView startProgress];
    
    return YES;
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = @"javascript: var allLinks = document.getElementsByTagName('a');if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target');if (target && target == '_blank'){link.setAttribute('target','_self');link.setAttribute('href','newtab:'+link.href);}}}";
    //js=@"javascript:oc.success({\"accuracy\":1,\"latitude\":10.5,\"longitude\":20.5,\"speed\":0.0})";
    
    NSString *str = [webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"111 str:%@",str);
    
    [self.progressView endProgress];
}




- (void)clickedManagerBtn:(UIButton *)sender {
    NSArray *arr = @[@{@"title":GDLocalizedString(@"后退"),@"image":@"tab_cs_后退"},
                     @{@"title":GDLocalizedString(@"刷新"),@"image":@"tab_cs_刷新"},
                    //@{@"title":@"截图分享",@"image":@"tab_cs_剪切分享"},
                    @{@"title":GDLocalizedString(@"复制网址"),@"image":@"tab_cs_复制链接"},
                    @{@"title":GDLocalizedString(@"浏览器打开"),@"image":@"tab_cs_浏览器打开"}];
    
    TabPostManagerView *maView = [[TabPostManagerView alloc] initWithButtonTitles:arr delegate:self];
    CGRect frame = maView.viewFrame;
    frame.origin.x = self.managerBtn.frame.origin.x;
    frame.origin.y = self.managerBtn.frame.origin.y - frame.size.height - 10;
    maView.viewFrame = frame;
    [maView show];
}

- (void)tabPostManagerView:(TabPostManagerView *)view selectedButtonTitle:(NSString *)title {
    if ([title isEqualToString:GDLocalizedString(@"后退")]) {
        //
        [self.webView goBack];
    } else if ([title isEqualToString:GDLocalizedString(@"刷新")]) {
        //
        [self.webView reload];
    } else if ([title isEqualToString:GDLocalizedString(@"截图分享")]) {
        //
    } else if ([title isEqualToString:GDLocalizedString(@"复制网址")]) {
        //
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [ZBTSuperCSWebVC stringRemoveToken:self.urlStr];
        [Praise hudShowTextOnly:GDLocalizedString(@"复制网址成功!") delegate:self];
    } else if ([title isEqualToString:GDLocalizedString(@"浏览器打开")]) {
        //
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<=0) {
        scrollView.alwaysBounceVertical = NO;
    } else {
        scrollView.alwaysBounceVertical = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
