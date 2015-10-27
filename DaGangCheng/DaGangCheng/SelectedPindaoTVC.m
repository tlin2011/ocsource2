//
//  SelectedPindaoTVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-7-29.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "SelectedPindaoTVC.h"
#import "SelectedPindaoTVCell.h"
#import "PindaoCacher.h"
#import "ApiUrl.h"
#import "NetRequest.h"
#import "Praise.h"

@interface SelectedPindaoTVC ()
@property (strong, nonatomic) NSMutableArray *pindaos; //频道数
@end

@implementation SelectedPindaoTVC

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    NSString *title = [ZBAppSetting standardSetting].pindaoName;
    self.title = title;
    
    self.tableView.backgroundColor = UIColorFromRGB(0xececec);
    

    self.navigationItem.rightBarButtonItem = nil;

    
    
    [self requestDefaultPindao];
}
-(void)requestDefaultPindao {
    ////ApiUrl * url = [ApiUrl new];
    NetRequest * request = [NetRequest new];
    
    NSString *appKind  = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary * parameters =@{@"s_ibg_kind":appKind};
    [request urlStr:[ApiUrl reconmmendPindaoUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        NSLog(@"pindao-news:%@",customDict);
        if (![customDict[@"ret"] integerValue]) {
            [self requestPindao];
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {

                return ;
            }
            [Praise hudShowTextOnly:GDLocalizedString(@"加载失败,请检查网络") delegate:self];
            return ;
        }
        if (!self.pindaos) {
            self.pindaos = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *json in customDict[@"list"]) {
            Pindao *pindao = [Pindao getPindaoByJson:json];
            [self.pindaos addObject:pindao];
        }
        [self.tableView reloadData];
        [self requestPindao];
    }];
}
- (void)requestPindao{
    NetRequest * request = [NetRequest new];

    NSString* ibg_udid  = [HuaxoUtil getUdidStr];
    NSLog(@"requestNews ibg_udid:%@",ibg_udid);
    if (ibg_udid) {
        NSDictionary * parameters =@{@"uid":ibg_udid,@"app_kind":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"]};
        [request urlStr:[ApiUrl AttentionChannelUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
            NSLog(@"pindao-news:%@",customDict);
            if (![customDict[@"ret"] integerValue]) {
                NSLog(@"load failed,msg:%@",customDict[@"msg"]);
                if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                    
                    return ;
                }
                [Praise hudShowTextOnly:GDLocalizedString(@"加载失败,请检查网络") delegate:self];
                return ;
            }
            if (!self.pindaos) {
                self.pindaos = [[NSMutableArray alloc] init];
            }
            
            for (NSDictionary *json in customDict[@"list"]) {
                Pindao *pindao = [Pindao getPindaoByJson:json];
                if (![self isPindao:pindao inPindaos:self.pindaos]) {
                    [self.pindaos addObject:pindao];
                }
            }
            [self.tableView reloadData];
        }];
    }
}

- (BOOL)isPindao:(Pindao *)pindao inPindaos:(NSMutableArray *)pindaos {
    for (Pindao *pin in pindaos) {
        if ([pin.pindaoId isEqualToString:pindao.pindaoId]) {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pindaos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedPindaoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Pindao *pindao = self.pindaos[indexPath.row];
    //图像
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pindao.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];

    cell.headImage.layer.masksToBounds = YES;
    cell.headImage.layer.cornerRadius  = 7;
    //self.userImage.layer.borderWidth = 0.5;
    cell.headImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.headImage.clipsToBounds = YES;
    
    cell.name.text = pindao.name;
    cell.backgroundColor = UIColorFromRGB(0xececec);
    
    if ([self.selectedPindao.pindaoId isEqualToString:pindao.pindaoId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPindao = self.pindaos[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(SelectedPindaoTVC:selectedPindao:)]) {
        [self.delegate SelectedPindaoTVC:self selectedPindao:self.selectedPindao];

        [self.navigationController popViewControllerAnimated:YES];
        }
    }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
- (void)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
