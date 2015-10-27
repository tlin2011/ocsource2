//
//  LoginViewCell.m
//  wanwan1015
//
//  Created by huaxo2 on 15/10/20.
//  Copyright © 2015年 opencom. All rights reserved.
//

#import "LoginViewCell.h"

@implementation LoginViewCell{
    UIImageView *iconImageView;
    
    UITextField *inputTextField;

}

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}


-(void)initSubviews{
    
    
    CGRect mainRect=[UIScreen mainScreen].bounds;
    
    iconImageView=[[UIImageView alloc] init];
    
    [self addSubview:iconImageView];
    
    inputTextField=[[UITextField alloc] initWithFrame:CGRectMake(63, 0, mainRect.size.width-(57.5*2)-70, 32)];
    
    inputTextField.tag=202;
    
    inputTextField.font=[UIFont systemFontOfSize:14];
    
    [self addSubview:inputTextField];
    

    UILabel *lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(57.5,CGRectGetMaxY(inputTextField.frame), mainRect.size.width-(57.5*2),1)];
    lineLabel.backgroundColor=UIColorFromRGB(0xD2D2D2);
    [self addSubview:lineLabel];
    
}

-(void)setHeadImage:(UIImage *)headImage{
    CGRect mainRect=[UIScreen mainScreen].bounds;
    iconImageView.frame=CGRectMake(63,5, 20, 20);
    iconImageView.image=headImage;
    inputTextField.frame=CGRectMake(CGRectGetMaxX(iconImageView.frame)+10, 0, mainRect.size.width-(57.5*2)-70, 32);
    
}

-(void)setPlaceHodler:(NSString *)placeHodler{
    inputTextField.placeholder=placeHodler;
}



-(void)setIsPwd:(BOOL)isPwd{
    inputTextField.secureTextEntry=isPwd;
}

@end
