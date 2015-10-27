//
//  ZBLocation.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/4/22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBLocation.h"

@implementation ZBLocation

- (instancetype)initWithDict:(NSDictionary *)dict
{
    NSDictionary *addressComponent = dict[@"addressComponent"];
    if (self = [super init]) {
        _formatted_address = dict[@"formatted_address"];
        _province = addressComponent[@"province"];
        _city = addressComponent[@"city"];
        _district = addressComponent[@"district"];
        _street = addressComponent[@"street"];
        _street_number = addressComponent[@"street_number"];
    }
    return self;
}

+ (instancetype)locationWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
