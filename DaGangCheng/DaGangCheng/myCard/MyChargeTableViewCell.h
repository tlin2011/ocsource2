//
//  MyChargeTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]



@interface MyChargeTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *firstLabel;

@property(nonatomic,strong)UILabel *valueLabel;

@property(nonatomic,strong)NSString *textColor;


-(void)initWithTitle:(NSString *)mtitle value:(NSString *)mvalue color:(UIColor *)mcolor;

-(void)initWithTitle:(NSString *)mtitle value:(NSString *)mvalue color:(UIColor *)mcolor titleWidth:(CGFloat)width;

@end
