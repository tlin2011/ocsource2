//
//  PostVisitorsCell.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-21.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
@interface PostVisitorsCell : UITableViewCell
@property (nonatomic, strong) UIImageView *zanIco;
@property (nonatomic, strong) UILabel *zanLabel;

@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *dataStr;

@property (weak, nonatomic) UIImageView *bottomLine;
@end
