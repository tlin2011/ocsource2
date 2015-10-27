//
//  MyTableViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-2-27.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyTableViewController.h"



#import "SQLDataBase.h"
#import "LoginViewController.h"
#import "ModifyViewController.h"
#import "MyCollectionTableVC.h"
#import "PersonageSlideVC.h"
#import "ZBTMyFeedTableVC.h"
#import "PersonageTableVC.h"
#import "UploadImage.h"

#import "PersonageCardTableVC.h"
#import "PersonageDynamicTableVC.h"
#import "PersonageTopicTableVC.h"
#import "PersonageFocusTableVC.h"
#import "MySettingTableVC.h"
#import "LoginViewController.h"
#import "PindaoFocusSQL.h"
#import "MyCardViewController.h"
#import "CSHistoryViewController.h"
#import "PersonageVisitorTableVC.h"

#import "MyProfileTableViewController.h"

#import "MyMsgBoxTableViewController.h"

#import "myCard/MyCardPkgTableViewController.h"
#import "ZBTUIWebViewController.h"

#import "NewLoginContoller.h"


@interface MyTableViewController ()

@property (strong, nonatomic) UIButton *loginBtn;

@property (strong, nonatomic) UILabel *numLabel;


@property (assign, nonatomic) int unReadCount;

@end

@implementation MyTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        //接受动态通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNewsLisenter:) name:[NotifyCenter userNotifyKey] object:nil];
    }
    return self;
}

-(void)userNewsLisenter:(NSNotification*) aNotification
{
    NSDictionary* newsDic = aNotification.userInfo;
    
    //聊天动态
    int fCnt = [(NSNumber*)newsDic[@"freq_cnt"] intValue]+[(NSNumber*)newsDic[@"umsg_new"] intValue]/*+[(NSNumber*)newsDic[@"gf_new"] intValue]+[(NSNumber*)newsDic[@"nf_new"] intValue]*/;
    self.myTalkTipNum = fCnt;
    
    //我的动态
    int myCnt = [(NSNumber*)newsDic[@"feed_cnt"] intValue];
//    self.myDynamicTipNum = myCnt;
    
    int msgNum = fCnt + myCnt;
    [self.navigationController.tabBarItem setBadgeValue:msgNum?[NSString stringWithFormat:@"%d",msgNum]:nil];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    
    [self initUI];
    
//    [self getUnreadCount];
     [NSThread detachNewThreadSelector:@selector(loopMethod) toTarget:self withObject:nil];
    
}



- (void)loopMethod
{
    [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


//获取卡包未读总数
-(void)getUnreadCount{
    
    NSDictionary *dict=@{};
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFUnReadCount] parameters:dict success:^(id responseObject) {
        NSDictionary *result =responseObject;
        if ([result[@"ret"] intValue]>0) {
            self.myDynamicTipNum=[result[@"total"] integerValue];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            
            _unReadCount=[result[@"total"] intValue];
        }else{
            self.myDynamicTipNum=0;
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)initUI {
    //设置图像
    self.upImage.layer.masksToBounds = YES;
    self.upImage.layer.cornerRadius  = 32;
    
    //管理按钮
    self.myManage.layer.cornerRadius = 5;
    self.myManage.layer.masksToBounds = YES;
    self.myManage.backgroundColor = UIColorWithMobanTheme;
    [self.myManage setTitle:GDLocalizedString(@"管理") forState:UIControlStateNormal];
    
    //注册Cell
    [self.tableView registerClass:[MyTableViewHeadCell class] forCellReuseIdentifier:@"MyTableViewHeadCell"];
    [self.tableView registerClass:[MyTableViewMessageCell class] forCellReuseIdentifier:@"MyTableViewMessageCell"];
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"MyTableViewCell"];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f5f6);
    [self.tableView setContentInset:UIEdgeInsetsMake(-4, 0, 4, 0)];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //FooterView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 14, self.tableView.frame.size.width-2*12, 36)];
    [self.loginBtn addTarget:self action:@selector(clickedLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:GDLocalizedString(@"登陆账号") forState:UIControlStateNormal];
    [self.loginBtn setTitle:GDLocalizedString(@"退出登陆") forState:UIControlStateSelected];
    [self.loginBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.loginBtn.backgroundColor = [UIColor whiteColor];
    
    self.loginBtn.layer.cornerRadius = 2.0f;
    self.loginBtn.layer.borderWidth = 0.5f;
    self.loginBtn.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    self.loginBtn.layer.masksToBounds = YES;
    
    [footerView addSubview:self.loginBtn];
    
    [self.tableView setTableFooterView:footerView];
    
    if ([HuaxoUtil isLogined]) {
        self.loginBtn.selected = YES;
    } else {
        self.loginBtn.selected = NO;
    }
    
}

- (void)clickedLoginBtn:(UIButton *)sender {
    
    if ([HuaxoUtil isLogined]) {
    
        //上传关注的频道列表
        [PindaoCacher uploadToNetwork];
        
        SQLDataBase * sql =[[SQLDataBase alloc] init];
        [sql deleteData];
        //未登录的情况
        [self didNotLogin];
        [NotifyCenter sendLoginStatus:nil];
        
        //匿名登录
        [NetRequest requestUdidInfo];
    } else {
        
//        [LoginViewController tologinWithVC:self];
        
        [NewLoginContoller tologinWithVC:self];
        
    }
}


#pragma mark - UITableViewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger row = 0;
    
    if (section == 0) {
        row = 1;
    } else if (section == 1) {
        row = 1;
    } else if (section == 2) {
        row = 4;
    } else if (section == 3) {
        row = 2;
    } else if (section == 4) {
        row = 1;
    } else {
        row = 0;
    }
    
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 4.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 4.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        MyTableViewHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewHeadCell"];
        headCell.userImageID = self.user.userImageID;
        headCell.name = self.user.nickName;
        headCell.UID = self.user.UID;
        headCell.phoneNumber = self.user.phoneNumber;
        headCell.isLogined = [HuaxoUtil isLogined];
        [headCell updateUI];
        
        cell = headCell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        MyTableViewMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewMessageCell"];
        messageCell.delegate = self;
        messageCell.myDynamicTipLabel.num = self.myDynamicTipNum;
        messageCell.myTalkTipLabel.num = self.myTalkTipNum;
        cell = messageCell;
        
    } else {
    
        MyTableViewCell *myTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
        
        NSString *imageStr = nil;
        NSString *title = nil;
        
        
        if(indexPath.section == 2 && indexPath.row == 0) {
            
            imageStr = @"my_我的动态@2x.png";
            title = GDLocalizedString(@"我的动态");
        
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            imageStr = @"my_我的话题.png";
            title = GDLocalizedString(@"我的话题");
        } else if (indexPath.section == 2 && indexPath.row == 2) {
//            imageStr = @"my_我的关注.png";
//            NSString *str = [ZBAppSetting standardSetting].unfocusName;
//            title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"我的"), str];

            imageStr = @"my_我的关注.png";
            title = GDLocalizedString(@"我的关注");
        } else if (indexPath.section == 2 && indexPath.row == 3) {
            imageStr = @"my_我的访客.png";
            title = GDLocalizedString(@"我的访客");
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            imageStr = @"my_我的阅读.png";
            title = GDLocalizedString(@"我的阅读");
        } else if (indexPath.section == 3 && indexPath.row == 1) {
            imageStr = @"my_我的收藏.png";
            title = GDLocalizedString(@"我的收藏");
        }
//        else if (indexPath.section == 4 && indexPath.row == 0) {
//            imageStr = @"my_关于应用.png";
//            title = GDLocalizedString(@"关于应用");
//        }
        else if (indexPath.section == 4 && indexPath.row == 0) {
            imageStr = @"my_设置.png";
            title = GDLocalizedString(@"设置");
        }
        myTableViewCell.image = [UIImage imageNamed:imageStr];
        myTableViewCell.title = title;
        [myTableViewCell updateUI];
        
        cell = myTableViewCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        height = [MyTableViewHeadCell heightWithCell];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        height = [MyTableViewMessageCell heightWithCell];
    } else {
        height = [MyTableViewCell heightWithCell];
    }
    
    return height;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showUserInfo];
}

-(void)showUserInfo
{
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSDictionary * aDic =[sql query];
    //NSLog(@"%@",aDic);
    if ([HuaxoUtil isLogined]) {
        [self didLogin:aDic];
    }
    else
    {
        [self didNotLogin];
    }
}

//已经登录的情况
-(void)didLogin:(NSDictionary*)aDic
{
    //用户名
    self.user.nickName = [aDic objectForKey:@"user_name"];
    
    //UID
    NSString *UIDStr = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"phone_uid"]];
    self.user.UID = [UIDStr integerValue];
    
    //电话号码
    NSString * phoneStr = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"phone"]];
    self.user.phoneNumber = phoneStr;
    //头像
    long imageID = [[aDic objectForKey:@"img_id"] integerValue];
    self.user.userImageID = imageID;
    
    //
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    //显示设置
    self.myManage.hidden = NO;

    self.loginBtn.selected = YES;
}

- (ZBUser *)user {
    if (!_user) {
        _user = [[ZBUser alloc] init];
    }
    return _user;
}

//未登录的情况
-(void)didNotLogin
{
    self.user.nickName = GDLocalizedString(@"点击登录");
    
    //
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    //隐藏管理按钮
    self.myManage.hidden = YES;
    [self.upImage setBackgroundImage:[UIImage imageNamed:@"nm"]  forState:UIControlStateNormal ];
 
    self.loginBtn.selected = NO;
}

//静态tableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row==0){
        
        if (![HuaxoUtil isLogined]) {
//            [LoginViewController tologinWithVC:self];
            [NewLoginContoller tologinWithVC:self];
            return;
        }
    
//      NSString *uid = [HuaxoUtil getUdidStr];
        
        MyProfileTableViewController *mptvc=[[MyProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        mptvc.title = GDLocalizedString(@"我的资料");
        mptvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:mptvc animated:YES];
        
        
        
//        为测试浏览器
//        ZBTUIWebViewController *mptvc=[[ZBTUIWebViewController alloc]  init];
//        mptvc.hidesBottomBarWhenPushed=YES;
//        mptvc.isShowBall=YES;
//        mptvc.isShowTitle=YES;
//        mptvc.webViewUrl=@"https://www.baidu.com/";
//        [self presentViewController:mptvc animated:true completion:nil];
        
//        [self.navigationController pushViewController:mptvc animated:YES];
        
        
//        PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
//        sc.title = GDLocalizedString(@"个人主页");
//        sc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:sc animated:YES];
        
   
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        [self handleMyDynamic];
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        if (![HuaxoUtil isLogined]) {
//            [LoginViewController tologinWithVC:self];
            
            [NewLoginContoller tologinWithVC:self];
            return;
        }
        
        PersonageTopicTableVC *vc = [[PersonageTopicTableVC alloc] init];
        vc.userId = [HuaxoUtil getUdidStr];
        vc.title = GDLocalizedString(@"我的话题");
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        if (![HuaxoUtil isLogined]) {
//            [LoginViewController tologinWithVC:self];
             [NewLoginContoller tologinWithVC:self];
            return;
        }
        
        PersonageFocusTableVC *vc = [[PersonageFocusTableVC alloc] init];
        vc.userId = [HuaxoUtil getUdidStr];
        vc.title = GDLocalizedString(@"我的关注");
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        MyCardViewController *vc = [board instantiateViewControllerWithIdentifier:@"MyCardViewController"];
//        vc.title = GDLocalizedString(@"我的名片");
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        if (![HuaxoUtil isLogined]) {
//            [LoginViewController tologinWithVC:self];
             [NewLoginContoller tologinWithVC:self];
            return;
        }
        
        PersonageVisitorTableVC *vc = [[PersonageVisitorTableVC alloc] init];
        vc.userId = [HuaxoUtil getUdidStr];
        vc.title = GDLocalizedString(@"我的访客");
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

        
    } else if (indexPath.section == 3 && indexPath.row == 0) {

        if (![HuaxoUtil isLogined]) {
//            [LoginViewController tologinWithVC:self];
             [NewLoginContoller tologinWithVC:self];
            return;
        }
        
        UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CSHistoryViewController *vc = [board instantiateViewControllerWithIdentifier:@"CSHistoryViewController"];
        vc.title = GDLocalizedString(@"我的阅读");
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        
        if (![HuaxoUtil isLogined]) {
//            [LoginViewController tologinWithVC:self];
             [NewLoginContoller tologinWithVC:self];
            return;
        }
        
        MyCollectionTableVC *vc = [[MyCollectionTableVC alloc] init];
        vc.title = GDLocalizedString(@"我的收藏");
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    } else if (indexPath.section == 4 && indexPath.row == 0) {
        
        MySettingTableVC *vc = [[MySettingTableVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (IBAction)uploadTxClicked:(id)sender
{
    if(![HuaxoUtil isLogined]) return ;
    NSLog(@"leng= %ld",(unsigned long)[HuaxoUtil getUdidStr].length);
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:GDLocalizedString(@"上传新的个人头像") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:GDLocalizedString(@"相册上传"),GDLocalizedString(@"拍照上传"), nil];
    sheet.tag = 1;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==1)
    {
        if(buttonIndex==0)
        {
            [self pickPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else if(buttonIndex==1){
            
            [self pickPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }
}

- (void)pickPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //判断设备的相机模式是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

//得到图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (image) {
        [self uploadImg:image];
    } else {
        NSLog(@"编辑的图片为空!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)uploadImg:(UIImage*)img
{
    [UploadImage uploadWithImage:img completed:^(NSString *imageStr, NSError *error) {
        if (imageStr) {
            NSString *imgId = [imageStr substringWithRange:NSMakeRange(5, imageStr.length-6)];
            [self setTouxiangByImgId:imgId];
        }else {
            [HuaxoUtil showMsg:nil title:GDLocalizedString(@"图片上传失败")];
        }
    }];
}

-(void)setTouxiangByImgId:(NSString *)imageId
{
  
    NetRequest * request =[NetRequest new];
    SQLDataBase * sql = [SQLDataBase new];
    
    NSDictionary * parameters = @{
                                  @"uid":[HuaxoUtil getUdidStr],
                                  @"img_id":imageId
                                  };
    ZBLog(@"%@", imageId);
    [request urlStr:[ApiUrl setMyTouxiangUrl] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         BOOL ret = [customDict[@"ret"] intValue];;
         if(ret)
         {
             [HuaxoUtil showMsg:customDict[@"msg"] title:@""];
             [sql updateValue:imageId key:@"img_id"];
             
             [self showUserInfo];
             
             SQLDataBase * sql =[[SQLDataBase alloc] init];
             NSDictionary * aDic =[sql query];
             //NSLog(@"%@",aDic);
             if ([HuaxoUtil isLogined]) {
                 [self didLogin:aDic];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"用户更改头像" object:nil userInfo:aDic];
             }

             
         }else{
             NSString* msg= customDict[@"msg"];
             [HuaxoUtil showMsg:msg title:@""];
         }
     }];
}

//管理buutton
- (IBAction)myManage:(UIButton *)sender {
    UIAlertView * alertView =[[UIAlertView alloc] initWithTitle:GDLocalizedString(@"管理帐号") message:GDLocalizedString(@"修改帐号信息") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"修改"),GDLocalizedString(@"切换"),GDLocalizedString(@"退出"), nil];
    alertView.tag = 701;
    [alertView show];
}


//alertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==700&&buttonIndex==1) {
        SQLDataBase * sql =[[SQLDataBase alloc] init];
        [sql deleteData];
        //未登录的情况
        [self didNotLogin];
    }
    //修改
    else if (alertView.tag ==701 && buttonIndex ==1)
    {
        //Storyboard跳转
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ModifyViewController *next = [board instantiateViewControllerWithIdentifier:@"ModifyView"];
        [self.navigationController hidesBottomBarWhenPushed];
        [self.navigationController pushViewController:next animated:YES];
    }
    //切换
    else if (alertView.tag ==701 && buttonIndex ==2)
    {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        
    }
    //退出
    else if (alertView.tag ==701 && buttonIndex ==3)
    {
        //上传关注的频道列表
        [PindaoCacher uploadToNetwork];
        
        SQLDataBase * sql =[[SQLDataBase alloc] init];
        [sql deleteData];
        //未登录的情况
        [self didNotLogin];
        [NotifyCenter sendLoginStatus:nil];
        
        //匿名登录
        [NetRequest requestUdidInfo];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//由于我的动态位置被我的卡包替换而修改  ,此代理方法 是处理我的卡包
#pragma mark -- MyTableViewMessageCellDelegate
- (void)myTableViewMessageCell:(MyTableViewMessageCell *)cell clickedMyDynamicButton:(UIButton *)button {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    MyCardPkgTableViewController *mcptVc=[[MyCardPkgTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    mcptVc.title = GDLocalizedString(@"我的卡包");
    mcptVc.hidesBottomBarWhenPushed=YES;
    
    
    UIView *rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,40,30)];
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"wallet_tips_ico_normal.png"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(clickMsg) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.frame = CGRectMake(0,0,32,32);
    [rightView addSubview:imageBtn];
    
    _numLabel=[[UILabel alloc] initWithFrame:CGRectMake(22, 2, 13, 13)];

    if (_unReadCount>0) {
        _numLabel.backgroundColor=[UIColor redColor];
        _numLabel.text=[NSString stringWithFormat:@"%d",_unReadCount];
    }
    _numLabel.textAlignment=UITextAlignmentCenter;
    _numLabel.font=[UIFont systemFontOfSize:10];
    _numLabel.textColor=[UIColor whiteColor];
    [_numLabel.layer setMasksToBounds:YES];
    [_numLabel.layer setCornerRadius:5.0];
    [rightView addSubview:_numLabel];

    
    UIBarButtonItem *imageItem=[[UIBarButtonItem alloc] initWithCustomView:rightView];
    mcptVc.navigationItem.rightBarButtonItem=imageItem;
    
    [self.navigationController pushViewController:mcptVc animated:YES];
    
    
//
//    //删除feed_cnt
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"feed_cnt"];
//    
//    NSMutableArray *vcs = [NSMutableArray array];
//    
//    
//    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ZBTMyFeedTableVC *vc1 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
//    vc1.title = GDLocalizedString(@"@我的动态");
//    vc1.anyFeedStr = @"me";
//    ZBTMyFeedTableVC *vc2 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
//    vc2.title = GDLocalizedString(@"朋友动态");
//    vc2.anyFeedStr = @"friend";
//    ZBTMyFeedTableVC *vc3 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
//    NSString *vc3Title = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].unfocusName,GDLocalizedString(@"动态")];
//    vc3.title = vc3Title;
//    vc3.anyFeedStr = @"all";
//    [vcs addObject:vc1];
//    [vcs addObject:vc2];
//    [vcs addObject:vc3];
//    
//    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
//    sc.title = GDLocalizedString(@"动态");
//    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
//    sc.indicator.backgroundColor = UIColorWithMobanTheme;
//    
//    sc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:sc animated:YES];
}





-(void)clickMsg{
    
    _numLabel.text=@"";
    _unReadCount=0;
    _numLabel.backgroundColor=[UIColor clearColor];
    
    self.myDynamicTipNum=0;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    MyMsgBoxTableViewController *mmbtvc=[[MyMsgBoxTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    mmbtvc.title=@"消息盒子";
    mmbtvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:mmbtvc animated:YES];
    
    
}


-(void)handleMyDynamic{
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    //删除feed_cnt
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"feed_cnt"];
    
    NSMutableArray *vcs = [NSMutableArray array];
    
    
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZBTMyFeedTableVC *vc1 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
    vc1.title = GDLocalizedString(@"@我的动态");
    vc1.anyFeedStr = @"me";
    ZBTMyFeedTableVC *vc2 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
    vc2.title = GDLocalizedString(@"朋友动态");
    vc2.anyFeedStr = @"friend";
    ZBTMyFeedTableVC *vc3 = [board instantiateViewControllerWithIdentifier:@"ZBTMyFeedTableVC"];
    NSString *vc3Title = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].unfocusName,GDLocalizedString(@"动态")];
    vc3.title = vc3Title;
    vc3.anyFeedStr = @"all";
    [vcs addObject:vc1];
    [vcs addObject:vc2];
    [vcs addObject:vc3];
    
    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    sc.title = GDLocalizedString(@"动态");
    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    sc.indicator.backgroundColor = UIColorWithMobanTheme;
    
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)myTableViewMessageCell:(MyTableViewMessageCell *)cell clickedMyTalkButton:(UIButton *)button {

    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    NSMutableArray *vcs = [NSMutableArray array];
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyMsgTableVC *vc1 = [[MyMsgTableVC alloc] initWithStyle:UITableViewStylePlain];
    vc1.title = GDLocalizedString(@"私信");
    
    FriendViewController *vc2 = [board instantiateViewControllerWithIdentifier:@"FriendViewController"];
    vc2.title = GDLocalizedString(@"通讯录");
    
    NearbyUsersViewController *vc3 = [board instantiateViewControllerWithIdentifier:@"NearbyUsersViewController"];
    vc3.title = GDLocalizedString(@"附近的人");
    
    [vcs addObject:vc1];
    [vcs addObject:vc2];
    [vcs addObject:vc3];
    JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    sc.title = GDLocalizedString(@"聊天");
    sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    sc.indicator.backgroundColor = UIColorWithMobanTheme;
    
    sc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加人_附近的人.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchUser)];
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}


- (void)searchUser {
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchUserViewController *vc = [board instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
