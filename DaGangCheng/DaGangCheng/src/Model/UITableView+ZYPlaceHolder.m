//
//  UITableView+ZYPlaceHolder.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/6.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UITableView+ZYPlaceHolder.h"

@implementation UITableView (ZYPlaceHolder)

- (void)setupPlaceHolder
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = ZYColor(240, 241, 244);
    UIImage *image = [[UIImage imageNamed:@"空空_社区"] imageWithMobanThemeColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 96, 38)];
    imageView.image = image;
    imageView.center = CGPointMake(DeviceWidth * 0.5, DeviceHeight * 0.5 - 100);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame), imageView.frame.size.width, imageView.frame.size.height)];
    label.text = GDLocalizedString(@"空空如也～");
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    self.backgroundView = backgroundView;
}

@end
