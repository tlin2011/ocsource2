//
//  UpdateValidTableViewCell.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UpdateValidTableViewCell.h"

#import "UpdatePwdTableViewCell.h"

@implementation UpdateValidTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews{
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.tag=111;
    self.textField.placeholder=GDLocalizedString(@"请输入验证码！");
    
    
    self.textField.font=[UIFont systemFontOfSize:14];
    
    CGRect textFieldFrame=CGRectMake(20, 5, self.contentView.frame.size.width*0.7,34);
    
    self.textField.frame=textFieldFrame;
    
    [self.contentView addSubview:self.textField];

    
    //验证按钮
    self.validButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.validButton setTitle:GDLocalizedString(@"验证码") forState:UIControlStateNormal];
    

    self.validButton.titleLabel.font=[UIFont systemFontOfSize:12.0];
    
    
    [self.validButton addTarget:self action:@selector(clickBtnValidateCode) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect validButtonFrame=CGRectMake(CGRectGetMaxX(self.textField.frame)+10, 10, self.contentView.frame.size.width*0.15,24);
    
    self.validButton.frame=validButtonFrame;
    
    self.validButton.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:self.validButton];
}


-(void)clickBtnValidateCode{
    if ([self.delegate respondsToSelector:@selector(getValidateCode)]) {
        [self.delegate getValidateCode];
    }
}


@end
