//
//  PindaoIndexViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"

#import "PindaoIndexViewController.h"
#import "Pindao.h"
#import "ZBTRefreshTableVC.h"
#import "ZBTUrlCacher.h"
#import "ZBNumberUtil.h"
#import "ZBAppSetting.h"

@interface PindaoIndexViewController : ZBTRefreshTableVC<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *postNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayNumLabel;

@property (strong, nonatomic) UIButton *focusBtn;
@property (strong, nonatomic) UIImageView *line;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic, copy) NSString* kind_id;
@property (nonatomic, strong) NSDictionary* pindaoInfo;

- (void)back:(id)sender;
@end
