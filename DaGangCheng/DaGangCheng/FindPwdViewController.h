//
//  FindPwdViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "MsgSendRootViewController.h"

@interface FindPwdViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *pwdText;

@property (strong, nonatomic) IBOutlet UIButton *msgFindPwd;

@property (strong, nonatomic) IBOutlet UIButton *simFindPwdBtn;

@end
