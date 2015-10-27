//
//  UpdatePwdTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineView.h"

@interface UpdatePwdTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;

@property(nonatomic,strong)LineView *lineView;

@property(nonatomic,strong)UITextField *textField;


-(void)initUpdatePwdCell:(UIImage *)iconImage placeholder:(NSString *)text;

-(void)initUpdatePwdCell:(UIImage *)iconImage placeholder:(NSString *)text issecurity:(BOOL)flag;

@end
