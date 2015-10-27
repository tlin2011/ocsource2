//
//  ZBTSuperCSReplyView.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTSuperCSReplyView.h"
#import "AppDelegate.h"
#import "NetRequest.h"
#import "ZBAppSetting.h"
#import "ApiUrl.h"
#import "HuaxoUtil.h"
#import "Praise.h"
#import "UploadImage.h"

@interface ZBTSuperCSReplyView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@end

@implementation ZBTSuperCSReplyView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 270)];
    self.view.center = CGPointMake(DeviceWidth/2.0, DeviceHeight/2.0-20);
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 5;
    self.view.layer.borderWidth = 0.5;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.layer.masksToBounds = YES;
    //self.view.alpha = 0.5;
    
    CGRect frame = self.view.frame;
    
    self.tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 30)];
    self.tf.font = [UIFont systemFontOfSize:15];
    //[self.tf setBorderStyle:UITextBorderStyleRoundedRect];
    self.tf.delegate = self;
    self.tf.placeholder = GDLocalizedString(@"请输入评论内容...");
    //self.tf.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.tf];
    
    UIImageView *bgIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, frame.size.height - 45 - 55)];
    bgIv.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:bgIv];
    
    self.iv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2.0-60, 50, 120, 160)];
    [self.view addSubview:self.iv];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 80 - 10, frame.size.height-35 - 10, 80, 35)];
    [self.cancelBtn setTitle:GDLocalizedString(@"取消") forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundColor:UIColorWithMobanTheme];
    [self.cancelBtn addTarget:self action:@selector(clickedCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    self.replyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, frame.size.height - 35 - 10, 80, 35)];
    [self.replyBtn setTitle:GDLocalizedString(@"回复") forState:UIControlStateNormal];
    [self.replyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.replyBtn setBackgroundColor:UIColorWithMobanTheme];
    [self.replyBtn addTarget:self action:@selector(clickedReplyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.replyBtn];
}

- (void)show {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.5;
    [btn addTarget:self action:@selector(clickedBgBtn:) forControlEvents:UIControlEventTouchDown];
    
    AppDelegate *app = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [[app window] addSubview:self];
    [[app window] addSubview:btn];
    
    self.bgButton = btn;
    
    self.iv.image = self.image;
    [[app window] addSubview:self.view];
    
}

- (void)clickedCancelBtn:(UIButton *)sender {
    [self.bgButton removeFromSuperview];
    [self.view removeFromSuperview];
    [self removeFromSuperview];
}

- (void)clickedBgBtn:(UIButton *)sender {
    [self.tf resignFirstResponder];
}

- (void)clickedReplyBtn:(UIButton *)sender {
    [sender setTitle:GDLocalizedString(@"回复中...") forState:UIControlStateNormal];
    
    UIImage *image = self.image;
    NSString *postId = self.postId;
    
    [UploadImage uploadWithImage:image completed:^(NSString *imageStr, NSError *error) {
        if (imageStr) {
            [self replyPost:[NSString stringWithFormat:@"%@ %@",self.tf.text,imageStr] postId:postId];
        }
        
        //删除视图
        [self clickedCancelBtn:nil];
    }];
    
}

//回复一级评论
- (void)replyPost:(NSString *)content postId:(NSString *)postId
{
    NetRequest *request =[[NetRequest alloc] init];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    
    if (content.length<1) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"输入内容为空!") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    }
    NSDictionary * parameters =@{
                                 @"post_id": postId,
                                 @"content":content,
                                 @"uid": [HuaxoUtil getUdidStr],
                                 @"xid": @"",
                                 @"xkind": @"",
                                 @"xlen": @"",
                                 @"gps_lng":appsetting.longitudeStr,
                                 @"gps_lat":appsetting.latitudeStr,
                                 @"addr":appsetting.address,
                                 };
    
    [request urlStr:[ApiUrl replyPlusUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        

        
        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"reply failed!  %@",customDict );
            [Praise hudShowTextOnly:GDLocalizedString(@"评论失败") delegate:self.delegate];
            return ;
        }

        [Praise hudShowTextOnly:GDLocalizedString(@"评论成功") delegate:self.delegate];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tf resignFirstResponder];
    return YES;
}

- (void)dealloc {
    NSLog(@"ZBTSuperCSReplyView delloc");
}



@end
