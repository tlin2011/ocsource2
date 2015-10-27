//
//  CFAccountDetail.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFAccountDetail : NSObject

@property (nonatomic, strong) NSString *order_from;
@property (nonatomic, copy) NSString *order_way;
@property (nonatomic, copy) NSString *order_name;
@property (nonatomic, strong) NSNumber *integral;
@property(nonatomic,copy)NSString * create_time_i;

@end
