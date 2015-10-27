//
//  PostManagerView.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-13.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTPostManagerView.h"

#define ButtonTitleHeight 36

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
#define DeviceHeight [UIScreen mainScreen].bounds.size.height
#define DeviceWidth [UIScreen mainScreen].bounds.size.width

#import "PostButton.h"
#import "AppDelegate.h"

@interface ZBTPostManagerView ()
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) CGFloat imageWidth;

@end

@implementation ZBTPostManagerView

- (id)initWithButtonTitles:(NSArray *)titles imageWidth:(CGFloat)imageWidth delegate:(id<ZBTPostManagerViewDelegate>)delegate{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        self.imageWidth=imageWidth;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat width=144;
    CGFloat height=36;
    
    for (int i=0; i<self.titles.count; i++) {
        
        UIView *tempView =[[UIView alloc]initWithFrame:CGRectMake(0,i*height,width,height)];
        PostButton *pbtn=[[PostButton alloc] initWithFrame:CGRectMake(0, 0, width, height) width:width height:height imageWidth:32];
        
         [pbtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.titles[i][@"image"]]] forState:UIControlStateNormal];
        [pbtn setTitle:self.titles[i][@"title"] forState:UIControlStateNormal];
        [pbtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [pbtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [pbtn setBackgroundImage:[UIImage imageNamed:@"矩形白.jpg"] forState:UIControlStateNormal];
        [pbtn setBackgroundImage:[UIImage imageNamed:@"矩形灰.jpg"] forState:UIControlStateHighlighted];
        [tempView addSubview:pbtn];
        [self.view addSubview:tempView];
    }
    
    self.view.bounds = CGRectMake(0, 0, DeviceWidth, self.titles.count * ButtonTitleHeight);
    
    

    
  
}



- (void)selectButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zbtPostManagerView:selectedButtonTitle:)]) {
        
        [self.delegate zbtPostManagerView:self selectedButtonTitle:[sender titleForState:UIControlStateNormal]];
        [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.2];
    }
}


- (void)show {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.5;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame = CGRectZero;
    AppDelegate *app = (AppDelegate *)([[UIApplication sharedApplication] delegate]);
    [[app window] addSubview:self];
    [[app window] addSubview:btn];

    self.bgButton = btn;
    
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(DeviceWidth - 150, 64, 150, self.view.bounds.size.height)];
    BgView.clipsToBounds = YES;
    [[app window] addSubview:BgView];
    self.bgView = BgView;
    
    CGRect startFrame = self.view.bounds;
    startFrame.origin.y = - startFrame.size.height;
    
    CGRect endFrame = self.view.bounds;
    endFrame.origin.y = 0;
    
    self.view.frame = startFrame;
    [BgView addSubview:self.view];
    
    __block UIView *bManagerView = self.view;

    [UIView animateWithDuration:0.3 animations:^{
        bManagerView.frame = endFrame;
    } completion:^(BOOL finished) {
        //bManagerView.frame = endFrame;
    }];
    
}

- (void)clickedBtn:(UIButton *)sender {
    [self performSelector:@selector(removeSelf) withObject:nil afterDelay:0.2];
}

- (void)removeSelf {
    [self.bgButton removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)dealloc {

}

@end
