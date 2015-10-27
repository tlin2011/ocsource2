//
//  CSHistoryViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "CSHistoryViewController.h"

@interface CSHistoryViewController ()

@end

@implementation CSHistoryViewController
@synthesize csList;

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
    
    csList = [CSHistory getCSHistors];
    [self.navigationController hidesBottomBarWhenPushed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [csList count];
}

-(void)viewWillAppear:(BOOL)animated
{
    csList = [CSHistory getCSHistors];
    //[self requestData];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSHistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CSHistoryViewCell" forIndexPath:indexPath];
    
    NSDictionary* dic = csList[indexPath.row];
    
    cell.tipsLabel.text = dic[@"title"];
    cell.timeLabel.text = [TimeUtil getFriendlySimpleTime:(NSNumber*)dic[@"time"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld ",(long)indexPath.row);
    NSDictionary* dic = csList[indexPath.row];
    
    NSNumber* csid = dic[@"id"];
    //动态
    if([CSHistory isPostCS:dic])
    {
        [self intoTopicPage:[NSString stringWithFormat:@"%@",csid]];
    }
    //话题
    else if([CSHistory isPindaoCS:dic]){
        [self intoPindaoPage:[NSString stringWithFormat:@"%@",csid]];
    }
    
}

-(void)intoTopicPage:(NSString*)post_id
{
    PostViewController * next = [[PostViewController alloc] init];
    next.postID = post_id;
    next.title = GDLocalizedString(@"查看话题");
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];

}

-(void)intoPindaoPage:(NSString*)kind_id
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PindaoIndexViewController *next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    next.kind_id = kind_id;
    
    [self.navigationController hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:next animated:YES];
}

@end
