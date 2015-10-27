//
//  PindaoHomeFansCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-21.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoHomeFansCell.h"
@interface PindaoHomeFansCell ()

@end
@implementation PindaoHomeFansCell

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
    self.ico = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 32, 32)];
    self.ico.image = [UIImage imageNamed:@"频道粉丝_频道主页.png"];
    [self addSubview:self.ico];
    
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(46, 15, 63, 16)];
    NSString *labTitle = [NSString stringWithFormat:@"%@%@",[ZBAppSetting standardSetting].pindaoName, GDLocalizedString(@"粉丝")];
    self.lab.text = labTitle;
    self.lab.textColor = UIColorWithMobanTheme;
    self.lab.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.lab];

    self.fansNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(111, 15, 60, 16)];
    self.fansNumLabel.font = [UIFont systemFontOfSize:15];
    self.fansNumLabel.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.fansNumLabel];
    
    //分割线
    self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineImgView.backgroundColor = UIColorFromRGB(0xc8c7cc);
    [self addSubview:self.lineImgView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineImgView.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
}

@end
