//
//  userStatusPhoto.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-1.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "userStatusPhoto.h"
#import "MyTableViewController.h"

@implementation userStatusPhoto


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{

    self.headBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self.headBg.backgroundColor = [UIColor whiteColor];
    self.headBg.layer.cornerRadius = 16.0;
    self.headBg.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
    self.headBg.layer.borderWidth = 0.5;
    self.headBg.layer.masksToBounds = YES;
    [self addSubview:self.headBg];
    
    self.head = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.head.center = self.headBg.center;
    self.head.layer.cornerRadius = 15.0;
    self.head.layer.masksToBounds = YES;
    //
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSDictionary * aDic =[sql query];
    if ([HuaxoUtil isLogined]) {
        NSString *imgId = [NSString stringWithFormat:@"%@", aDic[@"img_id"]];
        [self.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[imgId integerValue] w:50]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
        self.head.tag = 1;
    } else {
        [self.head setBackgroundImage:[UIImage imageNamed:@"nm.png"] forState:UIControlStateNormal];
        self.head.tag = 0;
    }
    
    [self addSubview:self.head];
    [self.head addTarget:self action:@selector(clickedHead) forControlEvents:UIControlEventTouchUpInside];
    
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reveiveDidLogin:) name:[NotifyCenter userLoginStatusKey] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reveiveDidLogin:) name:@"用户更改头像" object:nil];
}

- (void)reveiveDidLogin:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    if (info) {
        NSLog(@"info %@",info);
        NSString *imgId = [NSString stringWithFormat:@"%@", info[@"img_id"]];
        [self.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[imgId integerValue] w:50]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
        self.head.tag = 1;
    }else {
        [self.head setBackgroundImage:[UIImage imageNamed:@"nm.png"] forState:UIControlStateNormal];
        self.head.tag = 0;
    }
    [self addSubview:self.head];
}

#pragma mark - 跳转“我”的界面
- (void)clickedHead {
    if (!self.delegate) return;
    int i = 0;
    for (UIViewController *vc in self.delegate.tabBarController.viewControllers) {
        UINavigationController *navVC = (UINavigationController *)vc;
        if ([navVC.topViewController isMemberOfClass:[MyTableViewController class]]) {
            self.delegate.tabBarController.selectedIndex = i;
            break;
        }
        i ++;
    }
}

- (void)dealloc {
    NSLog(@"userStatusPhoto dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
