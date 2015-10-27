//
//  PlayProgressBar.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayProgressBar : UIView
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic)CGFloat value;//0~1
@end
