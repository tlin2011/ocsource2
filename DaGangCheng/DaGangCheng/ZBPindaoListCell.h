//
//  ZBPindaoListCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBNumberUtil.h"
#import "UIImage+Color.h"

@class Pindao;

@interface ZBPindaoListCell : UITableViewCell

@property (nonatomic, strong) Pindao *pd;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
