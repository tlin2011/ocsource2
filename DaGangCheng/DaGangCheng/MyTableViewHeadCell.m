//
//  MyTableViewHeadCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-7-22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyTableViewHeadCell.h"

@implementation MyTableViewHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //头像
    self.headView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headView.layer.cornerRadius = 30.0f;
    self.headView.layer.masksToBounds = YES;
    self.headView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    self.headView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:self.headView];
    
    //昵称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:self.nameLabel];
    
    //UID
    self.UIDLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.UIDLabel.textColor = UIColorFromRGB(0x333333);
    self.UIDLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.UIDLabel];
    
    //手机号
    self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.phoneLabel.textColor = UIColorFromRGB(0x333333);
    self.phoneLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.phoneLabel];
    
}

- (void)updateUI {
    
    //头像
    if (self.isLogined) {
        
        NSURL *url = [NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.userImageID w:120]];
        [self.headView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nm.png"]];
    } else {
        [self.headView setImage:[UIImage imageNamed:@"nm.png"]];
    }
    
    
    
    //昵称
    self.nameLabel.text = self.name;
    
    //UID
    self.UIDLabel.text = [NSString stringWithFormat:@"UID：%lld",self.UID];
    
    //手机号
    self.phoneLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"手机号"),self.phoneNumber];
}

+ (CGFloat)heightWithCell {

    return 82;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    CGFloat nameLabelX = 90;
    CGFloat nameLabelWidth = frame.size.width - nameLabelX - 30;
    
    if (!self.isLogined) {
        
        //头像
        self.headView.frame = CGRectMake(12, 12, 60, 60);
        
        //昵称
        self.nameLabel.frame = CGRectMake(nameLabelX, frame.size.height/2.0-10, nameLabelX, 21);
        
        //UID
        self.UIDLabel.hidden = YES;
        
        //手机号
        self.phoneLabel.hidden = YES;
        
    } else {
        
        self.UIDLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        
        //头像
        self.headView.frame = CGRectMake(12, 12, 60, 60);
        
        //昵称
        self.nameLabel.frame = CGRectMake(nameLabelX, 15, nameLabelWidth, 21);
        
        //UID
        self.UIDLabel.frame = CGRectMake(nameLabelX, 39, nameLabelWidth, 14);
        
        //手机号
        self.phoneLabel.frame = CGRectMake(nameLabelX, 54, nameLabelWidth, 14);
    }
}

@end
