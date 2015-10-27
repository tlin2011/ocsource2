//
//  ZBRetrievePassword.m
//  DaGangCheng
//
//  Created by huaxo on 15-4-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBRetrievePassword.h"
#import "ApiUrl.h"
#import "SQLDataBase.h"
#import "NetRequest.h"
#import "ZBTUserAgreementVC.h"
#import "NotifyCenter.h"
#import "HuaxoUtil.h"
#import "MyMD5.h"

#import "MobClick.h"


#import "zbmsg.h"

#import "GTMBase64.h"

@interface ZBRetrievePassword ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@property (strong, nonatomic) NSTimer *authTimer;

@end

@implementation ZBRetrievePassword

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
    [super viewDidLoad];
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self  action:@];
    // Do any additional setup after loading the view.
    
    self.title = GDLocalizedString(@"找回密码");
    
    [self.sendBtn setBackgroundColor:UIColorWithMobanTheme];
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    self.sendBtn.layer.cornerRadius = 2;
    self.sendBtn.layer.masksToBounds = YES;
    
    self.phoneNumber.delegate = self;
    self.password.delegate = self;
    self.smsPassword.delegate = self;
    
    self.authCodeBtn.layer.cornerRadius = 2.0;
    self.authCodeBtn.layer.masksToBounds = YES;
    self.authCodeBtn.backgroundColor = UIColorWithMobanTheme;
    [self.authCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.authCodeBtn addTarget:self action:@selector(clickedAuthCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    self.phoneNumber.placeholder = GDLocalizedString(@"手机号码");
    self.password.placeholder = GDLocalizedString(@"密码(6位以上)");
    self.smsPassword.placeholder = GDLocalizedString(@"验证码");
    [self.sendBtn setTitle:GDLocalizedString(@"确定") forState:UIControlStateNormal];
    
    [self.authCodeBtn setTitle:GDLocalizedString(@"发送") forState:UIControlStateNormal];
}

//找回密码
- (IBAction)sendAction:(UIButton *)sender {
    //收起键盘
    [self.password resignFirstResponder];
    [self.smsPassword resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    
    //检查输入
    if (![self isOkInput]) {
        return;
    }
    
    [sender setTitle:GDLocalizedString(@"发送中...") forState:UIControlStateNormal];
    //参数
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    //NSString *passwordMd5 = [MyMD5 md5: self.password.text];
    NSDictionary *parameters = @{@"phone": self.phoneNumber.text,
                                 @"app_kind":appKind,
                                 @"new_pwd":self.password.text,
                                 @"is_self":@"yes",
                                 @"sms_code":self.smsPassword.text
                                 };
    
    //执行
    //ApiUrl * urlStr =[[ApiUrl alloc] init];
    __block UIButton *bSender = sender;
    NetRequest * request =[[NetRequest alloc]init];
    [request urlStr:[ApiUrl smsRetrievePassword] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if([customDict[@"ret"] intValue])
        {
            //友盟统计
            [MobClick event:@"register"];
            
            [bSender setTitle:GDLocalizedString(@"找回密码成功") forState:UIControlStateNormal];
            //关闭定时器
            [self.authTimer invalidate];
        } else if(customDict[@"ret"]){
            
            [HuaxoUtil showMsg:customDict[@"msg"] title:GDLocalizedString(@"失败")];
            [bSender setTitle:GDLocalizedString(@"确定") forState:UIControlStateNormal];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneNumber resignFirstResponder];
    [self.password resignFirstResponder];
    [self.smsPassword resignFirstResponder];
}

//检查输入
- (BOOL)isOkInput {
    NSString *msg = nil;
    if (self.phoneNumber.text.length < 11) {
        msg = GDLocalizedString(@"请输入手机号！");
    } else if (self.smsPassword.text.length < 6) {
        NSLog(@"count %d",self.smsPassword.text.length);
        msg = GDLocalizedString(@"请输入验证码！");
    } else if (self.password.text.length<6) {
        msg = GDLocalizedString(@"请输入密码！");
    }
    
    if (msg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [av show];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickDisplayPwdBtn:(UIButton *)sender {
    if (sender.tag == 0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"noSecure_ico.png"] forState:UIControlStateNormal];
        self.password.secureTextEntry = NO;
        sender.tag = 1;
    } else if (sender.tag == 1) {
        [sender setBackgroundImage:[UIImage imageNamed:@"secure_ico.png"] forState:UIControlStateNormal];
        self.password.secureTextEntry = YES;
        sender.tag = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //友盟统计
    [MobClick beginLogPageView:GDLocalizedString(@"注册页面出现")];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //友盟统计
    [MobClick endLogPageView:GDLocalizedString(@"注册页面关闭")];
    
    //关闭定时器
    [self.authTimer invalidate];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.smsPassword]) {
        [textField resignFirstResponder];
        
    } else if ([textField isEqual:self.password]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)clickedAuthCodeBtn:(UIButton *)sender {
    
    if (self.phoneNumber.text.length<11) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"请输入手机号！") delegate:nil cancelButtonTitle:nil otherButtonTitles: GDLocalizedString(@"确定"), nil];
        [av show];
        return;
    }
    
    //手机验证码下发前检测是否已注册
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary *parameters = @{@"phone":self.phoneNumber.text, @"app_kind":app_kind};
    //执行
    NetRequest * loginRequest = [[NetRequest alloc]init];
    [loginRequest  urlStr:[ApiUrl isRegisted] parameters:parameters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"%@",customDict);
        //成功
        
        if ([customDict objectForKey:@"ret"] && [[customDict objectForKey:@"ret"] intValue] ==1) {
            [self sendAuthCode];
            
        } else {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:customDict[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), nil];
            [av show];
            
        }
        
        
    }];
}

- (void)sendAuthCode {
    
    if (self.phoneNumber.text.length<11) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"请输入手机号！") delegate:nil cancelButtonTitle:nil otherButtonTitles: GDLocalizedString(@"确定"), nil];
        [av show];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@：+86 %@",GDLocalizedString(@"我们将发送 验证码 短信到这个号码") ,self.phoneNumber.text];
    
    UIAlertView *av2 = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), GDLocalizedString(@"取消"), nil];
    [av2 show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex %ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        [self requestAuthCode];
    }
}

- (void)requestAuthCode {
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
//    NSDictionary *parameters = @{@"phone":self.phoneNumber.text,
//                                 @"app_kind":app_kind,
//                                 @"type":@"code",
//                                 //@"s_secret_key":@"GZ58fLkDfBmPJs1OKQ@1805"
//                                 };
    
    NSString *phone=self.phoneNumber.text;
    
    NSString *result=[NSString stringWithFormat:@"{\"app_kind\":\"%@\",\"phone\":\"%@\"}",app_kind,phone];
    
    NSData *dataTemp=[[zbmsg alloc] encryptUseDES:result];
    
    result = [GTMBase64 stringByEncodingData:dataTemp];

    NSLog(@"%@",result);
    
    
    NSDictionary *parameters =@{@"key":result};
//    {"app_kind":"ibuger_opencom","phone":"15702095873"}
    
    
    
//      AFHTTPRequestOperationManager * afnManager =[AFHTTPRequestOperationManager manager];
//
//    [afnManager POST:<#(NSString *)#> parameters:<#(id)#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>]
//    
    
    //执行
    NetRequest * loginRequest = [[NetRequest alloc]init];
    [loginRequest  urlStr:[ApiUrl sendClientSms2] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if ([[customDict objectForKey:@"ret"] intValue] ==1) {
            [self.authCodeBtn setTitle:@"60" forState:UIControlStateNormal];
            self.authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAuthCodeBtnTitle:) userInfo:nil repeats:YES];
        } else {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"发送失败") message:customDict[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), nil];
            [av show];
        }
    }];
}

- (void)changeAuthCodeBtnTitle:(NSTimer *)sender {
    NSInteger num = [self.authCodeBtn.currentTitle integerValue];
    num -= 1;
    if (num == -1) {
        [self.authCodeBtn setTitle:GDLocalizedString(@"发送") forState:UIControlStateNormal];
        [sender invalidate];
    } else {
        [self.authCodeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }
}


- (void)back:(id)sender {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
