//
//  ModifyViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-3-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ModifyViewController.h"

#import "AFNetworking.h"
#import "SQLDataBase.h"
#import "MyMD5.h"

#import "NetRequest.h"
#import "ApiUrl.h"


@interface ModifyViewController ()

@end

@implementation ModifyViewController
@synthesize  oldRect;

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
    //查询数据库
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    //对当前页面设置
    self.modifyName.text = [sql queryWithCondition:@"user_name"];
    self.modifyPhone.text = [sql queryWithCondition:@"phone"];
    
    oldRect = self.modifyNewPassword.superview.frame;
    //self.tabBarController.tabBar.hidden = YES;
}

//取消第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.modifyAgainPassword resignFirstResponder];
    [self.modifyName resignFirstResponder];
    [self.modifyNewPassword resignFirstResponder];
    [self.modifyOldPassword resignFirstResponder];
    [self.modifyOldPassword resignFirstResponder];
}
-(void)dismissKeyBoard:(id)sender
{
    for(UIView* view in [self.modifyNewPassword.superview subviews])
    {
        [view resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pwdEditBegin:(id)sender {
    //UIView* text = sender;
    UIView* view = self.modifyNewPassword.superview;
    
    NSLog(@"into textFieldDidBeginEditing");
    float  offset = 150;//xx; //view向上移动的距离
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = oldRect.size.width;
    float height = oldRect.size.height;
    CGRect rect = CGRectMake(oldRect.origin.x, oldRect.origin.y-offset, width, height);
    view.frame = rect;
    [UIView  commitAnimations];

}
- (IBAction)pwdEditEnd:(id)sender {
    //UIView* text = sender;
    UIView* view = self.modifyNewPassword.superview;
    
    NSLog(@"into textFieldDidEndEditing");
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    view.frame = self.oldRect;//text.oldRect;
    [UIView  commitAnimations];
}



//修改个人资料
- (IBAction)modifyInformationAction:(UIButton *)sender {
    //查询数据
    NSDictionary * parameters =@{@"name":self.modifyName.text,@"phone":self.modifyPhone.text,};
    //创建url
    //ApiUrl *url =[[ApiUrl alloc] init];
    //响应
    NetRequest * request = [[NetRequest alloc]init];
    [request urlStr:[ApiUrl changeUserInfo] parameters:parameters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"%d",[[customDict objectForKey:@"ret"] integerValue]==1);
        if ([[customDict objectForKey:@"ret"] integerValue]) {
            SQLDataBase * sql =[[SQLDataBase alloc] init];
            NSLog(@"%@",[sql queryWithCondition:@"user_name"]);
            [sql change:self.modifyName.text andLaterStr:[sql queryWithCondition:@"user_name"]];
            [HuaxoUtil showMsg:@"" title:GDLocalizedString(@"修改成功")];
        }
        else{
            NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"修改用户资料失败")];
        }
    }];
}

//修改密码
- (IBAction)modifyPasswordAction:(UIButton *)sender {
    //两次密码是否相同
    if ([self.modifyNewPassword.text isEqualToString:self.modifyAgainPassword.text])
    {
        NSDictionary * parameters =@{
                                     @"phone_uid":[HuaxoUtil getUdidStr],
                                     @"pwd":[MyMD5 md5: self.modifyOldPassword.text ],
                                     @"new_pwd":[MyMD5 md5: self.modifyNewPassword.text]
                                     };
        NetRequest * request =[[NetRequest alloc] init];
        [request urlStr:[ApiUrl modifyPasswordUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
            NSLog(@"%@",customDict);
            if ([[customDict objectForKey:@"ret"] integerValue]) {
                [HuaxoUtil showMsg:@"" title:GDLocalizedString(@"密码修改成功")];
            }
            else{
                NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
                [HuaxoUtil showMsg:msg title:GDLocalizedString(@"密码修改失败")];
            }
        }];
    }
    else
    {
        [HuaxoUtil showMsg:GDLocalizedString(@"新密码两次输入不一致") title:GDLocalizedString(@"密码修改失败")];
    }
}
//取消按钮
- (IBAction)modifyCancelAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}
@end
