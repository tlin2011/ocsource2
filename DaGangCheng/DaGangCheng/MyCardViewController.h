//
//  MyCardViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-15.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommHead.h"

@interface MyCardViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) IBOutlet UITextField *nameLabel;

@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *qqText;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *homeAddrText;
@property (weak, nonatomic) IBOutlet UITextView *introduceTV;

@property (strong, nonatomic) UILabel *introduceLabel;
@property NSDictionary* myCardInfo ;


@end
