//
//  UITableView+separator.m
//  DaGangCheng
//
//  Created by huaxo on 15-7-20.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UITableView+separator.h"

@implementation UITableView (separator)

- (void)bottomSeparatorHidden {
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self setTableFooterView:view];
}

@end
