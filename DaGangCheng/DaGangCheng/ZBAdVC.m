//
//  ZBAdVC.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBAdVC.h"
@interface ZBAdVC ()
@property (nonatomic, strong) ZBAdView *adView;
@end

@implementation ZBAdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZBAdView *adView = [[ZBAdView alloc] initWithFrame:self.view.bounds];
    adView.imageId = self.imageID;
    adView.delegate = self;
    self.adView = adView;
    [self.view addSubview:adView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isOpenedAd && [self.delegate respondsToSelector:@selector(adVCOpenedWithBack:)]) {
        [self.delegate adVCOpenedWithBack:self];
    }
}

- (void)adViewIgnore:(ZBAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(adVCIgnore:)]) {
        [self.delegate adVCIgnore:self];
    }
}

- (void)adViewClickedAd:(ZBAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(adVCClickedAd:)]) {
        [self.delegate adVCClickedAd:self];
    }
}

/**
 *  广告页只能竖屏
 */
- (BOOL)shouldAutorotate

{
    
    return YES;
    
}
- (NSUInteger)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
