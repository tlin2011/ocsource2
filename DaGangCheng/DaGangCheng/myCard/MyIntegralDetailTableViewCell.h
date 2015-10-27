//
//  MyIntegralDetailTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>



#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface MyIntegralDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *sourceLabel;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *priceLabel;


-(void)initWithSource:(NSString *)source title:(NSString *)mtitle time:(NSString *)mtime price:(NSString *)mprice priceColor:(UIColor *)priceColor;


@end
