//
//  MyAlipayTableViewCell.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol MyAlipayTableViewCellDelegate <NSObject>

-(void)clickSelectBtn:(BOOL)flag;

@end

@interface MyAlipayTableViewCell : UITableViewCell<MyAlipayTableViewCellDelegate>

- (IBAction)clickSelect:(UIButton *)sender;


@property(nonatomic,strong)id<MyAlipayTableViewCellDelegate> alipayCellDelegate;


@end
