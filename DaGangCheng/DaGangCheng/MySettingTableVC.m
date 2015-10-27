//
//  MySettingTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-18.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MySettingTableVC.h"
#import <ShareSDK/ShareSDK.h>
#import "ApiUrl.h"
#import "MBProgressHUD.h"
#import "ZBCheckVersion.h"
#import "Praise.h"
#import "ZBSelectLanguageTableVC.h"
#import "UITableView+separator.h"

@interface MySettingTableVC ()<ISSShareViewDelegate,UIAlertViewDelegate>
@property (nonatomic, copy) NSString *versionURlString;
@end

@implementation MySettingTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"设置");
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f5f6);
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    self.tableView.rowHeight = [MyTableViewCell heightWithCell];
    [self.tableView setContentInset:UIEdgeInsetsMake(-20, 0, 20, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    ZBAppSetting *appSetting = [ZBAppSetting standardSetting];
    if (appSetting.isOpenLanguages) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }else if (section==1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    if (indexPath.section == 0 && indexPath.row == 0) {

        cell.imageView.image = [UIImage imageNamed:@"my_分享应用.png"];
        cell.textLabel.text = GDLocalizedString(@"分享应用");
    }
//    else if (indexPath.section == 0 && indexPath.row == 1) {
//        //cell.imageView.image = [UIImage imageNamed:@"关于应用2.png"];
//        //cell.textLabel.text = @"检查最新版本";
//    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.imageView.image = [UIImage imageNamed:@"my_清除图片缓存.png"];
        cell.textLabel.text = GDLocalizedString(@"清除图片缓存");

    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        cell.imageView.image = [UIImage imageNamed:@"my_清除语音缓存.png"];
        cell.textLabel.text = GDLocalizedString(@"清除语音缓存");
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:@"关于应用2.png"];
        cell.textLabel.text = GDLocalizedString(@"多语言");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self shareMyApp];
    }
//    else if (indexPath.section == 0 && indexPath.row == 1) {
//        [self checkVersion];
//    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        [self removeCache];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        [self removeCache];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        [self selectLanguage];
    }
}

//检查更新
- (void)checkVersion {
    [self check];
}

- (void)shareMyApp {
    NSString *appLogoIDStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_logo"];
    NSString *imageUrl = [ApiUrl getImageUrlStrFromID:[appLogoIDStr integerValue] w:100];
    
    NSString *desc = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"share_tips"];
    if (desc.length>80) {
        desc = [desc substringToIndex:80];
    }
    
    
    

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:desc
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageUrl]
                                                title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"]
                                                  url:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"down_url"]
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    //自定义标题栏相关委托
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    //自定义标题栏相关委托
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"分享"
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:self
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //创建自定义分享列表
//    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeWeixiFav,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeSMS,ShareTypeRenren,ShareTypeYiXinSession,ShareTypeYiXinTimeline,ShareTypeYouDaoNote,ShareTypeMail, nil];

    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeQQSpace,ShareTypeSinaWeibo,nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    [Praise hudShowTextOnly:GDLocalizedString(@"分享成功") delegate:self];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    [Praise hudShowTextOnly:[NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"分享失败"),[error errorDescription]] delegate:self];
                                }
                            }];
    
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType

{
    
    //修改分享编辑框的标题栏颜色
    viewController.navigationController.navigationBar.barTintColor = UIColorWithMobanTheme;
    
    //将分享编辑框的标题栏替换为图片
    //    UIImage *image = [UIImage imageNamed:@"iPhoneNavigationBarBG.png"];
    //    [viewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

//清理缓存
- (void)removeCache {
    NSLog(@"清理缓存");
    NSString *cachesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSLog(@"caches path %@",cachesPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filesPath = [fileManager contentsOfDirectoryAtPath:cachesPath error:nil];
    for (int i=0; i<filesPath.count; i++) {
        NSString *filePath = [cachesPath stringByAppendingPathComponent:filesPath[i]];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = GDLocalizedString(@"缓存已清空");
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

- (void)check {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    [ZBCheckVersion netRequestAppstoreVersionPassBlock:^(NSDictionary *customDict) {
        
        NSDictionary *dic = customDict;
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            
            if (![lastVersion isEqualToString:currentVersion]) {
                NSString *msg = [NSString stringWithFormat:@"最新版本为%@,是否更新？",lastVersion];
                self.versionURlString = [[releaseInfo objectForKey:@"trackViewUrl"] copy];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:msg delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即更新",nil];
                alert.tag = 10000;
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 10001;
                [alert show];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            if(self.versionURlString)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionURlString]];
            }
        }
    }
}

/**
 *  多语言
 */
- (void)selectLanguage {
    ZBSelectLanguageTableVC *next = [[ZBSelectLanguageTableVC alloc] initWithStyle:UITableViewStylePlain];
    next.hidesBottomBarWhenPushed = YES;
    next.title = GDLocalizedString(@"多语言");
    next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
    [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
    [self presentViewController:navi animated:YES completion:Nil];
}
@end
