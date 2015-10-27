//
//  FriendItemCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "FriendItemCell.h"

@implementation FriendItemCell

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

- (void)initSubviews {
    self.headBg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 54, 54)];
    self.headBg.backgroundColor = [UIColor whiteColor];
    self.headBg.layer.cornerRadius = 27.0;
    self.headBg.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
    self.headBg.layer.borderWidth = 1;
    self.headBg.layer.masksToBounds = YES;
    [self addSubview:self.headBg];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.imgView.center = self.headBg.center;
    self.imgView.layer.cornerRadius = 25.0;
    self.imgView.layer.masksToBounds = YES;
    [self addSubview:self.imgView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 150, 16)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 42, 237, 14)];
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.descLabel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
