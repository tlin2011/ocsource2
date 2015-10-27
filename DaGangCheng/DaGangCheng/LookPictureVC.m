//
//  LookPictureVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-12-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "LookPictureVC.h"
#import "KL_ImageZoomView.h"
#import "KL_ImagesZoomController.h"

@interface LookPictureVC ()
@property (nonatomic, strong) NSArray *imageStrs;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) KL_ImagesZoomController *img;


@end

@implementation LookPictureVC

- (id)initWithImageStrs:(NSArray *)imageStrs index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.imageStrs = imageStrs;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
    //self.navigationController.navigationBarHidden = YES;
    
    //self.title = [NSString stringWithFormat:@"%d/%d",self.index + 1,self.imageStrs.count];
    
    NSLog(@"显示图片");
    KL_ImagesZoomController *img = [[KL_ImagesZoomController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )imgViewSize:CGSizeZero];
    img.delegate = self;
    [self.view addSubview:img];
    [img updateImageDate:self.imageStrs selectIndex:self.index];
    self.img = img;
    
    //自建navigationBar
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.naviView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.naviView];
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64-44, 35, 44)];
    [backBtn setImage:[UIImage imageNamed:@"返回箭头"] forState:UIControlStateNormal];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:backBtn];
    //图片页数
    self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    self.pageLabel.center = CGPointMake(self.naviView.frame.size.width/2.0, 44);
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.font = [UIFont systemFontOfSize:17];
    [self.naviView addSubview:self.pageLabel];
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(self.index + 1),(unsigned long)self.imageStrs.count];
    //保存图片按钮
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.naviView.frame.size.width-48, 64-44, 44, 44)];
    [saveBtn setTitle:GDLocalizedString(@"保存") forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [saveBtn addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:saveBtn];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:@"clickedPictureInKL_ImageZoomView" object:nil];
}

- (NSArray *)imageArr {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/575ba9141352103160644106f6ea328d_898_600.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/41c856dc843f77c31feaa844010372dd_200_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/7bc3f732cb3d7c8b6f4733e1c4e13e06_200_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/f53df4315d62b8c367e6c15d5f273ca5_225_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/a1733f9c235e4c23b4ebefb518e8d1c6_180_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/17fe9fc8006ae9edc5126811e3df02e5_180_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/7731053fecb2b058b8d412c53cc193d3_200_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/7fe31f771b5367f42ea3e5818f068e05_200_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/0a1fec8d94bfa0023b1e6520beddcf7f_235_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/8b0fb232cbadafcde386f70f1e7a98e0_225_300.jpg"];
    [arr addObject:@"http://ikaola-image.b0.upaiyun.com/club/2014/9/28/37ff76845bc74e107163e111446e99a2_500_333.jpg"];
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickedPictureInKL_ImageZoomView" object:nil];
}

- (void)save:(id)seder {
    [self.img savePicture];
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
