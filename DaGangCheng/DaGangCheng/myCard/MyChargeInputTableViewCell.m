//
//  MyChargeInputTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyChargeInputTableViewCell.h"

#define NUMBERS @"0123456789\n"

@implementation MyChargeInputTableViewCell



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
    //    self.firstLabel.backgroundColor=[UIColor redColor];
    self.firstLabel.font=[UIFont systemFontOfSize:18];
    [self.contentView addSubview:self.firstLabel];
    
    CGFloat x=CGRectGetMaxX(self.firstLabel.frame)+12;
    CGFloat width=[UIScreen mainScreen].bounds.size.width-x-24;
    
//    CGRect fieldFrame=CGRectMake(CGRectGetMaxX(self.firstLabel.frame)+12,0,150,48);
    CGRect fieldFrame=CGRectMake(x,0,width,48);
    self.inputField=[[UITextField alloc] initWithFrame:fieldFrame];
    self.inputField.font=[UIFont systemFontOfSize:18];
    self.inputField.tag=121;
    [self.inputField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];

    [self.contentView addSubview:self.inputField];
    
}


-(void)textFieldChange{
    
    NSString *str=self.inputField.text;
    if ([self.myChargeDelegate respondsToSelector:@selector(valueChange:)]) {
        [self.myChargeDelegate valueChange:str];
    }
}


-(void)initWithTitle:(NSString *)mtitle placeholder:(NSString *)placeholder color:(UIColor *)mcolor{
    [self initWithTitle:mtitle placeholder:placeholder color:mcolor isNum:YES];
}


-(void)initWithTitle:(NSString *)mtitle placeholder:(NSString *)placeholder color:(UIColor *)mcolor isNum:(BOOL)isNum{
    self.firstLabel.text=mtitle;
    self.firstLabel.textColor=mcolor;
    self.inputField.placeholder=placeholder;
    self.inputField.delegate=self;
    self.isNum=isNum;
}


-(void)initWithTitle:(NSString *)mtitle placeholder:(NSString *)placeholder color:(UIColor *)mcolor isNum:(BOOL)isNum  titleWidth:(CGFloat)width{
    
    CGRect firstLabelFrame=CGRectMake(12,0,width,48);
    self.firstLabel.frame=firstLabelFrame;
    
    
    CGFloat x=CGRectGetMaxX(self.firstLabel.frame)+12;
    CGFloat fieldWidth=[UIScreen mainScreen].bounds.size.width-x-24;

    CGRect fieldFrame=CGRectMake(x,0,fieldWidth,48);

    self.inputField.frame=fieldFrame;
    [self initWithTitle:mtitle placeholder:placeholder color:mcolor isNum:isNum];
    
}



//只能输入数字

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (range.location==0 && range.length==0) {
        if ([string isEqualToString:@"0"]) {
            return NO;
        }
    }
    
    if (self.isNum) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}


@end
