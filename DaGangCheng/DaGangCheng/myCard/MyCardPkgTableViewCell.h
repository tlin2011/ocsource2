//
//  MyCardPkgTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/21.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCardPkgTableViewCell : UITableViewCell



@property(nonatomic,strong)UIImageView *backImageView;

//左上角图标图片
@property(nonatomic,strong)UIImageView *iconImageView;

//标题图标
@property(nonatomic,strong)UILabel *titleLabel;

//右上角引导图标
@property(nonatomic,strong)UIImageView *indicatorImageView;

//内容
@property(nonatomic,strong)UILabel *contentLabel;




-(void)initMyCardPkgTableViewCellWithIconImage:(NSString *)iconImage title:(NSString *)title content:(NSString *)content;


-(void)initMyCardPkgTableViewCellWithBGImage:(NSString *)bgImage IconImage:(NSString *)iconImage title:(NSString *)title content:(NSString *)content;

@end
