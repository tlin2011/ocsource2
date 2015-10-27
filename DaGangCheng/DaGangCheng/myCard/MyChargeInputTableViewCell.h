//
//  MyChargeInputTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyChargeInputTableViewCellDelegate <NSObject>

-(void)valueChange:(NSString *)value;

@end


@interface MyChargeInputTableViewCell : UITableViewCell<UITextFieldDelegate>


@property(nonatomic,strong) id<MyChargeInputTableViewCellDelegate> myChargeDelegate;

@property(nonatomic,strong)UILabel *firstLabel;

@property(nonatomic,strong)UITextField *inputField;

@property(nonatomic,strong)NSString *textColor;


@property(nonatomic,assign)BOOL isNum;


@property(nonatomic,assign)NSInteger rate;

-(void)initWithTitle:(NSString *)mtitle placeholder:(NSString *)placeholder color:(UIColor *)mcolor;

-(void)initWithTitle:(NSString *)mtitle placeholder:(NSString *)placeholder color:(UIColor *)mcolor isNum:(BOOL)isNum;

-(void)initWithTitle:(NSString *)mtitle placeholder:(NSString *)placeholder color:(UIColor *)mcolor isNum:(BOOL)isNum titleWidth:(CGFloat)width;

@end
