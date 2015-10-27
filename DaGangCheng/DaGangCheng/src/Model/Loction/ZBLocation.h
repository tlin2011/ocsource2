//
//  ZBLocation.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/4/22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBLocation : NSObject

@property (nonatomic, copy) NSString *formatted_address;    // 地名全称
@property (nonatomic, copy) NSString *province;             // 省名
@property (nonatomic, copy) NSString *city;                 // 市名
@property (nonatomic, copy) NSString *district;             // 区名
@property (nonatomic, copy) NSString *street;               // 路名
@property (nonatomic, copy) NSString *street_number;        // 路号

/**
 *  对象方法字典转模型获取地址信息
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  类方法字典转模型获取地址信息
 */
+ (instancetype)locationWithDict:(NSDictionary *)dict;

@end
