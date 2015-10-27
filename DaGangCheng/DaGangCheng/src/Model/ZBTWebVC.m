//
//  ZBTWebVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTWebVC.h"

@interface ZBTWebVC ()<UIWebViewDelegate>

@end

@implementation ZBTWebVC

- (void)viewDidLoad
{
    
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view.
    

    
    
    CGRect frame = self.view.frame;
    
    if (DeviceVersion >= 8.0) {
        
    }else {
        frame.origin.y = 64;
        frame.size.height = frame.size.height - 64;
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString* urlStr = self.urlStr ? self.urlStr:@"";
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    self.webView.frame = self.view.frame;
    
    //
    ZBWebProgressView *progress = [[ZBWebProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    if (self.navigationController) {
        progress.frame = CGRectMake(0, 64, self.view.bounds.size.width, 2);
    } else {
        progress.frame = CGRectMake(0, 20, self.view.bounds.size.width, 2);
    }
    [self.view addSubview:progress];
    self.progressView = progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.progressView startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.title) {
        self.title = title;
    }
    
    [self.progressView endProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.progressView endProgress];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL] ;
    NSString *urlStr = [url relativeString];
    
    if ([ZBHtmlToApp isSupCSRuleWithUrlStr:urlStr vc:self webView:webView]) {
        return NO;
    }
    
    return YES;
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
