//
//  ZBWaterfallMangerView.h
//  DaGangCheng
//
//  Created by huaxo on 15-2-26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Praise.h"
#import "Post.h"
#import "ZBPraise.h"

@interface ZBWaterfallMangerView : UIView
@property (nonatomic, strong) Post *post;

+(ZBWaterfallMangerView*)sharedManager;
@end
