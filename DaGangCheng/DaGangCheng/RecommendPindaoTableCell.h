//
//  RecommendPindaoTableCell.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendPindaoTableCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *recommendIco;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UIImageView *headImageView;

@property (strong, nonatomic) UIImageView *fansIco;
@property (strong, nonatomic) UILabel *fansNum;
@property (strong, nonatomic) UIImageView *topicIco;
@property (strong, nonatomic) UILabel *topicNum;
@end
