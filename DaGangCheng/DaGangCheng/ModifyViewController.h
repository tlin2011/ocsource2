//
//  ModifyViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-3-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"

@interface ModifyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *modifyName;
@property (strong, nonatomic) IBOutlet UITextField *modifyPhone;


@property (strong, nonatomic) IBOutlet UITextField *modifyOldPassword;
@property (strong, nonatomic) IBOutlet UITextField *modifyNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *modifyAgainPassword;

- (IBAction)modifyInformationAction:(UIButton *)sender;

- (IBAction)modifyPasswordAction:(UIButton *)sender;

- (IBAction)modifyCancelAction:(UIButton *)sender;

@property CGRect oldRect;

@end
