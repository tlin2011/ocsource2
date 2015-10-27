//
//  RegisterViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-3-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifyCenter.h"
#import "CommHead.h"

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *againPassword;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

- (IBAction)registerAction:(UIButton *)sender;
@end
