//
//  ZBAdVC.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBAdView.h"
@class ZBAdVC;

@protocol ZBAdVCDelegate <NSObject>

- (void)adVCIgnore:(ZBAdVC *)adVC;
- (void)adVCClickedAd:(ZBAdVC *)adVC;
- (void)adVCOpenedWithBack:(ZBAdVC *)adVC;
@end


@interface ZBAdVC : UIViewController <ZBAdViewDelegate>

@property (nonatomic, weak) id<ZBAdVCDelegate>delegate;
@property (nonatomic, copy) NSString *imageID;
@property (nonatomic, assign) BOOL isOpenedAd;
@end
