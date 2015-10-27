//
//  MsgBoxView.m
//  DaGangCheng
//
//  Created by huaxo on 15-1-20.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MsgBoxView.h"
#import "LoginViewController.h"
#import "NewLoginContoller.h"
#import "HuaxoUtil.h"
#import "NetRequest.h"
#import "ZBAppSetting.h"

@implementation MsgBoxView

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect startFrame = self.frame;
    startFrame.origin = CGPointMake(startFrame.origin.x, DeviceHeight-startFrame.size.height);
    self.frame = startFrame;
}

-(void)replyPost:(NSString *)content {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self.delegate];
        [NewLoginContoller tologinWithVC:self.delegate];
        return;
    }
    
    if (!self.toUid) {
        return;
    }
    
    NetRequest * request2 =[[NetRequest alloc]init];
    ZBAppSetting* appsetting = [ZBAppSetting standardSetting];
    
    NSDictionary * parameters =@{
                                 @"uid":[HuaxoUtil getUdidStr],
                                 @"to_uid":self.toUid,
                                 @"msg":content,
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
            if([self.msgDelegate respondsToSelector:@selector(sendMsgSuccess:msg:)])
            {
                [self.msgDelegate sendMsgSuccess:customDict[@"msg_id"] msg:content];
            }
            [self updateView];
            
        }
        else
        {
            NSString* msg = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
            [HuaxoUtil showMsg:msg title:GDLocalizedString(@"发送私信失败")];
        }
    }];
}

@end
