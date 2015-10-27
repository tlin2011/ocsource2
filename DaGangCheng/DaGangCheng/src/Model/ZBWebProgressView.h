//
//  ZBWebProgressView.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-11.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBWebProgressView : UIProgressView

- (void)startProgressWithVelocity:(int)velocity;
- (void)startProgress;
- (void)endProgressWithVelocity:(int)velocity;
- (void)endProgress;
@end
