//
//  LoginViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-2-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyCenter.h"
#import "FindPwdViewController.h"
#import "ZBRetrievePassword.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIButton *findPwdBtn;

- (IBAction)loginAction:(UIButton *)sender;

- (IBAction)forgetAction:(UIButton *)sender;

+ (void)tologinWithVC:(UIViewController *)vc;
+ (void)tologinWithVC:(UIViewController *)vc animated:(BOOL)flag;
@end
