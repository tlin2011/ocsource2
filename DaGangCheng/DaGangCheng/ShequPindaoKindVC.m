//
//  ShequPindaoKindVC.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ShequPindaoKindVC.h"
#import "HuaxoUtil.h"
#import "ZBPindaoKindView.h"
//#import "ZBPindaoKind.h"
//#import "ZBPindaoList.h"
#import "Pindao.h"
#import "NetRequest.h"
#import "UIView+AdjustFrame.h"
#import "PindaoIndexViewController.h"

#define kW [UIScreen mainScreen].bounds.size.width
#define kH [UIScreen mainScreen].bounds.size.height

@interface ShequPindaoKindVC ()<ZBPindaoKindViewDelegate>

@property (nonatomic, weak) ZBPindaoKindView *pkView;
@property (nonatomic, strong) NSMutableArray *pindaoKinds;
@property (nonatomic, strong) NSMutableArray *pindaoLists;

@end

@implementation ShequPindaoKindVC

- (NSMutableArray *)pindaoKinds
{
    if (!_pindaoKinds) {
        _pindaoKinds = [NSMutableArray array];
    }
    return _pindaoKinds;
}

- (NSMutableArray *)pindaoLists
{
    if (!_pindaoLists) {
        _pindaoLists = [NSMutableArray array];
    }
    return _pindaoLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ZBPindaoKindView *pkView = [[ZBPindaoKindView alloc] initWithFrame:CGRectMake(0, 0, kW, kH)];
    pkView.delegate = self;
    self.pkView = pkView;
    [self.view addSubview:pkView];
    [self requestPindaoKinds];
}

#pragma mark - 获取频道分类信息
- (void)requestPindaoKinds
{
    NetRequest * request =[NetRequest new];
    NSDictionary * parameters = @{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"op":@"class_list"
                                  };
    
    [request urlStr:[ApiUrl getPindaoKinds] parameters:parameters passBlock:^(NSDictionary *customDict) {
        ZBLog(@"%@", [ApiUrl getPindaoKinds]);
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        ZBLog(@"requestPindaoKinds-----------%@", customDict);
        NSArray* list = customDict[@"list"];
        for (NSDictionary *json in list) {
            Pindao *pindao = [Pindao getPindaoByJson:json];
            [self.pindaoKinds addObject:pindao];
        }
        self.pkView.pindaoKinds = self.pindaoKinds;
    }];
}

#pragma mark - 分类下的频道列表
- (void)requestPindaoListwithClassid:(NSString *)kindId index:(NSInteger)index
{
    NetRequest * request =[NetRequest new];
    NSString *begin = [NSString stringWithFormat:@"%ld",(long)index];
    
    if ([begin isEqualToString:@"0"]) {
        [self.pkView.pindaoLists removeAllObjects];
    }
    
    NSDictionary * parameters = @{
                                  @"op":@"class_kinds",
                                  @"class_id":kindId,
                                  @"begin":begin,
                                  @"plen":@"10"
                                  };
    
    [request urlStr:[ApiUrl getPindaoKinds] parameters:parameters passBlock:^(NSDictionary *customDict) {
//        if (![customDict[@"ret"] integerValue] ) {
//            [self.pkView.pindaoLists removeAllObjects];
//            self.pkView.pindaoLists = [[NSMutableArray alloc] init];
//            retur
//            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
//            return ;
//        }
        ZBLog(@"requestPindaoList----------------------- %@",customDict);
        NSArray* list = customDict[@"list"];
        
        if (self.pkView.pindaoLists == nil || self.pkView.pindaoLists.count<1) {
            self.pkView.pindaoLists = [[NSMutableArray alloc] init];
        }
        
        if ([self.pkView.requestSign isEqualToString:kindId]) {
            for (NSDictionary *json in list) {
                Pindao *pindao = [Pindao getPindaoByJson:json];
                [self.pkView.pindaoLists addObject:pindao];
            }
        }
        
        [self.pkView reloadRightTable];
    }];
}

#pragma mark - pindaoKindView的代理方法，请求频道分类下的频道列表信息
- (void)pindaoKindView:(ZBPindaoKindView *)pindaoKindView class_id:(NSString *)kindId index:(NSInteger)index
{
    [self requestPindaoListwithClassid:kindId index:index];
}

- (void)pindaoKindView:(ZBPindaoKindView *)pindaoKindView didSelectedPindao:(Pindao *)pindao {
    [self intoUserPage:pindao.pindaoId];
}

-(void)intoUserPage:(NSString *)kindId
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PindaoIndexViewController * next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    next.kind_id = kindId;
    [self.navigationController pushViewController:next animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pkView reloadRightTable];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end