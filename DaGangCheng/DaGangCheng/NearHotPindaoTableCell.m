//
//  NearHotPindaoTableCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NearHotPindaoTableCell.h"

@implementation NearHotPindaoTableCell
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
    [super initSubviews];
    
    self.addrIco = [[UIImageView alloc] initWithFrame:CGRectMake(87, 64, 10, 10)];
    self.addrIco.image = [UIImage imageNamed:@"定位_附近的人.png"];
    //self.addrIco.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.addrIco];
    
//    self.distance = [[UILabel alloc] initWithFrame:CGRectMake(87 + 10 + 2, 64, 190, 13)];
//    self.distance.font = [UIFont systemFontOfSize:12];
//    self.distance.textColor = UIColorFromRGB(0x98999a);
//    [self addSubview:self.distance];
//    
//    self.addr = [[UILabel alloc] initWithFrame:CGRectMake(87+ 46, 64, 170, 13)];
//    self.addr.font = [UIFont systemFontOfSize:12];
//    self.addr.textColor = UIColorFromRGB(0x98999a);
//    [self addSubview:self.addr];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    CGRect contentFrame = self.content.frame;
    contentFrame.origin.x = 87+10+2;
    self.content.frame = contentFrame;
    
    self.addrIco.frame = CGRectMake(87, self.content.frame.origin.y, 10, 12);
    
}
@end
