//
//  ZBRetrievePassword.h
//  DaGangCheng
//
//  Created by huaxo on 15-4-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBRetrievePassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *smsPassword;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)sendAction:(UIButton *)sender;
@end
