//
//  ZBLocationManager.h
//  48-地图和定位
//
//  Created by 郑遥 on 15-4-19.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Singleton.h"
@class ZBLocation;
typedef void(^locationBlock)(CLLocationCoordinate2D coor);
typedef void(^addressBlock)(NSString *address);
typedef void(^detailAddressBlock)(ZBLocation *loca);

@interface ZYLocationManager : NSObject
singleton_interface(ZYLocationManager)

/**
 *  获取纠偏后的经纬度(百度地图经纬度)
 */
- (void) getLocationCoordinate:(locationBlock) locaiontBlock;

/**
 *  获取纠偏后的经纬度(百度地图经纬度)和地址
 */
- (void) getLocationCoordinate:(locationBlock) locaiontBlock address:(addressBlock) addressBlock;

/**
 *  获取纠偏后的经纬度(百度地图经纬度)和详细地址
 */
- (void) getLocationCoordinate:(locationBlock) locaiontBlock detailAddress:(detailAddressBlock) detailAddressBlock;

@end
