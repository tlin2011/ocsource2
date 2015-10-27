//
//  UpdatePwdTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UpdatePwdTableViewCell.h"

@implementation UpdatePwdTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews{
    
    self.iconImageView= [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconImageView.tag=110;
    [self.contentView addSubview:self.iconImageView];
    
    //竖线
    self.lineView = [[LineView alloc] initWithFrame:CGRectZero];
    self.lineView.tag=111;
    self.lineView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.lineView];
    
    //输入框
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
      self.textField.tag=112;
    [self.contentView addSubview:self.textField];
}


-(void)initUpdatePwdCell:(UIImage *)iconImage placeholder:(NSString *)text{
    
    self.iconImageView.image=iconImage;
    
    self.textField.placeholder=text;
    
    self.textField.tintColor = [UIColor blackColor];
    
    
    self.textField.font=[UIFont systemFontOfSize:14];
    
    self.iconImageView.frame=CGRectMake(15, 12, 20, 20);
    
    self.lineView.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame), 2, 1,self.contentView.frame.size.height-2);
    
    self.textField.frame=CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+5, 0, self.contentView.frame.size.width-CGRectGetMaxX(self.lineView.frame)-10, self.contentView.frame.size.height);
}


-(void)initUpdatePwdCell:(UIImage *)iconImage placeholder:(NSString *)text issecurity:(BOOL)flag{
    [self initUpdatePwdCell:iconImage placeholder:text];
    self.textField.secureTextEntry=flag;
}

@end
