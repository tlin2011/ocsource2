//
//  ZBSmsRegisterVC.h
//  DaGangCheng
//
//  Created by huaxo on 15-4-15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBSmsRegisterVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *smsPassword;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

- (IBAction)registerAction:(UIButton *)sender;
@end
