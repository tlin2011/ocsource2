//
//  ZBAdView.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
@class ZBAdView;

@protocol ZBAdViewDelegate <NSObject>

@optional
- (void)adViewIgnore:(ZBAdView *)adView;
- (void)adViewClickedAd:(ZBAdView *)adView;
@end

@interface ZBAdView : UIView


@property (weak, nonatomic) id<ZBAdViewDelegate> delegate;
@property (nonatomic, copy) NSString *imageId;

@end
