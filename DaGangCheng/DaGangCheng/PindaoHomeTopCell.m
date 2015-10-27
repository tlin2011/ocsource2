//
//  PindaoHomeTopCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-21.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoHomeTopCell.h"

@implementation PindaoHomeTopCell
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
    self.ico = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 24, 13)];
    self.ico.image = [[UIImage imageNamed:@"置顶_频道主页.png"] imageWithMobanThemeColor];
    [self addSubview:self.ico];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(41, 12, 269, 15)];
    self.title.textColor = UIColorFromRGB(0x545a65);
    self.title.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.title];
    
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
