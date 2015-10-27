//
//  PlateCell.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-2.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Color.h"

@interface PlateCell : WKTableViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *comment;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *lineView;
@property (strong, nonatomic) UIImageView *line;

@property (strong, nonatomic) UIImageView *fansIco;
@property (strong, nonatomic) UILabel *fansNum;
@property (strong, nonatomic) UIImageView *topicIco;
@property (strong, nonatomic) UILabel *topicNum;

@property (copy, nonatomic) NSString *commentStr;

@end
