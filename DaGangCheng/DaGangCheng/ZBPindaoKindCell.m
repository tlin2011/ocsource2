//
//  ZBPindaoKindCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/5/15.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPindaoKindCell.h"
#import "UIImage+Color.h"
#import "UIView+AdjustFrame.h"

#define kLeftViewWidth 80
#define kLeftViewRowHeight 48

@interface ZBPindaoKindCell ()

@property (nonatomic, weak) UILabel *pindaoKindLabel;
@property (nonatomic, weak) UIImageView *columnLineView;
@property (nonatomic, weak) UIView *rowLineView;

@end

@implementation ZBPindaoKindCell

//- (void)awakeFromNib {
//    // Initialization code
//}
//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
    if (selected) {
        self.pindaoKindLabel.textColor = UIColorWithMobanTheme;
        self.columnLineView.hidden = NO;
    } else
    {
        self.pindaoKindLabel.textColor = UIColorFromRGB(0x32373e);
        self.columnLineView.hidden = YES;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initSubviews
{
    UILabel *pindaoKindLabel = [[UILabel alloc] init];
    pindaoKindLabel.font = [UIFont systemFontOfSize:12.0];
    self.pindaoKindLabel = pindaoKindLabel;
    [self.contentView addSubview:pindaoKindLabel];
    
    UIImageView *columnLineView = [[UIImageView alloc] init];
    columnLineView.image = [UIImage imageWithColor:UIColorWithMobanTheme andSize:CGSizeMake(4, kLeftViewRowHeight)];
    self.columnLineView = columnLineView;
    [self.contentView addSubview:columnLineView];
    
    UIView *rowLineView = [[UIView alloc] init];
    rowLineView.backgroundColor = UIColorFromRGB(0xdcdddd);
    self.rowLineView = rowLineView;
    [self.contentView addSubview:rowLineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pindaoKindLabel.frame = CGRectMake(10, 0, self.width - 10, self.height);
    self.columnLineView.frame = CGRectMake(0, 0, 4, self.height);
    self.rowLineView.frame = CGRectMake(0, self.height- 0.5, self.width, 0.5);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"kind";
    ZBPindaoKindCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f8f8) andSize:cell.frame.size]];
    return cell;
}

// 重写set方法赋值
- (void)setPindaoKindName:(NSString *)pindaoKindName
{
    _pindaoKindName = pindaoKindName;
    self.pindaoKindLabel.text = pindaoKindName;
}

@end