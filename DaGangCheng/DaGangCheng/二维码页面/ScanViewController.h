//
//  ScanViewController.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/7/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScanViewController;

@protocol ScanViewControllerDelegate <NSObject>

@required
- (void)scanViewController:(ScanViewController *)vc DidFinishedWithString:(NSString *)string;

@end

@interface ScanViewController : UIViewController

@property (weak, nonatomic) id<ScanViewControllerDelegate>delegate;


@property (strong, nonatomic) NSString *handleCode;

/**
 *  扫描到二维码后的处理
 */
+ (void)resultDispalyByString:(NSString *)string viewController:(UIViewController *)vc;
@end

