//
//  MyCardPkgTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/21.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyCardPkgTableViewCell.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@implementation MyCardPkgTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}


-(void)initUI{
    int windowWidth=[UIScreen mainScreen ].bounds.size.width;
    float iconImageHeight=32;
    
    self.backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(12, 0, windowWidth-12*2,160)];
    self.backImageView.image=[UIImage imageNamed:@"账户余额-640-背景@2x.png"];
    [self.contentView addSubview:self.backImageView];
    
    CGRect iconImageViewFrame=CGRectMake(12, 12,28,28);
    self.iconImageView=[[UIImageView alloc] initWithFrame:iconImageViewFrame];
    [self.backImageView addSubview:self.iconImageView];

    CGRect titleLabelFrame=CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+9, 12 ,150,iconImageHeight);
    self.titleLabel=[[UILabel alloc] initWithFrame:titleLabelFrame];
    self.titleLabel.font=[UIFont systemFontOfSize:16];
    self.titleLabel.textColor=kHexRGBAlpha(0xffffff,1);
    [self.backImageView addSubview:self.titleLabel];
    
    CGRect indicatorImageViewFrame=CGRectMake(windowWidth-48,20,13,13);
    self.indicatorImageView=[[UIImageView alloc] initWithFrame:indicatorImageViewFrame];
    self.indicatorImageView.image=[UIImage imageNamed:@"箭头.png"];
    [self.backImageView addSubview:self.indicatorImageView];

    CGRect contentLabelFrame=CGRectMake(0,30,windowWidth,120);
    self.contentLabel=[[UILabel alloc] initWithFrame:contentLabelFrame];
    self.contentLabel.font=[UIFont systemFontOfSize:28];
    self.contentLabel.textColor=kHexRGBAlpha(0xffffff,1);
    self.contentLabel.textAlignment =UITextAlignmentCenter;
    self.contentLabel.backgroundColor=[UIColor clearColor];
    [self.backImageView addSubview:self.contentLabel];
}


-(void)initMyCardPkgTableViewCellWithIconImage:(NSString *)iconImage title:(NSString *)title content:(NSString *)content{
    self.iconImageView.image=[UIImage imageNamed:iconImage];
    self.titleLabel.text=title;
    self.contentLabel.text=content;
}


-(void)initMyCardPkgTableViewCellWithBGImage:(NSString *)bgImage IconImage:(NSString *)iconImage title:(NSString *)title content:(NSString *)content{
    self.backImageView.image=[UIImage imageNamed:bgImage];
    self.iconImageView.image=[UIImage imageNamed:iconImage];
    self.titleLabel.text=title;
    self.contentLabel.text=content;
}

@end
