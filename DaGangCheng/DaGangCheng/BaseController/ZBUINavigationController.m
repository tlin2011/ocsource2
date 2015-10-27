//
//  ZBUINavigationController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/7/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBUINavigationController.h"

#import "MTA.h"

@interface ZBUINavigationController ()

@end

@implementation ZBUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated{
    [MTA trackPageViewBegin:NSStringFromClass([self class])];
}


-(void)viewWillDisappear:(BOOL)animated{
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
}


@end
