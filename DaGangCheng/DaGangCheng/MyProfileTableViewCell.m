//
//  MyProfileTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/6.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyProfileTableViewCell.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@implementation MyProfileTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews{
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    self.myLabel= [[UILabel alloc] initWithFrame:CGRectZero];
    self.myLabel.textColor = UIColorFromRGB(0x333333);
    self.myLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:self.myLabel];
    
    
        //头像
        self.myHeaderImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.myHeaderImage.layer.cornerRadius = 30.0f;
        self.myHeaderImage.layer.masksToBounds = YES;
        self.myHeaderImage.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        self.myHeaderImage.layer.borderWidth = 0.5f;
        [self.contentView addSubview:self.myHeaderImage];

        //昵称
        self.myValLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.myValLabel.textColor = UIColorFromRGB(0x333333);
        self.myValLabel.font = [UIFont systemFontOfSize:19];
        [self.contentView addSubview:self.myValLabel];

    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
  }





-(void)initMyProfileCell{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect frame = self.bounds;
    CGFloat nameLabelX = 28;
    self.myLabel.frame = CGRectMake(nameLabelX, frame.size.height/2.0-15, nameLabelX+100, 35);
    self.myLabel.textColor=kHexRGBAlpha(0x333333,1);
    UIFont *font = [UIFont systemFontOfSize:16.0];
    self.myLabel.font=font;
    CGFloat secondWidth = frame.size.width - CGRectGetMaxX(self.myLabel.frame) - 28;
    
    //self.myLabel.backgroundColor=[UIColor redColor];
    //cell选中时 无背景变化
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (self.cellType==MyProfileTabelViewCellImage) {
        //图片类型文字不需要显示
        self.myValLabel.hidden = YES;
        self.myHeaderImage.hidden=NO;
        //头像
        self.myHeaderImage.frame = CGRectMake(secondWidth+55, 12, 60,60);
        CGRect labelRect=self.myLabel.frame;
        labelRect.origin.y+=15;
        self.myLabel.frame=labelRect;
        
        
        
    } else {
        //文字类型图片不需要显示
        self.myValLabel.hidden = NO;
        self.myHeaderImage.hidden=YES;
        self.myValLabel.frame = CGRectMake(CGRectGetMaxX(self.myLabel.frame)+10,0, secondWidth-15,42);
        self.myValLabel.textAlignment = NSTextAlignmentRight;
        self.myValLabel.textColor=kHexRGBAlpha(0x909090,1);
        //self.myValLabel.backgroundColor=[UIColor redColor];
        
        
    }
    
}
@end
