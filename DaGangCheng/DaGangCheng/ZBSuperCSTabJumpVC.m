//
//  ZBSuperCSTabJumpVC.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBSuperCSTabJumpVC.h"
#import "ZBCsTabButton.h"

@interface ZBSuperCSTabJumpVC ()

@end

@implementation ZBSuperCSTabJumpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //
    self.navigationController.navigationBarHidden = NO;
}

- (NSArray *)menuStr {
    return @[@{@"title":GDLocalizedString(@"截图分享"),@"image":@""},
             @{@"title":GDLocalizedString(@"复制网址"),@"image":@""},
             //@{@"title":@"收藏",@"image":@"倒序查看_查看话题"}
             ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
