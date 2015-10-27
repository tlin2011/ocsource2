//
//  MyFeedsCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyFeedsCell.h"

@implementation MyFeedsCell
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

- (void)initSubviews {
    
    self.headBg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 6, 54, 54)];
    self.headBg.backgroundColor = [UIColor whiteColor];
    self.headBg.layer.cornerRadius = 27.0;
    self.headBg.layer.borderColor = UIColorFromRGB(0xe3e3e3).CGColor;
    self.headBg.layer.borderWidth = 1;
    self.headBg.layer.masksToBounds = YES;
    [self addSubview:self.headBg];
    
    self.head = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.head.center = self.headBg.center;
    self.head.layer.cornerRadius = 25.0;
    self.head.layer.masksToBounds = YES;
    [self addSubview:self.head];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 150, 16)];
    self.name.font = [UIFont systemFontOfSize:15];
    self.name.textColor = [UIColor blackColor];
    [self addSubview:self.name];
    
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 42, 237, 14)];
    self.msgLabel.font = [UIFont systemFontOfSize:13];
    self.msgLabel.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.msgLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(221, 16, 90, 12)];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
}

@end
