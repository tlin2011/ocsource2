//
//  HotNavigationController.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "HotNavigationController.h"
#import "HotGeneralPindaoTableVC.h"
#import "ZBTSlideSegmentController.h"
#import "HotDotPindaoTableVC.h"
#import "HotPhotoPindaoTableVC.h"
#import "HotNewInteractionTableVC.h"
#import "HotActivityPindaoTableVC2.h"
#import "JYSlideSegmentController.h"

#import "NetRequest.h"
#import "ApiUrl.h"
#import "AFNetworking.h"
#import "NaviPindao.h"
#import "ArchiverAndUnarchiver.h"
#import "userStatusPhoto.h"
#import "ZBHtmlToApp.h"
#import "ScanViewController.h"


static NSString *dpfileName = @"DefaultPindaoListFile2";

@interface HotNavigationController ()<ScanViewControllerDelegate>
@property (nonatomic, strong) ZBTSlideSegmentController *slideSegmentController;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int slideSemgentStyle;
@end
@implementation HotNavigationController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self initData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initData];
    
//    UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    topTitle.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
//    topTitle.textAlignment = NSTextAlignmentCenter;
//    topTitle.userInteractionEnabled = YES;
//    self.navigationItem.titleView = topTitle;
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToTop)];
//    [self.navigationItem.titleView addGestureRecognizer:tapGR];
}

- (void)initData {
    [self getCacheData];
}

- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    
    NSMutableArray *totalArr = [[NSMutableArray alloc] init];
    [totalArr addObjectsFromArray:[NaviPindao unarchiverDisplayList]];
    [totalArr addObjectsFromArray:[NaviPindao unarchiverDeleteList]];

    if (totalArr.count >3) {
    
        NSArray *vcs = [self vcArrByArr:dataList];

        if (!self.slideSegmentController) {
            
            [self initSlideSegmentControllerWithvcs:vcs];
        }else{
            NSLog(@"ok");
        }
        self.slideSegmentController.viewControllers = vcs;
        [self.slideSegmentController reset];
        [self.slideSegmentController.segmentBar setNeedsDisplay];
    }else {
        NSArray *vcs = [self vcArrByArr:totalArr];
        
        JYSlideSegmentController *sc = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
        sc.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
        sc.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        sc.indicator.backgroundColor = UIColorWithMobanTheme;
        
        //sc.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:sc animated:YES];
        userStatusPhoto *status = [[userStatusPhoto alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        status.delegate = self;
        sc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:status];
        
        UIBarButtonItem *createPostBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"编辑_频道主页.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCreatePostBtn)];
        
        UIBarButtonItem *scanBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"二维码.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedScanBtn)];
        
        NSArray *scanArray=[[NSArray alloc] initWithObjects:createPostBtn,scanBtn,nil];
        
        sc.navigationItem.rightBarButtonItems=scanArray;
        
        
//        sc.navigationItem.rightBarButtonItem = createPostBtn;
        [self setViewControllers:@[sc]];
    }
}

/**
 *  跳转到发帖页面
 */
- (void)clickedCreatePostBtn {
    [ZBHtmlToApp toNewPostVCWithVC:self];
}

/**
 *  跳转到扫描页面
 */
- (void)clickedScanBtn {
    ScanViewController *svController=[[ScanViewController alloc] init];
    svController.delegate = self;
    [self presentViewController:svController animated:YES completion:nil];
}
#pragma mark -- scanViewControllerDelegate
- (void)scanViewController:(ScanViewController *)vc DidFinishedWithString:(NSString *)string {
    
    [ScanViewController resultDispalyByString:string viewController:self];
}


- (NSArray *)vcArrByArr:(NSArray *)arr {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSMutableArray *vcs = [NSMutableArray array];
    
    for (int i=0; i<[arr count]; i++) {
        NaviPindao *pindao = arr[i];
        if ([pindao.ID isEqualToString:@"1"]) {
            HotDotPindaoTableVC *vc = [[HotDotPindaoTableVC alloc] initWithStyle:UITableViewStylePlain];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID isEqualToString:@"2"]){
            HotNewInteractionTableVC *vc = [[HotNewInteractionTableVC alloc] init];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID isEqualToString:@"3"] ){
            //            HotNewInteractionTableVC *vc = [[HotNewInteractionTableVC alloc] init];
            //            vc.title = @"语音";
        } else if([pindao.ID isEqualToString:@"-1"]){

            HotActivityPindaoTableVC2 *vc = [[HotActivityPindaoTableVC2 alloc] init];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID isEqualToString:@"0"]){
            
            HotPhotoPindaoTableVC *vc = [[HotPhotoPindaoTableVC alloc] initWithStyle:UITableViewStylePlain];
            vc.title = pindao.name;
            [vcs addObject:vc];
        } else if([pindao.ID integerValue] <100) {
        } else{

            HotGeneralPindaoTableVC *vc = [[HotGeneralPindaoTableVC alloc] initWithStyle:UITableViewStylePlain];
            vc.title = pindao.name;
            vc.pindaoId = pindao.ID;
            [vcs addObject:vc];
        }
    }
    return vcs;
}

- (void)initSlideSegmentControllerWithvcs:(NSArray *)vcs {
    if ([vcs count]<=0) {
        return;
    }
    
    self.slideSegmentController = [[ZBTSlideSegmentController alloc] initWithViewControllers:vcs];
    self.slideSegmentController.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_name"];
    self.slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    
    self.slideSegmentController.pindolist = self.dataList;
    userStatusPhoto *status = [[userStatusPhoto alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    status.delegate = self;
    self.slideSegmentController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:status];
    
    UIBarButtonItem *createPostBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"编辑_频道主页.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedCreatePostBtn)];
    
    UIBarButtonItem *scanBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"二维码.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedScanBtn)];
    
    NSArray *scanArray=[[NSArray alloc] initWithObjects:createPostBtn,scanBtn,nil];
    
     self.slideSegmentController.navigationItem.rightBarButtonItems=scanArray;
    
    [self setViewControllers:@[self.slideSegmentController]];
}

-(void)requestNavigationPindao {
    
    NetRequest * request = [NetRequest new];
    
    NSString *appKind  = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary * parameters =@{@"s_ibg_kind":appKind,
                                 @"is_self":@""};
    [request urlStr:[ApiUrl navigationPindaoUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {

        if (!customDict[@"ret"]  ) {
            //NSLog(@"getPindaoNews failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        NSArray* list = customDict[@"list"];
//        for (NSDictionary *dic in list) {
//            NSLog(@"NaviPindao kind_id:%@,name:%@",dic[@"kind_id"],dic[@"kind"]);
//        }
    

        NSArray *pindaoArr = [NaviPindao naviPindaoArrWithArr:list];
        NaviPindao *pindao = [[NaviPindao alloc] init];
        [pindao removeNoExistNaviPindaoWithNaviPindaoArr:pindaoArr];
        [pindao addNaviPindaoWithNaviPindaoArr:pindaoArr];
        
        NSArray *dic = [NaviPindao unarchiverDisplayList];
        if ([dic count] <= 0) {
            //[self requestNavigationPindao];
            return;
        }
        if (![self.dataList count] && ![NaviPindao isArr:dic equalityToArr:[self.dataList copy]]) {
            self.dataList = [dic mutableCopy];
        }
        
    }];
    

}

-(void)getCacheData
{
    
//    NSArray *dic = [NaviPindao unarchiverDisplayList];
//    if ([dic count] > 0) {
//        self.dataList = [dic mutableCopy];
//    }
//    [self requestNavigationPindao];
    
    NSArray* list = [[ZBAppSetting standardSetting] hotNaviList];
    //        for (NSDictionary *dic in list) {
    //            NSLog(@"NaviPindao kind_id:%@,name:%@",dic[@"kind_id"],dic[@"kind"]);
    //        }
    if ([list count]==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"暂无首页导航数据！") delegate:nil cancelButtonTitle:nil otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [av show];
        return;
    }
    
    NSArray *pindaoArr = [NaviPindao naviPindaoArrWithArr:list];
    NaviPindao *pindao = [[NaviPindao alloc] init];
    [pindao removeNoExistNaviPindaoWithNaviPindaoArr:pindaoArr];
    [pindao addNaviPindaoWithNaviPindaoArr:pindaoArr];
    
    NSArray *dic = [NaviPindao unarchiverDisplayList];
    if ([dic count] <= 0) {
        //[self requestNavigationPindao];
        return;
    }
    if (![self.dataList count] && ![NaviPindao isArr:dic equalityToArr:[self.dataList copy]]) {
        self.dataList = [dic mutableCopy];
    }

    
}

@end
