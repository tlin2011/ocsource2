//
//  CFAccountInfo.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFAccountInfo : NSObject

@property (nonatomic, copy) NSString * currency_id;
@property (nonatomic, copy) NSString * currency_name;
@property (nonatomic, copy) NSString * currency_type;
@property (nonatomic, strong) NSNumber *sum;
@property (nonatomic, strong) NSNumber *history;
@property (nonatomic, assign) BOOL ret_signIn;
@property (nonatomic, copy) NSString * cs;

@end
