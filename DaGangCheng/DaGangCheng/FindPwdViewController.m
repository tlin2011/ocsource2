//
//  FindPwdViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "FindPwdViewController.h"

@interface FindPwdViewController ()
{
    NSString* phone;
    NSString *pwd;
}
@end

@implementation FindPwdViewController

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
    
    self.phoneText.placeholder = GDLocalizedString(@"手机号码");
    self.pwdText.placeholder = GDLocalizedString(@"新密码(6位以上)");
    
    [self.msgFindPwd setTitle:GDLocalizedString(@"私信改密") forState:UIControlStateNormal];
    [self.simFindPwdBtn setTitle:GDLocalizedString(@"SIM卡改密") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)smsFindPwd:(id)sender
{
    if(![self checkInput]) return;
    [self intoSendView];
}

-(void)intoSendView
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //2.进攻,下一球
    MsgSendRootViewController * next =[board instantiateViewControllerWithIdentifier:@"MsgSendRootViewController"];
    
    //3.假动作,急停,跳投
    next.uid = @"10002";
    next.name= GDLocalizedString(@"系统管理员");
    NSString* msg=[NSString stringWithFormat:@"%@:%@,%@:%@",GDLocalizedString(@"管理员您好,我的密码丢失,请帮忙改密码,新密码"),pwd,GDLocalizedString(@"我的手机号码"),phone];
    next.msg = msg;
    
    [self.navigationController  presentViewController:next animated:YES completion:nil];
}

- (IBAction)simFindPwd:(id)sender
{
    [HuaxoUtil showMsg:GDLocalizedString(@"请等待官方更新通知,或者使用私信方式改密") title:GDLocalizedString(@"此功能尚未开放")];
    return;
    if(![self checkInput]) return;
}

-(BOOL)checkInput
{
    phone = self.phoneText.text;
    pwd   = self.pwdText.text;
    if(pwd.length<6)
    {
        [HuaxoUtil showMsg:GDLocalizedString(@"密码长度不能少于6位") title:GDLocalizedString(@"密码输入错误")];
        return NO;
    }
    if(phone.length<11)
    {
        [HuaxoUtil showMsg:GDLocalizedString(@"请输入正确的手机号码") title:GDLocalizedString(@"手机号码输入不正确")];
        return NO;
    }
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
