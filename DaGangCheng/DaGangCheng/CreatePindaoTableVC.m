//
//  CreatePindaoTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "CreatePindaoTableVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "RecommendPindaoTableCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "HuaxoUtil.h"
#import "UIButton+WebCache.h"
#import "SelectLocationTVC.h"
#import "Pindao.h"
#import "PindaoSettingTableVC.h"
#import "ZBAppSetting.h"
#import "Praise.h"
#import "PindaoIndexViewController.h"
#import "PindaoSetting.h"
#import "UploadImage.h"


@interface CreatePindaoTableVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, SelectLocationDelegate, PindaoSettingDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger settingValue;
@property (nonatomic, assign) long pindaoImageID;
@end

@implementation CreatePindaoTableVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    NSString *pindaoIcoLabTitle = [NSString stringWithFormat:@"%@%@", [ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"图标")];
    self.pindaoIcoLab.text =pindaoIcoLabTitle;
    NSString *pindaoNameLabTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"名称")];
    self.pindaoNameLab.text = pindaoNameLabTitle;
    NSString *pindaoSettingLabTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"设定")];
    self.pindaoSettingLab.text = pindaoSettingLabTitle;
    NSString *pindaoDescHitLabTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"简介")];
    self.pindaoDescHiteLab.text = pindaoDescHitLabTitle;
    NSString *pindaoNameTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"名称")];
    self.pindaoName.placeholder = pindaoNameTitle;
    
    self.pindaoAddrLabel.text = GDLocalizedString(@"所在位置");
    
    self.createPindaoBtn.backgroundColor = UIColorWithMobanTheme;
    [self.createPindaoBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateNormal];
    self.createPindaoBtn.layer.cornerRadius = 2;
    self.createPindaoBtn.layer.masksToBounds = YES;
    NSString *createPindaoBtnTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"创建"),[ZBAppSetting standardSetting].pindaoName];
    [self.createPindaoBtn setTitle:createPindaoBtnTitle forState:UIControlStateNormal];
    if (self.pindaoMode == PindaoModeEditingPindao) {
        [self.createPindaoBtn addTarget:self action:@selector(requestEditPindao) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.createPindaoBtn addTarget:self action:@selector(requestCreatePindao) forControlEvents:UIControlEventTouchUpInside];
    }

    
    self.pindaoDesc.delegate = self;
    self.pindaoDescHite.enabled = NO;
    self.pindaoDescHite.textColor = UIColorFromRGB(0xd3d3d6);
    self.pindaoDescHite.alpha = 0.5;
    self.pindaoDescHite.backgroundColor = [UIColor clearColor];
    NSString *pindaoDescHiteTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"简介")];
    self.pindaoDescHite.text = pindaoDescHiteTitle;
    
    if (self.pindao && self.pindaoMode == PindaoModeSeePindaoInfo) {
        //显示频道信息
        NSString *title = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"信息")];
        self.title = title;
        self.createPindaoBtn.hidden = YES;
        self.pindaoName.userInteractionEnabled = NO;
        self.pindaoDesc.userInteractionEnabled = NO;
        self.pindaoDescHite.hidden = YES;
        [self showPindaoInfo];
    } else if (self.pindao && self.pindaoMode == PindaoModeEditingPindao) {
        //编辑频道
        NSString *title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"编辑"),[ZBAppSetting standardSetting].pindaoName];
        self.title = title;
        [self.createPindaoBtn setTitle:GDLocalizedString(@"保存") forState:UIControlStateNormal];
        [self showPindaoInfo];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void) hideKeyboard {
    [self.pindaoName resignFirstResponder];
    [self.pindaoDesc resignFirstResponder];
}

- (void)showPindaoInfo {
    [self setPindaoImageWithImageID:[self.pindao.imageId integerValue]];
    self.pindaoName.text = self.pindao.name;
    self.pindaoDesc.text = self.pindao.desc;
    self.pindaoDescHite.text = @"";
    self.pindaoAddr.text = self.pindao.addr;
    self.pindaoSettingLabel.text = [PindaoSetting pindaoSettingTitleByValue:self.pindao.statusValue];
    self.settingValue = self.pindao.statusValue;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self.pindaoName resignFirstResponder];
    [self.pindaoDesc resignFirstResponder];
    
    //查看信息
    if (self.pindao && self.pindaoMode == PindaoModeSeePindaoInfo) {
        return;
    }
    
    if (indexPath.section==0 && indexPath.row == 0) {
        [self pickPhoto:nil];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        PindaoSettingTableVC *vc = [[PindaoSettingTableVC alloc] init];
        NSString *title = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"设定")];
        vc.title = title;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SelectLocationTVC *vc = [board instantiateViewControllerWithIdentifier:@"SelectLocationTVC"];
        vc.title = GDLocalizedString(@"选择位置");
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 13;
}

- (void)SelectLocationTVC:(SelectLocationTVC *)tvc selectedLocation:(NSString *)location {
    self.pindaoAddr.text = location;
    
    if (self.pindaoMode == PindaoModeEditingPindao) {
        ZBAppSetting* appsetting = [ZBAppSetting standardSetting];
        self.pindao.gps_lng = appsetting.longitude;
        self.pindao.gps_lat = appsetting.latitude;
        self.pindao.addr = location;
    }
}

- (void)pindaoSettingTableVC:(PindaoSettingTableVC *)vc title:(NSString *)title value:(int)value {
    self.pindaoSettingLabel.text = title;
    self.settingValue = value;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.pindaoDesc) {

        if (textView.text.length == 0) {
            NSString *pindaoDescHiteTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"简介")];
            self.pindaoDescHite.text = pindaoDescHiteTitle;
        }else{
            self.pindaoDescHite.text = @"";
        }
    }
}

//创建频道
-(void)requestCreatePindao
{
    if (![HuaxoUtil isLogined]) {
        [Praise hudShowTextOnly:GDLocalizedString(@"您还未登录") delegate:self];
        return;
    }
    NetRequest * request =[NetRequest new];
    
    ZBAppSetting* appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    NSString *addr = self.pindaoAddr.text?self.pindaoAddr.text:@"";
    
    NSString *uid = [HuaxoUtil getUdidStr] ? [HuaxoUtil getUdidStr]: @"";
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    if (self.pindaoName.text.length<1) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"名")];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }
    
    if (self.pindaoDesc.text.length<1) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"简介")];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }

    if (self.pindaoImageID==0) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请选择"),[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"图片")];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }
    
    
    [self.createPindaoBtn setTitle:GDLocalizedString(@"创建中...") forState:UIControlStateNormal];
    NSDictionary * parmeters = @{@"uid": uid,
                                 @"name":self.pindaoName.text,
                                 @"desc":self.pindaoDesc.text,
                                 @"app_kind":app_kind,
                                 @"img_id":[NSString stringWithFormat:@"%ld", self.pindaoImageID],
                                 @"k_status":[NSString stringWithFormat:@"%ld",(long)self.settingValue],
                                 @"audio_id":@"",
                                 @"audio_len":@"",
                                 @"gps_lng": lng,
                                 @"gps_lat": lat,
                                 @"loc_addr":addr
                                 };
    
    [request urlStr:[ApiUrl createPindaoUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"创建失败"),customDict[@"msg"]] delegate:self];
            NSString *msgTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"创建"),[ZBAppSetting standardSetting].pindaoName];
            [self.createPindaoBtn setTitle:msgTitle forState:UIControlStateNormal];
            return ;
        }
        
        [self.createPindaoBtn setTitle:GDLocalizedString(@"创建成功") forState:UIControlStateNormal];
//        UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        PindaoIndexViewController *pindaoHome = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
//        pindaoHome.kind_id = [NSString stringWithFormat:@"%@", customDict[@"id"]];
//        pindaoHome.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:pindaoHome action:@selector(backVC)];
//        [pindaoHome.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:pindaoHome];
//        [self.navigationController presentViewController:navi animated:YES completion:nil];
    }];
}

//编辑频道
-(void)requestEditPindao
{
    if (![HuaxoUtil isLogined]) {
        [Praise hudShowTextOnly:GDLocalizedString(@"您还未登录") delegate:self];
        return;
    }
    
    if (!self.pindao.pindaoId) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"未知的"),[ZBAppSetting standardSetting].pindaoName];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }
    NetRequest * request =[NetRequest new];
    
    NSString *lng = [NSString stringWithFormat:@"%f",self.pindao.gps_lng];
    NSString *lat = [NSString stringWithFormat:@"%f",self.pindao.gps_lat];
    NSString *addr = self.pindao.addr?self.pindao.addr:@"";
    
    NSString *uid = [HuaxoUtil getUdidStr] ? [HuaxoUtil getUdidStr]: @"";
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    if (self.pindaoName.text.length<1) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"名")];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }
    
    if (self.pindaoDesc.text.length<1) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请输入"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"简介")];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }
    
    if (self.pindaoImageID==0) {
        NSString *msgTitle = [NSString stringWithFormat:@"%@%@%@",GDLocalizedString(@"请选择"),[ZBAppSetting standardSetting].pindaoName,GDLocalizedString(@"图片")];
        [Praise hudShowTextOnly:msgTitle delegate:self];
        return;
    }
    
    [self.createPindaoBtn setTitle:GDLocalizedString(@"保存中...") forState:UIControlStateNormal];
    NSDictionary * parmeters = @{@"id":self.pindao.pindaoId,
                                 @"uid": uid,
                                 @"name":self.pindaoName.text,
                                 @"desc":self.pindaoDesc.text,
                                 @"app_kind":app_kind,
                                 @"img_id":[NSString stringWithFormat:@"%ld", self.pindaoImageID],
                                 @"k_status":[NSString stringWithFormat:@"%ld",(long)self.settingValue],
                                 @"audio_id":@"",
                                 @"audio_len":@"",
                                 @"gps_edit":@"true",
                                 @"gps_lng": lng,
                                 @"gps_lat": lat,
                                 @"addr":addr
                                 };
    
    [request urlStr:[ApiUrl editPindaoUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"保存失败"),customDict[@"msg"]] delegate:self];
            NSString *msgTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"保存"),[ZBAppSetting standardSetting].pindaoName];
            [self.createPindaoBtn setTitle:msgTitle forState:UIControlStateNormal];
            return ;
        }
        
        [self.createPindaoBtn setTitle:GDLocalizedString(@"保存成功") forState:UIControlStateNormal];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


//选择频道图片

- (void)pickPhoto:(id)sender;
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)uploadImg:(UIImage*)img
{
    [UploadImage uploadWithImage:img completed:^(NSString *imageStr, NSError *error) {
        if (imageStr) {
            NSString *imgId = [imageStr substringWithRange:NSMakeRange(5, imageStr.length-6)];
            [self setPindaoImageWithImageID:[imgId integerValue]];
        }else {
            [HuaxoUtil showMsg:nil title:GDLocalizedString(@"图片上传失败")];
        }
    }];
}

-(void)setPindaoImageWithImageID:(long)imgID
{
    self.pindaoImageID = imgID;
    [self.pindaoImage sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imgID w:120]] placeholderImage:[UIImage imageNamed:@"默认频道图片_创建频道_社区.png"]];
}

- (void)dealloc {

}

@end
