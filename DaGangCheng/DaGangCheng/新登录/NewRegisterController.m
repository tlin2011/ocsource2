//
//  NewRegisterControllerViewController.m
//  wanwan1015
//
//  Created by huaxo2 on 15/10/20.
//  Copyright © 2015年 opencom. All rights reserved.
//

#import "NewRegisterController.h"

#import "LoginViewCell.h"

#import "NewLoginContoller.h"

#import "MTA.h"
#import "MTAConfig.h"


@interface NewRegisterController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    UIButton *codeBtn;
    NSTimer *authTimer;
    
    
    LoginViewCell *phoneViewCell;
    LoginViewCell *codeViewCell;
    LoginViewCell *nickNameViewCell;
    LoginViewCell *passViewCell;
    
    
}

@end

@implementation NewRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initSubView];
}


-(void)initSubView{
    
    CGFloat width=[[UIScreen mainScreen] bounds].size.width;
    CGFloat height=[[UIScreen mainScreen] bounds].size.height;
    
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    statusBarView.backgroundColor=UIColorWithMobanTheme;
    [self.view addSubview:statusBarView];
    
    

    
    UIButton *closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(22.5, 35, 16, 16)];
    [closeBtn setImage:[UIImage imageNamed:@"login_close_button"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    
    UIImageView *headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
    headImageView.image=[UIImage imageNamed:@"AppIcon60x60@2x.png"];
    headImageView.layer.cornerRadius=50;
    headImageView.layer.masksToBounds = YES;
    headImageView.center=CGPointMake(width/2, 130);
    [self.view addSubview:headImageView];
    
    
    phoneViewCell=[[LoginViewCell alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImageView.frame)+44, width, 40)];
    phoneViewCell.placeHodler=GDLocalizedString(@"请出入手机号！"); //@"请输入您的手机号码";
    
    codeBtn=[[UIButton alloc] initWithFrame:CGRectMake(width-50-57.5, 0, 50,24)];
    [codeBtn setTitle:GDLocalizedString(@"验证码") forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius=2;
    codeBtn.font=[UIFont systemFontOfSize:12];
    [codeBtn setBackgroundColor:UIColorFromRGB(0xFC6620)];
    
    [codeBtn addTarget:self action:@selector(clickCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [phoneViewCell addSubview:codeBtn];
    
    
    [self.view addSubview:phoneViewCell];
    
    
    codeViewCell=[[LoginViewCell alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneViewCell.frame)+8, width, 40)];
    codeViewCell.placeHodler=GDLocalizedString(@"请输入验证码！");
    [self.view addSubview:codeViewCell];
    
    
    nickNameViewCell=[[LoginViewCell alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(codeViewCell.frame)+8, width, 40)];
    nickNameViewCell.placeHodler=GDLocalizedString(@"请输入昵称！");
    [self.view addSubview:nickNameViewCell];
    
    passViewCell=[[LoginViewCell alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nickNameViewCell.frame)+8, width, 40)];
    passViewCell.placeHodler=@"请设置6位以上的密码";
    passViewCell.isPwd=YES;
    [self.view addSubview:passViewCell];

    
    UIButton *regsBtn=[[UIButton alloc] initWithFrame:CGRectMake(37.5,CGRectGetMaxY(passViewCell.frame)+33,width-(37.5*2), 40)];
    [regsBtn setTitle:GDLocalizedString(@"注册") forState:UIControlStateNormal];
    regsBtn.layer.cornerRadius=4;
    
    regsBtn.font=[UIFont systemFontOfSize:14];
    [regsBtn setBackgroundColor:UIColorFromRGB(0xFC6620)];
     [regsBtn setBackgroundColor:UIColorWithMobanTheme];
    [regsBtn addTarget:self action:@selector(clickRegsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regsBtn];
    
    
    UIButton *registertBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,200,30)];
    registertBtn.center=CGPointMake(width/2,height-28);
    [registertBtn setTitle:@"已有账号？马上登录>>" forState:UIControlStateNormal];
     registertBtn.font=[UIFont systemFontOfSize:14];
    [registertBtn setTitleColor:UIColorFromRGB(0xB7B7B7) forState:UIControlStateNormal];
    [registertBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registertBtn];
    
    
    UITextField *phoneNumber=(UITextField *)[phoneViewCell viewWithTag:202];
    phoneNumber.delegate=self;
    UITextField *smsPassword=(UITextField *)[codeViewCell viewWithTag:202];
    smsPassword.delegate=self;
    UITextField *name=(UITextField *)[nickNameViewCell viewWithTag:202];
    name.delegate=self;
    UITextField *password=(UITextField *)[passViewCell viewWithTag:202];
    password.delegate=self;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [authTimer invalidate];
}


/**
 *  跳转到登录页面
 */
-(void)toLoginPage{
    NSDictionary *kvs=@{@"name":@"TO_REGISTER"};
    [MTA trackCustomKeyValueEvent:@"click_event" props:kvs];
    [NewLoginContoller tologinWithVC:self];
}

/**
 *  点击关闭按钮
 */
-(void)closePageBtn{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 *  点击注册按钮
 */
-(void)clickRegsBtn:(UIButton *)sender{
    
    
    UITextField *phoneNumber=(UITextField *)[phoneViewCell viewWithTag:202];
    UITextField *smsPassword=(UITextField *)[codeViewCell viewWithTag:202];
    UITextField *name=(UITextField *)[nickNameViewCell viewWithTag:202];
    UITextField *password=(UITextField *)[passViewCell viewWithTag:202];
    
    //检查输入
    if (![self isOkInput]) {
        return;
    }
    
    [sender setTitle:GDLocalizedString(@"注册账号中...") forState:UIControlStateNormal];
    //参数
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSString *appVer = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_ver"];
    UIDevice *device=[UIDevice currentDevice];
    NSString *imei = device.identifierForVendor.UUIDString;
    NSDictionary *parameters = @{@"phone": phoneNumber.text,
                                 @"name":name.text,
                                 @"pwd":password.text,
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
                                 @"sms_code":smsPassword.text
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
            //关闭定时器
            [authTimer invalidate];
            
            
            NSDictionary *kvs=@{@"status":@"SUCCESS"};
            [MTA trackCustomKeyValueEvent:@"register_event" props:kvs];
            
        }else{
            NSLog(@"%@",customDict);
            NSString* msg = [NSString stringWithFormat:@"%@",customDict[@"msg"]];
            if ([msg isKindOfClass:[NSNull class]] || [msg isEqualToString:@"(null)"]) {
                msg = GDLocalizedString(@"请检查网络连接");
            }
            msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),msg];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"注册失败")];
            [bSender setTitle:GDLocalizedString(@"注册账号") forState:UIControlStateNormal];
            
            NSDictionary *kvs=@{@"status":@"FAIL"};
            [MTA trackCustomKeyValueEvent:@"register_event" props:kvs];
        }
    }];
}


//检查输入
- (BOOL)isOkInput {
    NSString *msg = nil;
    
    UITextField *phoneNumber=(UITextField *)[phoneViewCell viewWithTag:202];
    
    UITextField *smsPassword=(UITextField *)[codeViewCell viewWithTag:202];
    
    UITextField *name=(UITextField *)[nickNameViewCell viewWithTag:202];
    
    UITextField *password=(UITextField *)[passViewCell viewWithTag:202];
    
    if (phoneNumber.text.length < 11) {
        msg = GDLocalizedString(@"请出入手机号！");
    } else if (smsPassword.text.length < 6) {
        msg = GDLocalizedString(@"请输入验证码！");
    } else if (name.text.length<1) {
        msg = GDLocalizedString(@"请输入昵称！");
    } else if (password.text.length<6) {
        msg = GDLocalizedString(@"请输入密码！");
    }
    
    if (msg) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [av show];
        return NO;
    }
    return YES;
}

//登录方法
-(void)login
{
    UITextField *phoneNumber=(UITextField *)[phoneViewCell viewWithTag:202];
    UITextField *password=(UITextField *)[passViewCell viewWithTag:202];
    //参数
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary *parameters = @{@"user":phoneNumber.text, @"pwd":password.text,@"app_kind":app_kind};
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


/**
 *  点击发送验证码
 */
-(void)clickCodeBtn{
//    codeBtn.enabled=NO;
//    [codeBtn setTitle:@"60" forState:UIControlStateNormal];
//    authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAuthCodeBtnTitle:) userInfo:nil repeats:YES];

    
    UITextField *phoneNumber=(UITextField *)[phoneViewCell viewWithTag:202];
    
    if (phoneNumber.text.length<11) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"请输入手机号！") delegate:nil cancelButtonTitle:nil otherButtonTitles: GDLocalizedString(@"确定"), nil];
        [av show];
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@：+86 %@",GDLocalizedString(@"我们将发送 验证码 短信到这个号码") ,phoneNumber.text];
    UIAlertView *av2 = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), GDLocalizedString(@"取消"), nil];
    [av2 show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex %ld", (long)buttonIndex);
    if (buttonIndex == 0) {
        [self requestAuthCode];
    }else{
        NSDictionary *kvs=@{@"status":@"CANCEL"};
        [MTA trackCustomKeyValueEvent:@"register_event" props:kvs];
    }
}


- (void)requestAuthCode {
    
    
    UITextField *phoneNumber=(UITextField *)[phoneViewCell viewWithTag:202];
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    NSDictionary *parameters = @{@"phone":phoneNumber.text,
                                 @"app_kind":app_kind,
                                 @"type":@"code",
                                 //@"s_secret_key":@"GZ58fLkDfBmPJs1OKQ@1805"
                                 };
    //执行
    NetRequest * loginRequest = [[NetRequest alloc]init];
    [loginRequest  urlStr:[ApiUrl sendClientSms] parameters:parameters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"%@",customDict);
        //成功
        if ([[customDict objectForKey:@"ret"] intValue] ==1) {
            codeBtn.enabled=NO;
            [codeBtn setTitle:@"60" forState:UIControlStateNormal];
            authTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAuthCodeBtnTitle:) userInfo:nil repeats:YES];
        } else {
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"发送失败") message:customDict[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), nil];
            [av show];
            
        }
        
        
    }];
}


- (void)changeAuthCodeBtnTitle:(NSTimer *)sender {
    NSInteger num = [codeBtn.currentTitle integerValue];
    num -= 1;
    if (num == -1) {
        [codeBtn setTitle:GDLocalizedString(@"发送") forState:UIControlStateNormal];
        codeBtn.enabled=YES;
        [sender invalidate];
    } else {
        [codeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    }
}



/**
 * 隐藏键盘
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame=self.view.frame;
                    frame.origin.y=0;
                    self.view.frame=frame;
                }];
    [self.view endEditing:YES];
}


- (void)back:(id)sender {
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


+ (void)torRegisterWithVC:(UIViewController *)vc animated:(BOOL)flag{
    
    NewRegisterController *nlcController=[[NewRegisterController alloc] init];
    nlcController.hidesBottomBarWhenPushed = YES;
//    nlcController.title = GDLocalizedString(@"注册");
//    nlcController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:nlcController action:@selector(back:)];
//    [nlcController.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    
//    [vc.navigationController setToolbarHidden:NO animated:NO];
    [vc.navigationController setNavigationBarHidden:YES animated:YES];
    [vc.navigationController pushViewController:nlcController animated:YES];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=-150;
        self.view.frame=frame;
    }];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    
//    UITextField *name=(UITextField *)[nickNameViewCell viewWithTag:202];
//    
//    if (textField!=name) {}
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            CGRect frame=self.view.frame;
//            frame.origin.y=0;
//            self.view.frame=frame;
//        }];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
