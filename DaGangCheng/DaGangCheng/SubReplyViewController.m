//
//  SubReplyViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "SubReplyViewController.h"
#import "NewLoginContoller.h"


@interface SubReplyViewController ()

@end

@implementation SubReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if(DeviceVersion >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO; // Avoid the top UITextView space, iOS7 (~bug?)
    }
    
    self.title = GDLocalizedString(@"回复评论");
    self.view.backgroundColor = [UIColor whiteColor];
    //发表按钮
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 32)];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitle:GDLocalizedString(@"发表") forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    sendBtn.layer.cornerRadius = 2;
    [sendBtn addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    
    //表情
    [self showSubReplyBoxView];
}

- (void)showSubReplyBoxView {
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
        [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    if (!self.boxView) {
        CGRect frame = self.view.frame;
        self.boxView = [[SubReplyBoxView alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        //
        UITextView *contentTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 64+5, self.view.frame.size.width-10*2, 200)];
        contentTV.font = [UIFont systemFontOfSize:15];
        contentTV.layer.masksToBounds = YES;
        contentTV.layer.cornerRadius  = 5;
        contentTV.layer.borderColor   = [[UIColor lightGrayColor] CGColor];
        contentTV.layer.borderWidth   = 0.5;
        [self.view addSubview:contentTV];
        self.boxView.contentTV = contentTV;
        self.contentTV = contentTV;
    }
//    self.boxView.postId = self.postID;
    self.boxView.delegate = self;
//    self.boxView.replyDelegate = self;
    self.boxView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.boxView];
    [self.boxView.contentTV becomeFirstResponder];
}

- (void)back:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reply:(UIButton *)sender
{
    NetRequest *request =[[NetRequest alloc] init];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString* content =  self.contentTV.text;
    //表情转换
    content = [ZBTFaceImage wordToFace:content];
    //去除ios自带表情
    content = [ZBTFaceImage stringContainsEmoji:content];
    if (content.length<1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"输入内容为空!") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    }
    
    NSDictionary * parameters =@{
                                 @"reply_id": [NSString stringWithFormat:@"%ld", self.replyId],
                                 @"content":content,
                                 @"uid": [HuaxoUtil getUdidStr],
                                 @"xid": @"",
                                 @"xkind": @"",
                                 @"xlen": @"",
                                 @"gps_lng":appsetting.longitudeStr,
                                 @"gps_lat":appsetting.latitudeStr,
                                 @"addr":appsetting.address,
                                 };
    sender.enabled = NO;
    
    [request urlStr:[ApiUrl subReplyPlusUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        sender.enabled = YES;
        if(![(NSNumber*) customDict[@"ret"] intValue])
        {
            NSLog(@"reply failed!  %@",customDict );
            [self showMsg:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"回复评论失败"),customDict[@"msg"]] title:GDLocalizedString(@"回复评论失败")];
            return ;
        }
        if([self.delegate respondsToSelector:@selector(subReplySuccessWithIndex:content:)])
        {
//            [self.delegate subReplySuccess:[NSString stringWithFormat:@"%@",customDict[@"sub_id"]] content:content];
            [self.delegate subReplySuccessWithIndex:self.index content:content];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)showMsg:(NSString*)msg title:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
    [alertView show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
