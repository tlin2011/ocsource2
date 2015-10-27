//
//  MyChargeTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyChargeTableViewCell.h"


@implementation MyChargeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubview];
    }
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}


-(void)initSubview{
    CGRect firstLabelFrame=CGRectMake(12,0,120,48);
    self.firstLabel=[[UILabel alloc] initWithFrame:firstLabelFrame];
    self.firstLabel.font=[UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.firstLabel];

    CGRect valueLabelFrame=CGRectMake(CGRectGetMaxX(self.firstLabel.frame)+12,0,200,48);
    self.valueLabel=[[UILabel alloc] initWithFrame:valueLabelFrame];
    self.valueLabel.font=[UIFont systemFontOfSize:18];
    self.valueLabel.textAlignment=UITextAlignmentLeft;
    self.valueLabel.tag=101;
    [self.contentView addSubview:self.valueLabel];
    
}


-(void)initWithTitle:(NSString *)mtitle value:(NSString *)mvalue color:(UIColor *)mcolor{
    
    self.firstLabel.text=mtitle;
    self.firstLabel.textColor=mcolor;
    self.valueLabel.text=mvalue;
    self.valueLabel.textColor=mcolor;
}


-(void)initWithTitle:(NSString *)mtitle value:(NSString *)mvalue color:(UIColor *)mcolor titleWidth:(CGFloat)width{
    
    CGRect firstLabelFrame=CGRectMake(12,0,width,48);
    self.firstLabel.frame=firstLabelFrame;
    
    CGRect valueLabelFrame=CGRectMake(CGRectGetMaxX(self.firstLabel.frame)+12,0,200,48);
    self.valueLabel.frame=valueLabelFrame;
    if ([mvalue length]>12) {
        self.valueLabel.font=[UIFont systemFontOfSize:15];
    }
    [self initWithTitle:mtitle value:mvalue color:mcolor];
}

@end
