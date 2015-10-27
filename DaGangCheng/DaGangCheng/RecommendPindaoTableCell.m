//
//  RecommendPindaoTableCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "RecommendPindaoTableCell.h"

@implementation RecommendPindaoTableCell

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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void) initSubviews {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 11, 180, 18)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = UIColorFromRGB(0x32373e);
    [self addSubview:self.titleLabel];
    
    self.recommendIco = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth - 34, 0, 34, 18)];
    self.recommendIco.image = [UIImage imageNamed:@"推荐Lab_社区.png"];
    [self addSubview:self.recommendIco];
    
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(87, 64, 220, 13)];
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.content];
    
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 70, 70)];
    self.headImageView.layer.cornerRadius = 4;
    self.headImageView.layer.masksToBounds = YES;
    [self addSubview:self.headImageView];
    
    self.fansIco = [[UIImageView alloc] initWithFrame:CGRectMake(87, 42, 13, 12)];
    self.fansIco.image = [UIImage imageNamed:@"粉丝数Icon.png"];
    [self addSubview:self.fansIco];
    
    self.fansNum = [[UILabel alloc] initWithFrame:CGRectMake(103, 42, 26, 13)];
    self.fansNum.font = [UIFont systemFontOfSize:12];
    self.fansNum.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.fansNum];
    
    self.topicIco = [[UIImageView alloc] initWithFrame:CGRectMake(120, 42, 13, 12)];
    self.topicIco.image = [UIImage imageNamed:@"帖数_社区.png"];
    [self addSubview:self.topicIco];
    
    self.topicNum = [[UILabel alloc] initWithFrame:CGRectMake(140, 42, 26, 13)];
    self.topicNum.font = [UIFont systemFontOfSize:12];
    self.topicNum.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.topicNum];
}

@end
