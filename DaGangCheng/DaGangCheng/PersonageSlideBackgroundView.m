//
//  PersonageSlideBackgroundView.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageSlideBackgroundView.h"
#import "NetRequest.h"
#import "ApiUrl.h"
#import "SQLDataBase.h"
#import "HuaxoUtil.h"
#import "TimeUtil.h"
#import "UIButton+WebCache.h"
#import "ZBTUrlCacher.h"
#import "UploadImage.h"
#import "HudUtil.h"


#import "ZbtUserPm.h"


#import "MJExtension.h"

#import "CustomWindow.h"

@implementation PersonageSlideBackgroundView

CustomWindow *customWindow;

UIButton *selectBtn;

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
    CGRect frame = self.frame;
    self.bg = [[UIImageView alloc] initWithFrame:frame];
    self.bg.image = [UIImage imageNamed:@"个人主页_人物背景_社区.png"];
    [self addSubview:self.bg];
    
    
    self.headBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, frame.size.height-98, 88, 88)];
    self.headBg.backgroundColor = [UIColor whiteColor];
    self.headBg.layer.cornerRadius = 44.0;
    self.headBg.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
    self.headBg.layer.borderWidth = 1;
    self.headBg.layer.masksToBounds = YES;
    [self addSubview:self.headBg];
    
    self.head = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.head.center = self.headBg.center;
    self.head.layer.cornerRadius = 40.0;
    self.head.layer.masksToBounds = YES;
    [self.head addTarget:self action:@selector(uploadTxClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.head];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(113, frame.size.height-49, 150, 17)];
    self.name.font = [UIFont systemFontOfSize:16];
    self.name.textColor = [UIColor whiteColor];
    [self addSubview:self.name];
    
    
    self.prohibitBtn = [[UIButton alloc] initWithFrame:CGRectMake(DeviceWidth-20-66, frame.size.height-49, 66,20)];
    [self.prohibitBtn setBackgroundColor:UIColorWithMobanTheme];
    [self.prohibitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.prohibitBtn addTarget:self action:@selector(prohibitHandle) forControlEvents:UIControlEventTouchUpInside];
    self.prohibitBtn.hidden=YES;
    self.prohibitBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.prohibitBtn];
    
    
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, frame.size.height-27, 150, 13)];
    self.msgLabel.font = [UIFont systemFontOfSize:12];
    self.msgLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.msgLabel];
    
    
//    self.recommendIco = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth - 75, 0, 75, 18)];
//    self.recommendIco.image = [UIImage imageNamed:@"关注相同频道_推荐_社区.png"];
//    [self addSubview:self.recommendIco];
    //
    [self getUserInfoCacher];
    
    
//    [self getUserProhibiData];
    
    [self requestUserInfo];
    
    
    [self showProhibiBtn];
}




-(void)showProhibiBtn{
    
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr]};
    
    [request urlStr:[ApiUrl getUserPm] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        BOOL flag=false;
        if ([customDict[@"ret"] integerValue]) {
            
            
            NSDictionary *dict2 =customDict;
            
            ZbtUserPm   *tempZbtUserPm = [ZbtUserPm objectWithKeyValues:dict2];
            
            if ([tempZbtUserPm.pm intValue]==1) {
                flag=true;
            }
            if ([tempZbtUserPm.pm intValue]==2) {
//                if ([tempZbtUserPm.kind_ids[0][@"kind_id"]  intValue]==0) {
                    flag=true;
//                }
            }
            
        }
        if (flag) {
                [self.prohibitBtn setHidden:NO];
        }
    }];

}


-(void)prohibitHandle{
    
   NSString *title=self.prohibitBtn.titleLabel.text;
    
    if ([title isEqualToString:@"禁言"]) {
        
         [self showDialog:self.name.text];
//        
//        [self showDialog];
    }else{
        NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
        NetRequest * request =[NetRequest new];
        NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                     @"app_uid":self.userId,
                                     @"app_kind":appKind
                                     };
        
        [request urlStr:[ApiUrl getProhibitTalkCancel] parameters:parmeters passBlock:^(NSDictionary *customDict) {
            if ([customDict[@"ret"] integerValue]) {
                [HudUtil showTextDialog:@"取消禁言成功" view:self showSecond:1];
                [self.prohibitBtn setTitle:@"禁言" forState:UIControlStateNormal];
            }else{
                [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
            }
        }];
    }
}


//-(void)getUserProhibiData{
//    
//    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
//    NetRequest * request =[NetRequest new];
//    NSDictionary * parmeters = @{@"uid": self.userId,
//                                 @"app_kind":appKind
//                                };
//    
//    [request urlStr:[ApiUrl getProhibitTalkYesOrNo] parameters:parmeters passBlock:^(NSDictionary *customDict) {
//        if ([customDict[@"ret"] integerValue]) {
//            self.prohibitBtn.hidden=NO;
//            [self.prohibitBtn setTitle:@"禁言" forState:UIControlStateNormal];
//        }else{
//            [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
//        }
//    }];
//    
//}


- (void)getUserInfoCacher {
    ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];
    NSDictionary *dic = [urlCacher queryByUrlStr:[self urlCacherStr]];
    [self showUserInfo:dic];
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

        if(![customDict[@"ret"] intValue])
        {
            NSLog(@"get user-info failed!msg:%@",customDict[@"msg"]);
            return ;
        }

        //缓存
        ZBTUrlCacher *urlCacher = [[ZBTUrlCacher  alloc] init];
        [urlCacher insertUrlStr:[self urlCacherStr] andJson:customDict];
        
        [self showUserInfo:customDict];
    }];
}

- (void)showUserInfo:(NSDictionary *)info {
    //名字
    self.name.text = info[@"name"];
    
    if ([info[@"disabletalk"] intValue]!=0) {
       [self.prohibitBtn setTitle:@"取消禁言" forState:UIControlStateNormal];
    }else{
       [self.prohibitBtn setTitle:@"禁言" forState:UIControlStateNormal];
    }

    
    //时间
    self.msgLabel.text = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"最近在线"), [TimeUtil getFriendlyTime: (NSNumber*)info[@"last_time"]]];
    //头像
    long imageID = [(NSNumber *)info[@"tx_id"] integerValue];
    [self.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:160]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#uid:%@#to_uid:%@",[ApiUrl userInfoXQUrlStr],[HuaxoUtil getUdidStr],self.userId];
    return Id;
}

#pragma mark - 修改头像
- (void)uploadTxClicked
{
    if ([self.userId isEqualToString:[HuaxoUtil getUdidStr]]) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:GDLocalizedString(@"上传新的个人头像") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:GDLocalizedString(@"相册上传"),GDLocalizedString(@"拍照上传"), nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self pickPhotoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex==1){
        
        [self pickPhotoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)pickPhotoWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //判断设备的相机模式是否可用
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.myVC presentViewController:picker animated:YES completion:nil];
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
    [self.myVC dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  上传头像到服务器
 */
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
    [request urlStr:[ApiUrl setMyTouxiangUrl] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         BOOL ret = [customDict[@"ret"] intValue];;
         if(ret)
         {
             [HuaxoUtil showMsg:customDict[@"msg"] title:@""];
             [sql updateValue:imageId key:@"img_id"];
             
             SQLDataBase * sql =[[SQLDataBase alloc] init];
             NSDictionary * aDic =[sql query];
             NSLog(@"%@", aDic);
             long imageID = [aDic[@"img_id"] integerValue];
             //头像
             [self.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:160]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"用户更改头像" object:nil userInfo:aDic];
         }else{
             NSString* msg= customDict[@"msg"];
             [HuaxoUtil showMsg:msg title:@""];
         }
     }];
}







-(void)showDialog:(NSString *)userName{
    
    CGFloat viewWidth=260;
    CGFloat viewHeight=250;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake( (DeviceWidth-viewWidth)/2, (DeviceHeight-viewHeight)/2,viewWidth,viewHeight)];
    view.layer.masksToBounds=YES;
    [view.layer setCornerRadius:5.0];
    
    
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 48)];
    headerView.backgroundColor=UIColorWithMobanTheme;
    
    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 210, 48)];
    titleLable.text=@"禁言";
    titleLable.font=[UIFont systemFontOfSize:18];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.adjustsFontSizeToFitWidth = YES;
    [headerView addSubview:titleLable];
    
    
    UIButton  *closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame), 8, 32,32)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeBtn];
    
    
    [view addSubview:headerView];
    
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0,48, viewWidth,viewHeight-48)];
    contentView.backgroundColor=[UIColor whiteColor];
    
    UILabel *userLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 36)];
    userLable.text=@"用       户";
    userLable.font=[UIFont systemFontOfSize:14];
    userLable.textColor=UIColorFromRGB(0x32373e);
    [contentView addSubview:userLable];
    
    UILabel *showLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLable.frame)+5, 0, 100, 36)];
    showLable.text=userName;
    showLable.font=[UIFont systemFontOfSize:14];
    showLable.textColor=UIColorFromRGB(0x32373e);
    showLable.adjustsFontSizeToFitWidth = YES;
    [contentView addSubview:showLable];
    
    
    
    UILabel *lineLable=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(showLable.frame),viewWidth-20, 1)];
    lineLable.backgroundColor=UIColorFromRGB(0xdcdddd);
    [contentView addSubview:lineLable];
    
    
    
    UILabel *timeLable=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineLable.frame), 70, 48)];
    timeLable.text=@"禁言时间";
    timeLable.font=[UIFont systemFontOfSize:14];
    timeLable.textColor=UIColorFromRGB(0x32373e);
    [contentView addSubview:timeLable];
    
    
    NSArray *timeArray=[NSArray arrayWithObjects:@"1天",@"3天",@"1个星期",@"1个月",@"永久", nil];
    int linenum =(int)(timeArray.count%2==0?timeArray.count/2:(timeArray.count/2)+1);
    UIView *timeView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLable.frame)+5, CGRectGetMaxY(lineLable.frame)+5,viewWidth-110, linenum*35)];
    
    for (int i=0; i<timeArray.count; i++) {
        
        int row=i/2;
        int lie=i%2;
        
        CGFloat x=80*lie;
        CGFloat y=35*row+5;
        
        UIButton *oneDayBtn=[[UIButton alloc] initWithFrame:CGRectMake(x,y, 70, 28)];
        
        [oneDayBtn.layer setMasksToBounds:YES];
        [oneDayBtn setTitleColor:UIColorFromRGB(0x32373e) forState:UIControlStateNormal];
        [oneDayBtn.layer setBorderWidth:1.0];
        [oneDayBtn.layer setBorderColor:[UIColorFromRGB(0xdcdddd) CGColor]];
        [oneDayBtn.layer setCornerRadius:12.0];
        [oneDayBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [oneDayBtn setTitle:timeArray[i] forState:UIControlStateNormal];
        [oneDayBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        oneDayBtn.tag=100+i;
        if (i==0) {
            [self selectTime:oneDayBtn];
        }
        [timeView addSubview:oneDayBtn];
        
    }
    
    [contentView addSubview:timeView];
    
    
    
    UILabel *line2Lable=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeView.frame)+5,viewWidth-20, 1)];
    line2Lable.backgroundColor=UIColorFromRGB(0xdcdddd);
    [contentView addSubview:line2Lable];
    
    
    
    UIButton *okBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(line2Lable.frame)+5, viewWidth-20, 36)];
    [okBtn.layer setMasksToBounds:YES];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn.layer setCornerRadius:5.0];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setBackgroundColor:UIColorWithMobanTheme];
    [contentView addSubview:okBtn];
    [view addSubview:contentView];
    
    customWindow = [[CustomWindow alloc]initWithView:view];
    
    [customWindow show];
}



-(void)selectTime:(UIButton *)btn{
    if (selectBtn) {
        [selectBtn.layer setBorderColor:[UIColorFromRGB(0xdcdddd) CGColor]];
    }
    [btn.layer setBorderColor:[UIColorWithMobanTheme CGColor]];
    selectBtn=btn;
}



-(int)getMinuteBySelectTag{
    int result;
    switch (selectBtn.tag) {
        case 100:
            result=24*60;
            break;
        case 101:
            result=3*24*60;
            break;
        case 102:
            result=7*24*60;
            break;
        case 103:
            result=30*24*60;
            break;
        case 104:
            result=3000*24*60;
            break;
    }
    return result;
}

//禁言请求
-(void)clickOk{
    
    int timeMin=[self getMinuteBySelectTag];
    
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"app_uid":self.userId,
                                 @"app_kind":appKind,
                                 @"user_name": self.name.text,
                                 @"disable_time":@(timeMin),
                                 @"msg":@""
                                 };
    
    [request urlStr:[ApiUrl getProhibitTalk] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        if ([customDict[@"ret"] integerValue]) {
            [self closeDialog];
            [HudUtil showTextDialog:customDict[@"msg"] view:self showSecond:1];
            [self.prohibitBtn setTitle:@"取消禁言" forState:UIControlStateNormal];
        }else{
            [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
        }
    }];
    
    
    
}


-(void)closeDialog{
    
    [customWindow close];
    customWindow.hidden = true;
}

@end