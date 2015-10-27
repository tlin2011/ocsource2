//
//  LookPictureVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-26.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookPictureVC : UIViewController
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UILabel *pageLabel;

- (id)initWithImageStrs:(NSArray *)imageStrs index:(NSInteger)index;
- (void)back:(id)sender;
@end
