//
//  PlateCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-2.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PlateCell.h"
#import "NSString+ZYFontSize.h"

@implementation PlateCell

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
          delegate:(id<WKTableViewCellDelegate>)delegate
       inTableView:(UITableView *)tableView
withRightButtonTitles:(NSArray *)rightButtonTitles{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier delegate:delegate inTableView:tableView withRightButtonTitles:rightButtonTitles];
    if (self){
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews {
    
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 2;
    self.headImageView.layer.masksToBounds= YES;
    [self.cellContentView addSubview:self.headImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = UIColorFromRGB(0x32373e);
    [self.cellContentView addSubview:self.titleLabel];
    
    self.comment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.comment.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.comment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"社区_cell_commot_bg.png"];
    img = [img imageWithMobanThemeColor];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 1)];
    [self.comment setBackgroundImage:img forState:UIControlStateNormal];
    [self.comment setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.cellContentView addSubview:self.comment];
    
    self.content = [[UILabel alloc] init];
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textColor = UIColorFromRGB(0x98999a);
    [self.cellContentView addSubview:self.content];
    
    self.fansIco = [[UIImageView alloc] init];
    self.fansIco.image = [UIImage imageNamed:@"粉丝数Icon.png"];
    [self.cellContentView addSubview:self.fansIco];
    
    self.fansNum = [[UILabel alloc] init];
    self.fansNum.font = [UIFont systemFontOfSize:12];
    self.fansNum.textColor = UIColorFromRGB(0x98999a);
    [self.cellContentView addSubview:self.fansNum];
    
    self.topicIco = [[UIImageView alloc] init];
    self.topicIco.image = [UIImage imageNamed:@"帖数_社区.png"];
    [self.cellContentView addSubview:self.topicIco];
    
    self.topicNum = [[UILabel alloc] init];
    self.topicNum.font = [UIFont systemFontOfSize:12];
    self.topicNum.textColor = UIColorFromRGB(0x98999a);
    [self.cellContentView addSubview:self.topicNum];

    //UIColorFromRGB(0xf3f5f6)
    self.lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineView.image = [UIImage imageWithColor:UIColorFromRGB(0xf3f5f6) andSize:CGSizeMake(2, 2)];
    [self addSubview:self.lineView];
    
    //
    self.line = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *lineImg = [UIImage imageWithColor:UIColorFromRGB(0xdbdbdb) andSize:CGSizeMake(2, 2)];
    self.line.image = lineImg;
    [self.lineView addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    self.headImageView.frame = CGRectMake(8, 8, 70, 70);

    self.titleLabel.frame = CGRectMake(87, 12, 100, 16);
    self.fansIco.frame = CGRectMake(87, CGRectGetMaxY(self.titleLabel.frame) + 2 *8, 13, 12);
    self.fansNum.frame = CGRectMake(CGRectGetMaxX(self.fansIco.frame) + 8, self.fansIco.y, 26, 13);
    self.topicIco.frame = CGRectMake(CGRectGetMaxX(self.fansNum.frame) + 8, self.fansIco.y, 13, 12);
    self.topicNum.frame = CGRectMake(CGRectGetMaxX(self.topicIco.frame) + 8, self.fansIco.y, 26, 13);
    self.content.frame = CGRectMake(87, 62, frame.size.width - 87 -10, 12);
    
    CGSize commentSize = [self.commentStr textSizeWithFont:[UIFont systemFontOfSize:12] andMaxSzie:CGSizeMake(CGFLOAT_MAX, 12)];
    self.comment.frame = CGRectMake(frame.size.width - commentSize.width - 8, 8, commentSize.width + 8, commentSize.height+2);
    [self.comment setTitle:self.commentStr forState:UIControlStateNormal];

    self.lineView.frame = CGRectMake(0, frame.size.height - 8, frame.size.width, 8);
    //底部线
    self.line.frame = CGRectMake(0, 0, frame.size.width, 0.5);
}


@end