//
//  ZBCsTabButton.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBCsTabButton;
@protocol ZBCsTabButtonDelegate <NSObject>

- (void)csTabButton:(ZBCsTabButton *)btn clickedButtonIndex:(int)index;

@end


@interface ZBCsTabButton : UIButton
@property (nonatomic, strong) NSArray *btnInfoArr;

@end
