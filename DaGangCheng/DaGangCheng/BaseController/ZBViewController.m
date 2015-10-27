//
//  ZBViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/7/23.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBViewController.h"
#import "MTA.h"

@interface ZBViewController ()

@end

@implementation ZBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }



-(void)viewWillAppear:(BOOL)animated{
    [MTA trackPageViewBegin:NSStringFromClass([self class])];
}


-(void)viewWillDisappear:(BOOL)animated{
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
}

@end
