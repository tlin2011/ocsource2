//
//  ZBWebProgressView.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-11.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBWebProgressView.h"
@interface ZBWebProgressView ()
@property (nonatomic, assign) BOOL isClose;
@end

@implementation ZBWebProgressView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)startProgress {
    [self startProgressWithVelocity:1];
}

- (void)startProgressWithVelocity:(int)velocity {
    self.hidden = NO;
    self.isClose = NO;
    __block ZBWebProgressView *bSelf = self;
    //    开启子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        此处已经是子线程
        for (float progress = 0; progress<1.0f; progress+=0.01*velocity) {
            if (bSelf.isClose) {
                return ;
            }
            [NSThread sleepForTimeInterval:0.1];
            
            //回到主线程执行
            dispatch_async(dispatch_get_main_queue(), ^{
                bSelf.progress = progress;
            });

        }

    });
}

- (void)endProgress {
    [self endProgressWithVelocity:10];
}

- (void)endProgressWithVelocity:(int)velocity {
    self.isClose = YES;
    __block ZBWebProgressView *bSelf = self;
    //    开启子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        此处已经是子线程
        for (float progress = bSelf.progress; progress<1.0f; progress+=0.01*velocity) {
            if (!self.isClose) {
                return ;
            }
            [NSThread sleepForTimeInterval:0.1];
            
            //回到主线程执行
            dispatch_async(dispatch_get_main_queue(), ^{
                [bSelf setProgress:progress animated:YES];
            });
            
        }
        //回到主线程执行
        dispatch_async(dispatch_get_main_queue(), ^{
            bSelf.hidden = YES;
        });
        
    });
}

@end
