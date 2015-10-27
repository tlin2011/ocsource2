//
//  ReportPost.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ReportPost.h"
#import "HuaxoUtil.h"
#import "NetRequest.h"
#import "ApiUrl.h"
#import "MBProgressHUD.h"
@interface ReportPost ()
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *postUid;
@property (nonatomic, copy) NSString *actKind;
@end

@implementation ReportPost

- (id)initWithWithPostId:(NSString *)postId postUid:(NSString *)uid actKind:(NSString *)kind delegate:(id)delegate {
    self = [super init];
    if (self) {
        self.postId = postId;
        self.postUid = uid;
        self.actKind = kind;
        self.delegate = delegate;
    }
    return self;
}

- (void)startReport {
    [self reportPostWithPostId:self.postId postUid:self.postUid actKind:self.actKind delegate:self.delegate];
}

- (void)reportPostWithPostId:(NSString *)postId postUid:(NSString *)uid actKind:(NSString *)kind delegate:(id)delegate {
    if ([HuaxoUtil isLogined]) {
        //登录了
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"请输入举报原因") message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"),GDLocalizedString(@"取消"), nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av show];

    }else {
        //未登录
        [Praise hudShowTextOnly:GDLocalizedString(@"请登录后再举报") delegate:delegate];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        if ([tf.text length] <2) {
            [self.class hudShowTextOnly:GDLocalizedString(@"不得少于2个文字") delegate:self.delegate];
        } else {

            [ZBReport reportWithKindId:self.postId getReportUid:self.postUid reportUid:[HuaxoUtil getUdidStr] reportKind:ZBReportKindPost reason:tf.text completed:^(BOOL result, NSString *msg, NSError *error) {
                [Praise hudShowTextOnly:msg delegate:self.delegate];
            }];
        }
    } else if (buttonIndex == 1) {
        
    }
}

@end
