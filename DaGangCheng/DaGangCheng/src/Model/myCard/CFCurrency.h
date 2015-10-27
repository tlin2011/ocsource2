//
//  Currency.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFCurrency : NSObject

@property(nonatomic,copy)NSString *currency_id;

@property(nonatomic,copy)NSString *currency_name;

@property(nonatomic,copy)NSString *currency_type;

@property(nonatomic,copy)NSString *rate;

@end
