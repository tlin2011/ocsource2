//
//  MsgSendViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MsgSendViewController.h"
#import "CommHead.h"
#import "ZBAppSetting.h"
#import "LoginViewController.h"
#import "NewLoginContoller.h"


@interface MsgSendViewController ()

@end

@implementation MsgSendViewController

@synthesize editView,cancelBtn,sendBtn,fastTextView;

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
    
    self.title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"私信"),self.name];
    fastTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0,editView.frame.size.width, editView.frame.size.height)];

    [editView addSubview:fastTextView];
    editView.layer.masksToBounds = YES;
    editView.layer.cornerRadius  = 5;
    //editView.backgroundColor     = [UIColor lightGrayColor];
    editView.layer.borderColor   = [[UIColor lightGrayColor] CGColor];
    editView.layer.borderWidth   = 0.5;
    
    self.msg = self.msg?self.msg:@"";
    self.fastTextView.text = self.msg;
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
        
        [NewLoginContoller tologinWithVC:self];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendBtnClicked:(id)sender {
    [self sendMsg];
}

- (IBAction)cancelBtnClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendMsg
{
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    NetRequest * request2 =[[NetRequest alloc]init];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString* msg = fastTextView.text;
    NSDictionary * parameters =@{
                                 @"uid":[HuaxoUtil getUdidStr],
                                 @"to_uid":self.uid,
                                 @"msg":msg,
                                 @"xid": @"",
                                 @"xkind": @"",
                                 @"xlen": @"",
                                 @"gps_lng":appsetting.longitudeStr,
                                 @"gps_lat":appsetting.latitudeStr,
                                 @"addr":appsetting.address
                                 };
    [request2 urlStr:[ApiUrl sendMsgUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if ([(NSNumber*)customDict[@"ret"] intValue]) {
            //NSString* post_id = [NSString stringWithFormat:@"%@",customDict[@"post_id"]] ;
            if([self.delegate respondsToSelector:@selector(sendMsgSuccess:msg:)])
            {
                [self.delegate sendMsgSuccess:customDict[@"msg_id"] msg:msg];
            }
            [self cancelBtnClicked:nil];
        }
        else
        {
            NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"发送私信失败")];
        }
    }];
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
