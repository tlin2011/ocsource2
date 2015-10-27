//
//  LoginViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-2-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "LoginViewController.h"

#import "SQLDataBase.h"
#import "ApiUrl.h"

#import "NetRequest.h"
#import "CommHead.h"
#import "ZBAppSetting.h"
#import "ZBSmsRegisterVC.h"
#import "RegisterViewController.h"
#import "ZBAppSetting.h"

//友盟统计
#import "MobClick.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *displayPwdBtn;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;




@end

@implementation LoginViewController

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
    [self initSubviews];
}

-(void)initSubviews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"注册") style:UIBarButtonItemStyleBordered target:self action:@selector(toRegisterVC)];
    
    self.title = GDLocalizedString(@"登录");
    
    self.backgroundView.frame = self.view.bounds;
    
    [self.loginBtn setBackgroundColor:UIColorWithMobanTheme];
    self.loginBtn.layer.cornerRadius = 2;
    self.loginBtn.layer.masksToBounds = YES;
    
    [self.findPwdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //
    self.userName.placeholder = GDLocalizedString(@"UID/手机/用户名");
    self.password.placeholder = GDLocalizedString(@"6位以上密码");
    [self.findPwdBtn setTitle:GDLocalizedString(@"忘记密码") forState:UIControlStateNormal];
    [self.loginBtn setTitle:GDLocalizedString(@"登录") forState:UIControlStateNormal];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //友盟统计
    [MobClick beginLogPageView:GDLocalizedString(@"登录页面出现")];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //友盟统计
    [MobClick endLogPageView:GDLocalizedString(@"登录页面关闭")];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录按钮
- (IBAction)loginAction:(UIButton *)sender {
    //收起键盘
    [self.password resignFirstResponder];
    [self.userName resignFirstResponder];
    
    [sender setTitle:GDLocalizedString(@"登录账号中...") forState:UIControlStateNormal];
    
    
    UIDevice *device=[UIDevice currentDevice];
    NSString *imei = device.identifierForVendor.UUIDString;

    //参数
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary *parameters = @{@"user":self.userName.text, @"pwd":self.password.text,@"app_kind":app_kind,@"imei":imei};
    //执行

    __block UIButton *bSender = sender;
    //请求
    NetRequest * request =[[NetRequest alloc] init];
    [request urlStr:[ApiUrl loginUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"responseObject = %d",[(NSString*)[customDict objectForKey:@"ret"] intValue] );
        //成功
        if ([[customDict objectForKey:@"ret"] intValue] ) {
            SQLDataBase * sql =[[SQLDataBase alloc] init];
            [sql deleteData];
            [sql save:customDict];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            [NotifyCenter sendLoginStatus:customDict];
            
            //友盟统计
            [MobClick event:@"login"];

            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];

            [bSender setTitle:GDLocalizedString(@"登录账号成功") forState:UIControlStateNormal];
        }
        //失败
        else if ([[customDict objectForKey:@"ret"] intValue] ==0)
        {
            NSLog(@"%@",customDict);
            NSString* msg = [NSString stringWithFormat:@"%@",customDict[@"msg"]];
            if ([msg isKindOfClass:[NSNull class]] || [msg isEqualToString:@"(null)"]) {
                msg = GDLocalizedString(@"请检查网络连接");
            }
            msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),msg];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"登录失败")];
            [bSender setTitle:GDLocalizedString(@"登录账号") forState:UIControlStateNormal];
        }
        //NSLog(@"%@",customDict);
    }];
    
}

+ (void)tologinWithVC:(UIViewController *)vc {
    [self tologinWithVC:vc animated:YES];
}

+ (void)tologinWithVC:(UIViewController *)vc animated:(BOOL)flag{

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *next = [board instantiateViewControllerWithIdentifier:@"LoginView"];
    next.hidesBottomBarWhenPushed = YES;
    next.title = GDLocalizedString(@"登录");
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    [vc presentViewController:navi animated:flag completion:Nil];
}

- (void)toRegisterVC {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if ([[ZBAppSetting standardSetting] isOpenValidateCode]) {
        ZBSmsRegisterVC *vc = [board instantiateViewControllerWithIdentifier:@"ZBSmsRegisterVC"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        RegisterViewController *rvc = [board instantiateViewControllerWithIdentifier:@"RegisterViewController"];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
    
}


- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//忘记密码按钮
- (IBAction)forgetAction:(UIButton *)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    if ([[ZBAppSetting standardSetting] isOpenValidateCode]) {
//        ZBRetrievePassword *vc = [board instantiateViewControllerWithIdentifier:@"ZBRetrievePassword"];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        FindPwdViewController *vc = [board instantiateViewControllerWithIdentifier:@"FindPwdViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    ZBRetrievePassword *vc = [board instantiateViewControllerWithIdentifier:@"ZBRetrievePassword"];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
