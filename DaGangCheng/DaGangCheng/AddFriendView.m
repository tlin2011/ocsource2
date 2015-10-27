//
//  AddFriendView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "AddFriendView.h"
#import "NetRequest.h"
#import "ApiUrl.h"
#import "SQLDataBase.h"
#import "HuaxoUtil.h"
#import "MBProgressHUD.h"
#import "MyCardViewController.h"
#import "MyMsgViewController.h"
#import "ZBTUrlCacher.h"

@interface AddFriendView ()<UIAlertViewDelegate>
{
    int friendFlag;
}

@property (nonatomic, strong) NSDictionary *list;


@end

@implementation AddFriendView
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andUserId:(NSString *)uid{
    self = [super init];
    if (self) {
        self.userId = uid;
        self.frame = frame;
        [self initSubviews];
    }
    return self;
}


- (void) initSubviews {
    if (![HuaxoUtil isLogined] || [self.userId isEqualToString: [HuaxoUtil getUdidStr]]) {
        return;
    }
    
    self.clipsToBounds = YES;
    CGRect frame = CGRectMake(0, 0, DeviceWidth, 100);

    self.backgroundColor = UIColorFromRGB(0xf3f3f5);
    
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 46)];
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.numberOfLines = 1;
    self.msgLabel.font = [UIFont systemFontOfSize:14];
    self.msgLabel.textColor = UIColorFromRGB(0x76797e);
    [self addSubview:self.msgLabel];

    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 46, 144, 38)];
    [self.addBtn setBackgroundImage:[self.class imageWithColor:UIColorWithMobanTheme andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"加为好友.png"] forState:UIControlStateNormal];
    [self.addBtn setTitle:GDLocalizedString(@"加为好友") forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateNormal];
    [self.addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.addBtn.layer.cornerRadius = 2.0f;
    self.addBtn.layer.borderWidth = 0.5f;
    self.addBtn.layer.borderColor = UIColorFromRGB(0xd3d3d5).CGColor;
    self.addBtn.layer.masksToBounds = YES;
    [self addSubview:self.addBtn];
    
    
    self.talkBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-10-144, 46, 144, 38)];
    self.talkBtn.backgroundColor = [UIColor whiteColor];
    [self.talkBtn setImage:[[UIImage imageNamed:@"私信_社区.png"] imageWithMobanThemeColor] forState:UIControlStateNormal];
    [self.talkBtn setTitle:GDLocalizedString(@"私信") forState:UIControlStateNormal];
    self.talkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.talkBtn setTitleColor:UIColorWithMobanTheme forState:UIControlStateNormal];
    [self.talkBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.talkBtn.layer.cornerRadius = 2.0f;
    self.talkBtn.layer.borderWidth = 0.5f;
    self.talkBtn.layer.borderColor = UIColorFromRGB(0xd3d3d5).CGColor;
    self.talkBtn.layer.masksToBounds = YES;
    [self addSubview:self.talkBtn];
    
    [self requestUserInfo];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)showInfo {
    self.frame = CGRectMake(0, 0, DeviceWidth, 100);
    [self.delegate.tableView setTableHeaderView:self];
    NSInteger flag = [self.list[@"flag"] integerValue];
    if (flag == 1) {
        [self.addBtn setTitle:GDLocalizedString(@"已是网友") forState:UIControlStateNormal];
        self.msgLabel.text = GDLocalizedString(@"你们已为网友，与Ta一起互动吧～");
    } else if (flag == 2) {
        [self.addBtn setTitle:GDLocalizedString(@"已是朋友") forState:UIControlStateNormal];
        self.msgLabel.text = GDLocalizedString(@"你们已为朋友，与Ta一起互动吧～");
    } else {
        [self.addBtn setTitle:GDLocalizedString(@"加为好友") forState:UIControlStateNormal];
        self.msgLabel.text = GDLocalizedString(@"你们还不是好友，快加为好友一起聊天吧～");
    }
    [self.talkBtn addTarget:self action:@selector(clickedTalkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(clickedAddBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickedTalkBtn:(UIButton *)sender {
    
    NSDictionary* customDict = self.list;
    MyMsgViewController * next =[[MyMsgViewController alloc] init];
    next.title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"私信"),customDict[@"name"]];
    next.to_name= (NSString*)customDict[@"name"];
    next.to_uid = self.userId;
    
    [self.delegate.navigationController pushViewController:next animated:YES];
}
 
- (void)clickedAddBtn:(UIButton *)sender {
    NSString *title = [self.addBtn titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"加为好友"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"加为朋友"), GDLocalizedString(@"加为网友"), nil];
        [av show];
    } else if ([title isEqualToString:@"已是网友"] || [title isEqualToString:@"已是朋友"]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"确定删除好友吗?") message: GDLocalizedString(@"删除后将无法及时收到对方动态") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定删除"),nil];
        alertView.tag = 3;
        [alertView show];
    }
}

//alertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==2)
    {
        if(buttonIndex == 1)
        {
            UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //2.进攻,下一球
            MyCardViewController * next =[board instantiateViewControllerWithIdentifier:@"MyCardViewController"];
            //3.假动作,急停,跳投
            next.title = GDLocalizedString(@"个人名片");
            [self.delegate.navigationController pushViewController:next animated:YES];
            [self.delegate.navigationController hidesBottomBarWhenPushed];
        }
        
        return ;
    }else if(alertView.tag ==3){
        if(buttonIndex == 1)
        {
            [self delFriend];
        }
        
        return ;
    }
    //加为朋友
    if (buttonIndex ==1)
    {
        if(friendFlag ==2)
        {
            [self showMsg:GDLocalizedString(@"已经是您的朋友")];
            return ;
        }
        [self makeFriend:2];
    }
    //切换
    else if ( buttonIndex ==2)
    {
        if(friendFlag==1||friendFlag==2)
        {
            [self showMsg:GDLocalizedString(@"已经是您的好友")];
            return ;
        }
        [self makeFriend:1];
    }
//    //退出
//    else if (buttonIndex ==3)
//    {
//        if(!(friendFlag==1||friendFlag==2))
//        {
//            [self showMsg:@"你们是陌生人,无法删除好友"];
//            return ;
//        }
//        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确定删除好友吗?" message:@"删除后将无法及时收到对方动态" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定删除",nil];
//        alertView.tag = 3;
//        [alertView show];
//    }
}

-(void)showMsg:(NSString*)str
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"操作失败") message:str delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
    [alertView show];
}

-(void)requestUserInfo
{
    //ApiUrl * url =[ ApiUrl new];
    NetRequest * request =[NetRequest new];
    self.userId = self.userId?self.userId:@"0";
    
    NSDictionary * parameters = @{
                                  @"uid": [HuaxoUtil getUdidStr],
                                  @"to_uid": self.userId,
                                  @"gps_lng": @"",
                                  @"gps_lat": @"",
                                  @"addr": @"",
                                  };
    
    [request urlStr:[ApiUrl userInfoXQUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"我要看的%@",customDict);
        if(![(NSNumber*)customDict[@"ret"] intValue])
        {
            NSLog(@"get user-info failed!msg:%@",customDict[@"msg"]);
            return ;
        }
        
        self.list = customDict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showInfo];
        });
        
    }];
}

-(void) makeFriend:(int) flag
{
    if(![HuaxoUtil isLogined])
    {
        return ;
    }
    
    //ApiUrl * url =[ ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parameters = @{
                                  @"uid": [HuaxoUtil getUdidStr],
                                  @"to_uid": self.userId,
                                  @"flag":[NSString stringWithFormat:@"%d",flag]
                                  };
    [request urlStr:[ApiUrl makeFriendUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         //NSLog(@"make-friend-ret:%@",customDict);
         if([((NSNumber*)customDict[@"have_no_card"]) intValue])
         {
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"无法加他/她为朋友") message:GDLocalizedString(@"您需要设置个人名片信息,再尝试加对方为朋友") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"设置名片"),nil];
             alertView.tag = 2;
             [alertView show];
             return ;
         }
         if(![(NSNumber*)customDict[@"ret"] intValue])
         {
             NSString* str = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"添加好友失败") message:str delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
             [alertView show];
             //NSLog(@"makefriend failed! msg:%@",customDict[@"msg"]);
             //return ;
         }
         else{
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"好友请求发送成功") message:GDLocalizedString(@"请等待对方回应您的好友请求") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
             [alertView show];
         }
     }];
}

-(void) delFriend
{
    //ApiUrl * url =[ ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parameters = @{
                                  @"uid": [HuaxoUtil getUdidStr],
                                  @"to_uid": self.userId
                                  };
    [request urlStr:[ApiUrl delFriendUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         BOOL ret = [(NSNumber*)customDict[@"ret"] intValue];
         //NSLog(@"delfriend failed! msg:%@",customDict[@"msg"]);
         if(ret)
         {
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"删除好友成功") message:@"" delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles: nil];
             [alertView show];
             
             friendFlag = 0;

             [self.addBtn setTitle:GDLocalizedString(@"加为好友") forState:UIControlStateNormal];
             self.msgLabel.text = GDLocalizedString(@"你们还不是好友，快加为好友一起聊天吧～");
         }else{
             NSString* str = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"删除好友失败") message:str delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
             [alertView show];
         }
         //[bself.tableView reloadData];
     }];
}


@end
