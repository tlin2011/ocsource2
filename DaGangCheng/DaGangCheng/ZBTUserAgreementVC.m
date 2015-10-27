//
//  ZBTUserAgreementVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-9-18.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTUserAgreementVC.h"

@interface ZBTUserAgreementVC ()
//@property (nonatomic, strong) UITextView *tv;
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ZBTUserAgreementVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view.

    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
    self.title = [NSString stringWithFormat:@"%@%@",appName,GDLocalizedString(@"用户协议")];

    CGRect frame = self.view.frame;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
    }else {
        frame.origin.y = 64;
        frame.size.height = frame.size.height - 64;
    }
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    NSString* urlStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"userPrivacy_url"];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.contentMode = UIViewContentModeTop|UIViewContentModeScaleToFill;
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
