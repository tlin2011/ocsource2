//
//  ScanViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/7/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "ScanViewController.h"
#import "ZBarSDK.h"
#import "BoxView.h"
//#import "ZBHtmlToApp.h"
#import "ZBPostJumpTool.h"

@interface ScanViewController ()<ZBarReaderViewDelegate>{
     ZBarReaderView *_readerView;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZBarReaderView * view = [[ZBarReaderView alloc] init];
    view.frame = self.view.bounds;
    view.readerDelegate = self;
    view.torchMode = 0;
    
    
    UIButton *backButton=[[UIButton alloc] init];
    backButton.frame=CGRectMake(0, 30, 44, 30);
    [backButton setImage:[UIImage imageNamed:@"返回箭头.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
    
    BoxView *boxView = [[BoxView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    CGFloat x=((SCREEN_HEIGHT-SCAN_WH)/2)/SCREEN_HEIGHT;
    CGFloat y=1-(((SCREEN_WIDTH-SCAN_WH)/2)+SCAN_WH)/SCREEN_WIDTH;
    
    CGFloat w=SCAN_WH/SCREEN_HEIGHT;
    CGFloat h=SCAN_WH/SCREEN_WIDTH;
    
    view.scanCrop=CGRectMake (x,y,w,h);
    [self.view addSubview:view];
    [self.view addSubview:boxView];
    
    [self.view addSubview:backButton];
    _readerView=view;
    [view start];
}


-(void)goCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
        if ([self.delegate respondsToSelector:@selector(scanViewController:DidFinishedWithString:)]) {
            [self.delegate scanViewController:self DidFinishedWithString:symbolStr];
        }
        
    } else {
    
        [self dismissViewControllerAnimated:NO completion:^{
            if ([self.delegate respondsToSelector:@selector(scanViewController:DidFinishedWithString:)]) {
                [self.delegate scanViewController:self DidFinishedWithString:symbolStr];
            }
        }];
    }

}

#pragma mark 判断是否是以Http开头
+ (BOOL)isHttpPrefixUrlStr:(NSString *)string{
    if ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"] ) {
        return YES;
    }
    return NO;
}

+ (void)resultDispalyByString:(NSString *)string viewController:(UIViewController *)vc {

    if([ScanViewController isHttpPrefixUrlStr:string]){
        
        [ZBPostJumpTool intoAdPageWithUrlStr:string vc:vc];
    }else{
    
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@""message:string delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:nil];
        [alertView show];
        //震动提示
    }
    
}

#pragma mark 退出屏幕 停止扫描
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_readerView stop];
}

@end
