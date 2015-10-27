//
//  CFAccount.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFAccount : NSObject

@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *currency_id;

@property (nonatomic, copy) NSString *account_name;  //暂时无用

@property (nonatomic, copy) NSString *currency_name;

@property (nonatomic, strong) NSNumber *currency_type;

@property (nonatomic, strong) NSNumber *sum;

@property (nonatomic, strong) NSNumber *account_state;

@end
