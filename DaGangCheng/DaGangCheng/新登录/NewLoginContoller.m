//
//  NewLoginContoller.m
//  wanwan1015
//
//  Created by huaxo2 on 15/10/20.
//  Copyright © 2015年 opencom. All rights reserved.
//

#import "NewLoginContoller.h"

#import "MTA.h"
#import "MTAConfig.h"

#import "NewRegisterController.h"

#import "LoginViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface NewLoginContoller ()<UITextFieldDelegate>{
    LoginViewCell *loginViewCell;
    LoginViewCell *passViewCell;
}

@end

@implementation NewLoginContoller

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
    headImageView.center=CGPointMake(width/2, 160);
    [self.view addSubview:headImageView];
    
    loginViewCell=[[LoginViewCell alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headImageView.frame)+50, width, 50)];
    loginViewCell.headImage=[UIImage imageNamed:@"login_change_name_ico"];
    loginViewCell.placeHodler= GDLocalizedString(@"UID/手机/用户名");
    [self.view addSubview:loginViewCell];
    
    
    passViewCell=[[LoginViewCell alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginViewCell.frame)+15, width, 50)];
    passViewCell.headImage=[UIImage imageNamed:@"login_pass.png"];
    passViewCell.placeHodler=GDLocalizedString(@"6位以上密码");
    passViewCell.isPwd=YES;
    [self.view addSubview:passViewCell];
    
    
    
    UIButton *loginBtn=[[UIButton alloc] initWithFrame:CGRectMake(37.5,CGRectGetMaxY(passViewCell.frame)+33,width-(37.5*2), 40)];
    [loginBtn setTitle:GDLocalizedString(@"登录") forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius=4;
//    [loginBtn setBackgroundColor:UIColorFromRGB(0xFC6620)];
    
    [loginBtn setBackgroundColor:UIColorWithMobanTheme];
    
    [loginBtn addTarget:self action:@selector(clickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:loginBtn];
    
    
    UIButton *forgetPwd=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame)-90,CGRectGetMaxY(loginBtn.frame)+5,90, 30)];
    [forgetPwd setTitle:GDLocalizedString(@"忘记密码") forState:UIControlStateNormal];
    forgetPwd.font=[UIFont systemFontOfSize:14];
    [forgetPwd setTitleColor:UIColorFromRGB(0x79B0E3) forState:UIControlStateNormal];
     [forgetPwd addTarget:self action:@selector(clickForgitPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPwd];
    
    
    UIButton *registertBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,30)];
    registertBtn.center=CGPointMake(width/2,height-28);
    [registertBtn setTitle:GDLocalizedString(@"注册账号") forState:UIControlStateNormal];
    registertBtn.font=[UIFont systemFontOfSize:14];
    [registertBtn setTitleColor:UIColorFromRGB(0xB7B7B7) forState:UIControlStateNormal];
    [registertBtn addTarget:self action:@selector(clickToGegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registertBtn];
    
    
    
    UITextField *phoneNumber=(UITextField *)[loginViewCell viewWithTag:202];
    phoneNumber.delegate=self;
    UITextField *smsPassword=(UITextField *)[passViewCell viewWithTag:202];
    smsPassword.delegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 *  跳转到注册页面
 */
-(void)clickToGegister{
    
    NSDictionary *kvs=@{@"name":@"TO_LOGIN"};
    [MTA trackCustomKeyValueEvent:@"click_event" props:kvs];
    
    [NewRegisterController torRegisterWithVC:self animated:YES];
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


/**
 *  跳转到忘记密码
 */
-(void)clickForgitPwd{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZBRetrievePassword *vc = [board instantiateViewControllerWithIdentifier:@"ZBRetrievePassword"];
    
    
    
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:vc action:@selector(back:)];
    [vc.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    
    [self.navigationController setNavigationBarHidden:NO animated:true];
    
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 *  点击关闭页面
 */
-(void)closePageBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  点击登录按钮
 */

-(void)clickLoginBtn:(UIButton *)sender{
    
    [sender setTitle:GDLocalizedString(@"登录账号中...") forState:UIControlStateNormal];
    
    
    UIDevice *device=[UIDevice currentDevice];
    NSString *imei = device.identifierForVendor.UUIDString;

    UITextField *userNameField=(UITextField *)[loginViewCell viewWithTag:202];
    UITextField *passWorldField=(UITextField *)[passViewCell viewWithTag:202];
    
    
    //参数
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary *parameters = @{@"user":userNameField.text, @"pwd":passWorldField.text,@"app_kind":app_kind,@"imei":imei};
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
    
    NewLoginContoller *nlcController=[[NewLoginContoller alloc] init];
    nlcController.hidesBottomBarWhenPushed = YES;
//    nlcController.title = GDLocalizedString(@"登录");
//    nlcController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:nlcController action:@selector(back:)];
//    [nlcController.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nlcController];
//    [navi setToolbarHidden:YES animated:TRUE];
    

     [[UINavigationBar appearance] setBarTintColor:UIColorWithMobanTheme];
    [navi setNavigationBarHidden:YES animated:YES];
    [vc presentViewController:navi animated:flag completion:Nil];

}

- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=self.view.frame;
        frame.origin.y=-100;
        self.view.frame=frame;
    }];
    
    return YES;
}



@end
