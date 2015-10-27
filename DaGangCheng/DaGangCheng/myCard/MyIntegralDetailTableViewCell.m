//
//  MyIntegralDetailTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyIntegralDetailTableViewCell.h"


#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@implementation MyIntegralDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initSubview];
    }
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
    
}


-(void)initSubview{
    
    
    CGRect sourceLabelFrame=CGRectMake(12,0,150,24);
    self.sourceLabel=[[UILabel alloc] initWithFrame:sourceLabelFrame];
    self.sourceLabel.font=[UIFont systemFontOfSize:14];
    
    self.sourceLabel.textColor=kHexRGBAlpha(0x232323,1);
    [self.contentView addSubview:self.sourceLabel];
    
    
    
    CGRect titleLabelFrame=CGRectMake(CGRectGetMaxX(self.sourceLabel.frame)+4,0,10,24);
    self.titleLabel=[[UILabel alloc] initWithFrame:titleLabelFrame];
    //    self.firstLabel.backgroundColor=[UIColor redColor];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    self.titleLabel.textColor=kHexRGBAlpha(0x232323,1);
    [self.contentView addSubview:self.titleLabel];
    
    
    CGRect timeLabelFrame=CGRectMake(sourceLabelFrame.origin.x,CGRectGetMaxY(sourceLabelFrame),150,20);
    self.timeLabel=[[UILabel alloc] initWithFrame:timeLabelFrame];
    self.timeLabel.font=[UIFont systemFontOfSize:11];
    //    self.valueLabel.backgroundColor=[UIColor redColor];
    self.timeLabel.textColor=kHexRGBAlpha(0x9fa0a0,1);
    [self.contentView addSubview:self.timeLabel];
    
    
    
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
    
    
    CGRect priceLabelFrame=CGRectMake(width-130,0,120,48);
    self.priceLabel=[[UILabel alloc] initWithFrame:priceLabelFrame];
    self.priceLabel.font=[UIFont systemFontOfSize:15];
    
    self.priceLabel.textAlignment=UITextAlignmentRight;
    
    [self.contentView addSubview:self.priceLabel];

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}


-(void)initWithSource:(NSString *)source title:(NSString *)mtitle time:(NSString *)mtime price:(NSString *)mprice priceColor:(UIColor *)priceColor{
    
    self.sourceLabel.text=source;
    self.titleLabel.text=mtitle;
    self.timeLabel.text=mtime;
    self.priceLabel.text=mprice;
    
    self.priceLabel.textColor=priceColor;
}
@end
