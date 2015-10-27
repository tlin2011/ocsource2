//
//  ZBPindaoKindCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBPindaoKindCell : UITableViewCell

@property (nonatomic, copy) NSString *pindaoKindName;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
