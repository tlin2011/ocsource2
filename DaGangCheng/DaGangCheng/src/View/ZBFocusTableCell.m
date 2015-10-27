//
//  ZBFocusTableCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBFocusTableCell.h"

@implementation ZBFocusTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 2;
    self.headImageView.layer.masksToBounds= YES;
    [self addSubview:self.headImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = UIColorFromRGB(0x32373e);
    [self addSubview:self.titleLabel];
    
    self.content = [[UILabel alloc] init];
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.content];
    
    self.fansIco = [[UIImageView alloc] init];
    self.fansIco.image = [UIImage imageNamed:@"粉丝数Icon.png"];
    [self addSubview:self.fansIco];
    
    self.fansNum = [[UILabel alloc] init];
    self.fansNum.font = [UIFont systemFontOfSize:12];
    self.fansNum.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.fansNum];
    
    self.topicIco = [[UIImageView alloc] init];
    self.topicIco.image = [UIImage imageNamed:@"帖数_社区.png"];
    [self addSubview:self.topicIco];
    
    self.topicNum = [[UILabel alloc] init];
    self.topicNum.font = [UIFont systemFontOfSize:12];
    self.topicNum.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.topicNum];
    
    //UIColorFromRGB(0xf3f5f6)
    self.lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineView.image = [UIImage imageWithColor:UIColorFromRGB(0xf3f5f6) andSize:CGSizeMake(2, 2)];
    [self addSubview:self.lineView];
    
    //
    self.line = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIImage *lineImg = [UIImage imageWithColor:UIColorFromRGB(0xdbdbdb) andSize:CGSizeMake(2, 2)];
    self.line.image = lineImg;
    [self.lineView addSubview:self.line];
    
    //关注按钮
    self.concernBtn = [[UIButton alloc] init];
    self.concernBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.concernBtn.layer.cornerRadius = 2.0;
    self.concernBtn.layer.masksToBounds = YES;
    [self.concernBtn setBackgroundImage:[UIImage imageWithColor:UIColorWithMobanTheme andSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [self.concernBtn setImage:[UIImage imageNamed:@"社区频道分类_+.png"] forState:UIControlStateNormal];
    NSString *unfocus = [NSString stringWithFormat:@" %@",[ZBAppSetting standardSetting].unfocusName];
    [self.concernBtn setTitle:unfocus forState:UIControlStateNormal];
    [self.concernBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateNormal];
    [self.concernBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0x868788) andSize:CGSizeMake(10, 10)] forState:UIControlStateSelected];
    [self.concernBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
    NSString *focus = [NSString stringWithFormat:@"%@",[ZBAppSetting standardSetting].focusName];
    [self.concernBtn setTitle:focus forState:UIControlStateSelected];
    [self.concernBtn setTitleColor:UIColorWithMobanThemeSub forState:UIControlStateSelected];
    
    [self addSubview:self.concernBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    self.headImageView.frame = CGRectMake(8, 8, 70, 70);
    
    self.titleLabel.frame = CGRectMake(87, 12, 100, 16);
    self.fansIco.frame = CGRectMake(87, CGRectGetMaxY(self.titleLabel.frame) + 2 *8, 13, 12);
    self.fansNum.frame = CGRectMake(CGRectGetMaxX(self.fansIco.frame) + 8, self.fansIco.y, 26, 13);
    self.topicIco.frame = CGRectMake(CGRectGetMaxX(self.fansNum.frame) + 8, self.fansIco.y, 13, 12);
    self.topicNum.frame = CGRectMake(CGRectGetMaxX(self.topicIco.frame) + 8, self.fansIco.y, 26, 13);
    self.content.frame = CGRectMake(87, 62, frame.size.width - 87 -10, 12);
    
    self.lineView.frame = CGRectMake(0, frame.size.height - 8, frame.size.width, 8);
    //底部线
    self.line.frame = CGRectMake(0, 0, frame.size.width, 0.5);
    
    self.concernBtn.frame = CGRectMake(frame.size.width - 8 - 64, 25, 64, 30);
}

+ (CGFloat)cellHeight {
    return 95;
}
@end
