//
//  PersonageTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageTableVC.h"

@interface PersonageTableVC ()
{
    float lastContentOffset;
}
@end

@implementation PersonageTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    // Configure the cell...
    cell.textLabel.text = @"ok";
    return cell;
}


-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}
-( void )scrollViewDidScroll:( UIScrollView *)scrollView {
    if (scrollView.contentOffset.y< lastContentOffset  && scrollView.contentOffset.y<=10)
    {
        //向下
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonageTableVCDown" object:nil];
    } else if (scrollView. contentOffset.y >lastContentOffset && scrollView.contentOffset.y>=10)
    {
        //向上
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonageTableVCUp" object:nil];
    }
}

@end
