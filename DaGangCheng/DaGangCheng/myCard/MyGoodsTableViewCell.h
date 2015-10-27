//
//  MyGoodsTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/29.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyGoodsTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,assign)NSArray *goodsArray;


-(void)initWithTitle:(NSString *)mtitle data:(NSArray *)dataArray;


@end
