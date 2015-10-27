//
//  PersonageCardTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageCardTableVC.h"
#import "HuaxoUtil.h"
#import "NetRequest.h"
#import "UITableView+separator.h"

@interface PersonageCardTableVC ()
@property (nonatomic, strong) NSDictionary *cardInfo;
@end

@implementation PersonageCardTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view.
    
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    
    [self requestCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<=4) {
        return 45;
    }
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = GDLocalizedString(@"姓名");
        cell.detailTextLabel.text = self.cardInfo[@"name"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = GDLocalizedString(@"手机");
        cell.detailTextLabel.text = self.cardInfo[@"phone"];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"QQ";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.cardInfo[@"qq"] integerValue]];
    } else if (indexPath.row == 3) {
        cell.textLabel.text = GDLocalizedString(@"邮箱");
        cell.detailTextLabel.text = self.cardInfo[@"email"];
    } else if (indexPath.row == 4) {
        cell.textLabel.text = GDLocalizedString(@"家乡");
        cell.detailTextLabel.text = self.cardInfo[@"home_addr"];
    } else if (indexPath.row == 5) {
        cell.textLabel.text = GDLocalizedString(@"介绍");
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.text = self.cardInfo[@"desc"];
    }
    
    return cell;
}

-(void)requestCard
{
    NetRequest * request =[NetRequest new];
    NSDictionary * parameters = @{@"uid":self.userId};
    [request urlStr:[ApiUrl getMyCardUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if(![(NSNumber*)customDict[@"ret"] intValue])
        {
            NSLog(@"get-cardinfo failed!msg:%@",customDict[@"msg"]);
            return ;
        }
        self.cardInfo = customDict;

        [self.tableView reloadData];
    }];
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
