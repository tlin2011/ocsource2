//
//  JYSlideSegmentController+back.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-4.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "JYSlideSegmentController+back.h"

@implementation JYSlideSegmentController (back)
- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
