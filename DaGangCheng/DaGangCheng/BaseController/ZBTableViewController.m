//
//  ZBTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/7/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTableViewController.h"

#import "MTA.h"

@interface ZBTableViewController ()

@end

@implementation ZBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [MTA trackPageViewBegin:NSStringFromClass([self class])];
}


-(void)viewWillDisappear:(BOOL)animated{
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
}


@end
