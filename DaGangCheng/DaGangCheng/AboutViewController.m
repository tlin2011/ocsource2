//
//  AboutViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize  webView;

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
    self.title = GDLocalizedString(@"关于应用");
    CGRect frame = self.view.frame;
    
    if (DeviceVersion >= 8.0) {
        
    }else {
        frame.origin.y = 64;
        frame.size.height = frame.size.height - 64;
    }
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    [self.view addSubview:self.webView];
    
    NSString* urlStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"down_url"];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLRequest* request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    webView.contentMode = UIViewContentModeTop|UIViewContentModeScaleToFill;
    webView.frame = self.view.frame;
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
- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
