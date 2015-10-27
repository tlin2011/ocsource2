//
//  RegisterViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-3-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "RegisterViewController.h"
#import "ApiUrl.h"
#import "SQLDataBase.h"
#import "NetRequest.h"
#import "ZBTUserAgreementVC.h"

#import "MobClick.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *displayPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementLab;

@end

@implementation RegisterViewController

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
    
    self.title = GDLocalizedString(@"注册");
    
    //用户协议
    NSString *userPrivacy_url = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"userPrivacy_url"];
    if (userPrivacy_url && [userPrivacy_url hasPrefix:@"http"]) {
        
        self.agreementBtn.hidden = NO;
        self.agreementBtn.hidden = NO;
        [self.agreementBtn setTitleColor:UIColorWithMobanTheme forState:UIControlStateNormal];
        self.agreementBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
        [self.agreementBtn setTitle:[NSString stringWithFormat:@"《%@%@》",appName,GDLocalizedString(@"用户协议")] forState:UIControlStateNormal];
        
        self.agreementLab.text = GDLocalizedString(@"我已阅读并同意");
    } else {
        
        self.agreementBtn.hidden = YES;
        self.agreementLab.hidden = YES;
    }
    
    [self.registBtn setBackgroundColor:UIColorWithMobanTheme];

    [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    self.registBtn.layer.cornerRadius = 2;
    self.registBtn.layer.masksToBounds = YES;
    [self.registBtn setTitle:GDLocalizedString(@"注册账号") forState:UIControlStateNormal];
    
    //
    self.phoneNumber.placeholder = GDLocalizedString(@"手机号码");
    self.name.placeholder = GDLocalizedString(@"昵称");
    self.password.placeholder = GDLocalizedString(@"密码(6位以上)");
    self.againPassword.placeholder = GDLocalizedString(@"确认密码");
    //
    
    self.phoneNumber.delegate = self;
    self.password.delegate = self;
    self.name.delegate = self;
    self.againPassword.delegate = self;
}

//注册
- (IBAction)registerAction:(UIButton *)sender {
    //收起键盘
    [self.password resignFirstResponder];
    [self.name resignFirstResponder];
    [self.againPassword resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    
    [sender setTitle:GDLocalizedString(@"注册账号中...") forState:UIControlStateNormal];
    //参数
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSString *appVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"];
    UIDevice *device=[UIDevice currentDevice];
    NSString *imei = device.identifierForVendor.UUIDString;
    NSDictionary *parameters = @{@"phone": self.phoneNumber.text,
                                 @"name":self.name.text,
                                 @"pwd":self.password.text,
                                 //@"gps_lng":@"",
                                 //@"gps_lat":@"",
                                 //@"addr":@"",
                                 @"imei":imei,
                                 //@"imsi":@"",
                                 //@"serial_num":@"",
                                 //@"mac":@"",
                                 @"app_kind":appKind,
                                 @"ibg_ver":appVer,
                                 //@"m":@"apple",
                                 //@"model":@"",
                                 //@"sdk_ver":@"7",
                                 //@"module":@""
                                 };
    
    //执行
    //ApiUrl * urlStr =[[ApiUrl alloc] init];
    __block UIButton *bSender = sender;
    NetRequest * request =[[NetRequest alloc]init];
    [request urlStr:[ApiUrl registerUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if([customDict[@"ret"] intValue])
        {
            [NotifyCenter sendLoginStatus:customDict];
            
            //友盟统计
            [MobClick event:@"register"];
            
            [self login];
            [bSender setTitle:GDLocalizedString(@"注册账号成功") forState:UIControlStateNormal];
        }else{
            NSLog(@"%@",customDict);
            NSString* msg = [NSString stringWithFormat:@"%@",customDict[@"msg"]];
            if ([msg isKindOfClass:[NSNull class]] || [msg isEqualToString:@"(null)"]) {
                msg = GDLocalizedString(@"请检查网络连接");
            }
            msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),msg];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"注册失败")];
            [bSender setTitle:GDLocalizedString(@"注册账号") forState:UIControlStateNormal];
        }
    }];
    
    
}

//检查输入
- (BOOL)checkInput {
    BOOL boolean = NO;
    if (self.password.text.length<6 || self.againPassword.text.length<6 || ![self.password.text isEqualToString:self.againPassword.text]) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"输入密码不相同,请重新输入") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
    } else {
        boolean = YES;
    }
    return boolean;
}

//登录方法
-(void)login
{
    //参数
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary *parameters = @{@"user":self.phoneNumber.text, @"pwd":self.password.text,@"app_kind":app_kind};
    //执行
    NetRequest * loginRequest = [[NetRequest alloc]init];
    [loginRequest  urlStr:[ApiUrl loginUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"%@",customDict);
        //成功
        if ([[customDict objectForKey:@"ret"] intValue] ==1) {
                SQLDataBase * sql =[[SQLDataBase alloc] init];
                [sql save:customDict];
            [NotifyCenter sendLoginStatus:customDict];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneNumber resignFirstResponder];
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.againPassword resignFirstResponder];
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
        self.againPassword.secureTextEntry = NO;
        sender.tag = 1;
    } else if (sender.tag == 1) {
        [sender setBackgroundImage:[UIImage imageNamed:@"secure_ico.png"] forState:UIControlStateNormal];
        self.password.secureTextEntry = YES;
        self.againPassword.secureTextEntry = YES;
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
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.name]) {
        [textField resignFirstResponder];
        [self.password becomeFirstResponder];
    } else if ([textField isEqual:self.password]) {
        [textField resignFirstResponder];
        [self.againPassword becomeFirstResponder];
    } else if ([textField isEqual:self.againPassword]) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
