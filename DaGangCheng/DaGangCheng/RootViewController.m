//
//  RootViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "RootViewController.h"
#import "NotifyCenter.h"
#import "NetRequest.h"
#import "LoginViewController.h"

#import "HotNavigationController.h"
#import "PlateTableViewController.h"
#import "MyTableViewController.h"
#import "NewPostViewController.h"
#import "ZBSuperCSTabVC.h"
#import "ZBSuperCS.h"
#import "UpdateSoftware.h"
#import "AboutViewController.h"

#import "ZYLocationManager.h"
#import "ZBWaterfallVC.h"
#import "ZBAppSetting.h"
#import "PostLockedSQL.h"
#import "ZBTUrlCacher.h"

#import "ZBAppSetting.h"
#import "ZBPostJumpTool.h"
#import "ZBCoreTextViewController.h"

#import "NewLoginContoller.h"

#import "ZBTUIWebViewController.h"

@interface RootViewController ()<UpdateSoftwareDelegate>
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) NSInteger oldIndex;

@property (assign, nonatomic) BOOL isAutorotate;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self initSubviews];
    }
    return self;  
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    //self.navigationController.navigationBar setBarTintColor:<#(UIColor *)#>
    [[UINavigationBar appearance] setBarTintColor:UIColorWithMobanTheme];
    [[UITabBar appearance] setTintColor:UIColorWithMobanTheme];
    
    //webView视频播放通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoStartedFullscreen:)name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"object:nil];// 播放器即将播放通知
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoFinishedFullscreen:)name:@"UIMoviePlayerControllerWillExitFullscreenNotification"object:nil];// 播放器即将退出通知
    
    //tab
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    
    NSArray *tabs = [[ZBAppSetting standardSetting] tabs];
    if (!tabs || [tabs count]==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"应用配置信息出错，请设置底部Tab！") delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
        [av show];
        return;
    }
    for (int i=0; i<[tabs count]; i++) {
        ZBTab *tab = tabs[i];
        UINavigationController *navi = nil;
        
        NSInteger Id = tab.ID;
        NSString *name = tab.name;
        NSString *imgStr = tab.imgName;
        NSString *imgSeletedStr = tab.imgNameSelected;
        NSDictionary *page = tab.page;

        switch (Id) {
            case 0:
            {
                HotNavigationController *hotNavi = [[HotNavigationController alloc] init];
                navi = hotNavi;
                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[UIImage imageNamed:imgStr] selectedImage:[UIImage imageNamed:imgSeletedStr]];
            }
                break;
            case 1:
            {
                PlateTableViewController *plateVC = [[PlateTableViewController alloc] initWithStyle:UITableViewStylePlain];
                plateVC.title = name;
                UINavigationController *plateNavi = [[UINavigationController alloc] initWithRootViewController:plateVC];
                navi = plateNavi;
                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[UIImage imageNamed:imgStr] selectedImage:[UIImage imageNamed:imgSeletedStr]];
            }
                break;
            case 2:
            {
                MyTableViewController *myVC = [[MyTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                myVC.title = name;
                UINavigationController *myNavi = [[UINavigationController alloc] initWithRootViewController:myVC];
                navi = myNavi;
                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[UIImage imageNamed:imgStr] selectedImage:[UIImage imageNamed:imgSeletedStr]];
            }
                break;
            case 3:
            {
                
                
                UIViewController *postVC = [[UIViewController alloc] init];
                postVC.title = name;
                postVC.view.backgroundColor = [UIColor whiteColor];
                UINavigationController *postNavi = [[UINavigationController alloc] initWithRootViewController:postVC];
                navi = postNavi;
                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:nil selectedImage:nil];
                
                [self addButtonWithImage:[UIImage imageNamed:imgStr] highlightImage:[UIImage imageNamed:imgSeletedStr] numOfBtns:[tabs count] index:i];
                
            }
                break;
            case 4:
            {
                ZBWaterfallVC *waterVC = [[ZBWaterfallVC alloc] init];
                waterVC.title = name;

                if ([page isKindOfClass:[NSDictionary class]] && [page[@"kind_id"] isKindOfClass:[NSString class]]) {
                    NSInteger kindId = [page[@"kind_id"] integerValue];
                    waterVC.pindaoId = [NSString stringWithFormat:@"%ld",(long)kindId];
                }
                
                UINavigationController *waterNavi = [[UINavigationController alloc] initWithRootViewController:waterVC];
                navi = waterNavi;
                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[UIImage imageNamed:imgStr] selectedImage:[UIImage imageNamed:imgSeletedStr]];
            }
                break;
            case 5:
            {
//                ZBSuperCSTabVC *csVC = [[ZBSuperCSTabVC alloc] init];
//                
//                csVC.title = name;
//                csVC.isShowTitle =[page[@"isShowTitle"] boolValue];
//                csVC.isShowBall = [page[@"isShowBall"] boolValue];
//                
//                //@"http://cs.opencom.cn/5RGCq"
//                csVC.urlStr = page[@"url"];
//                
//                UINavigationController *csNavi = [[UINavigationController alloc] initWithRootViewController:csVC];
//                navi = csNavi;
//                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[UIImage imageNamed:imgStr] selectedImage:[UIImage imageNamed:imgSeletedStr]];
                
                
                
                ZBTUIWebViewController *zbtCsVc=[[ZBTUIWebViewController alloc] init];
                 zbtCsVc.isShowTitle =[page[@"isShowTitle"] boolValue];
                zbtCsVc.isShowBall=[page[@"isShowBall"] boolValue];
                zbtCsVc.webViewUrl=page[@"url"];
                
                UINavigationController *csNavi = [[UINavigationController alloc] initWithRootViewController:zbtCsVc];
                csNavi.navigationBarHidden=YES;
                
                navi = csNavi;
                
                navi.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:[UIImage imageNamed:imgStr] selectedImage:[UIImage imageNamed:imgSeletedStr]];
                
                
            }
                break;
            default:
                break;
        }
        
        [vcs addObject:navi];
    }
    
    [self setViewControllers:[vcs copy]];
}

- (void)videoStartedFullscreen:(id)sender {
    self.isAutorotate = YES;
}

- (void)videoFinishedFullscreen:(id)sender {
    self.isAutorotate = NO;
}

//
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation != UIInterfaceOrientationMaskPortraitUpsideDown);
    
}

- (BOOL)shouldAutorotate

{
    if (self.isAutorotate) {
        return YES;
    }
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    if (self.isAutorotate) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
    
}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [self initSubviews];
    
    //只执行一次
    static BOOL isFirst = YES;
    if (isFirst) {
        
        //启动用户动态通知
        [[[NotifyCenter alloc]init] startUserNewsNotify];
        
        //获取匿名
        [NetRequest requestUdidInfo];
        

        //请求配置
        [ZBAppSetting requestJson];

        //清除查看帖子的缓存
        PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
        [pSql removeCacher];
        
        // 请求是否有频道分类
        [self requestPindaoKinds];
        
        isFirst = NO;
    }
    
}



#pragma mark 只在init 的时候调用一次，viewWillAppear 每次进入都会调用
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tabBar addSubview:self.btn];

    //检查更新
    UpdateSoftware *updateSoftware = [[UpdateSoftware alloc] initWithFrame:CGRectZero];
    updateSoftware.delegate = self;
    [updateSoftware start];
    [self.view addSubview:updateSoftware];
    
    //获取定位
    [[ZYLocationManager sharedZYLocationManager] getLocationCoordinate:^(CLLocationCoordinate2D coor) {
        [ZBAppSetting standardSetting].latitude = coor.latitude;
        [ZBAppSetting standardSetting].longitude = coor.longitude;
    } address:^(NSString *address) {
        [ZBAppSetting standardSetting].address = address;
    }];
    
#warning todo
    //测试
//    ZBCoreTextViewController *vc = [[ZBCoreTextViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark UpdateSoftware
- (void)updateSoftwareDidClickedUpdateBtn {
    
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    aboutVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStylePlain target:aboutVC action:@selector(back:)];
    [aboutVC.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    aboutVC.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.oldIndex != self.selectedIndex) {
        self.oldIndex = self.selectedIndex;
    }else {
        if ([viewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)viewController topViewController] isMemberOfClass:[ZBSuperCSTabVC class]]) {
            ZBSuperCSTabVC *vc = (ZBSuperCSTabVC *)[(UINavigationController *)viewController topViewController];
            [vc.webView reload];
        }
    }
    
    
    [viewController.tabBarItem setBadgeValue:nil];
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage numOfBtns:(NSInteger)num index:(NSInteger)index
{
    if (index>4) {
        return;
    }
    num = num>5?5:num;
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, DeviceWidth/num, buttonImage.size.height);
    [button setImage:[buttonImage imageWithMobanThemeColor] forState:UIControlStateNormal];
    [button setImage:[highlightImage imageWithMobanThemeColor] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    CGPoint p = CGPointMake(DeviceWidth/(num*2)+(DeviceWidth/num)*index, 0);
    if (heightDifference < 0) {
        p.y = self.tabBar.frame.size.height/2.0;
        button.center = p;
    }
    else
    {
        p.y = self.tabBar.frame.size.height/2.0;
        p.y = p.y - heightDifference/2.0;
        button.center = p;
    }
    
    [self.tabBar addSubview:button];
    self.btn = button;
}

- (void)clickBtn:(UIButton *)sender {
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
        [NewLoginContoller tologinWithVC:self];
        return;
    }
    
    NewPostViewController *postVC = [[NewPostViewController alloc] init];
    postVC.title = GDLocalizedString(@"发帖");
    postVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:postVC action:@selector(back:)];
    [postVC.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
    postVC.hidesBottomBarWhenPushed = YES;
    UINavigationController *postNavi = [[UINavigationController alloc] initWithRootViewController:postVC];
    [self presentViewController:postNavi animated:NO completion:nil];
}

#pragma mark - 获取频道分类信息
- (void)requestPindaoKinds
{
    ZBTUrlCacher *cacher = [[ZBTUrlCacher alloc] init];
    NSDictionary *dic = [cacher queryByUrlStr:[ApiUrl getPindaoKinds]];
    if (![dic[@"ret"] integerValue]) {
        [ZBAppSetting standardSetting].openPindaoKind = NO;
    } else {
        [ZBAppSetting standardSetting].openPindaoKind = YES;
    }
    
    NSDictionary * parameters = @{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"op":@"class_list"
                                  };
    
    [NetRequest urlStr:[ApiUrl getPindaoKinds] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *customDict = responseObject;
        
        if (!customDict[@"ret"]) return;
        
        ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];
        [urlCacher insertUrlStr:[ApiUrl getPindaoKinds] andJson:customDict];
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            [ZBAppSetting standardSetting].openPindaoKind = NO;
            
        } else {
        
            [ZBAppSetting standardSetting].openPindaoKind = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
