//
//  CFOrder.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/28.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFOrder : NSObject



@property(nonatomic,copy)NSString * order_sn;
@property(nonatomic,strong)NSNumber * pay_money;
@property(nonatomic,strong)NSNumber * integral;
@property(nonatomic,copy)NSString *order_name;
@property(nonatomic,copy)NSString *order_detail;

@end
