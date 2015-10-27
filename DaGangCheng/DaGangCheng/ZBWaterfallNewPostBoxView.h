//
//  ZBWaterfallNewPostBoxView.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-4.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBKeyboardToolView.h"

@class ZBWaterfallNewPostBoxView;
@protocol ZBWaterfallNewPostBoxViewDelegate <NSObject>

- (void)waterfallNewPostBoxViewClickKeyboardBtn;

@end

@interface ZBWaterfallNewPostBoxView : ZBKeyboardToolView
@property (nonatomic, strong) UIButton *keyboardBtn;
@property (nonatomic, weak) id<ZBWaterfallNewPostBoxViewDelegate>delegate;
@end
