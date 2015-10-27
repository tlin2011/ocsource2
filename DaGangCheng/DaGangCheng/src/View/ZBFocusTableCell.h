//
//  ZBFocusTableCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+Color.h"

@interface ZBFocusTableCell : UITableViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIImageView *lineView;
@property (strong, nonatomic) UIImageView *line;
@property (strong, nonatomic) UIButton *concernBtn;

@property (strong, nonatomic) UIImageView *fansIco;
@property (strong, nonatomic) UILabel *fansNum;
@property (strong, nonatomic) UIImageView *topicIco;
@property (strong, nonatomic) UILabel *topicNum;

- (void)initSubviews;
+ (CGFloat)cellHeight;
@end
