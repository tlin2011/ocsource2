//
//  ZYLocationManager.m
//  48-地图和定位
//
//  Created by 郑遥 on 15-4-19.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ZYLocationManager.h"
#import "AFNetworking.h"
#import "ZBLocation.h"

#define IOS_Version [[UIDevice currentDevice].systemVersion floatValue]

@interface ZYLocationManager ()<CLLocationManagerDelegate>{
// 保存block
    locationBlock _locationBlock;
    addressBlock _addressBlock;
    detailAddressBlock _detailAddressBlock;
}

@property (nonatomic, strong) CLLocationManager *lm;

@end

@implementation ZYLocationManager
singleton_implementation(ZYLocationManager)

/**
 *  懒加载
 */
- (CLLocationManager *)lm
{
    if (!_lm) {
        _lm = [[CLLocationManager alloc] init];
        _lm.delegate = self;
        // 定位精准度
        _lm.desiredAccuracy = kCLLocationAccuracyBest;
        // 重新定位的距离
        _lm.distanceFilter = 50.0f;
    }
    return _lm;
}

/**
 *  开始加载
 */
- (void)startLocation
{
    // 判断定位操作是否被允许
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    // ios8后需要向用户请求权限
    if (IOS_Version >= 8.0) {
        [self.lm requestWhenInUseAuthorization];
        [self.lm requestAlwaysAuthorization];
    }
    // 开始定位
    [self.lm startUpdatingLocation];
}

#pragma mark - CLLocationManager获取经纬度的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coor = location.coordinate;
//    NSLog(@"纬度：%.6f 经度%.6f", coor.latitude, coor.longitude);
    NSString *x1 = [NSString stringWithFormat:@"%f", coor.longitude];
    NSString *y1 = [NSString stringWithFormat:@"%f", coor.latitude];
    // http://api.map.baidu.com/ag/coord/convert?from=0&to=2&x=113.377346&y=23.132648
    NSDictionary *dict1 = @{@"from":@"0",
                            @"to":@"2",
                            @"x":x1,
                            @"y":y1
                            };
    AFHTTPRequestOperationManager *roManager = [AFHTTPRequestOperationManager manager];
    // 1、ios系统经纬度（国际标准）转谷歌经纬度
    [roManager GET:@"http://api.map.baidu.com/ag/coord/convert" parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"error"] integerValue]) {
            ZBLog(@"ios系统经纬度（国际标准）转谷歌经纬度失败！！！");
            return ;
        }
        NSString *resultX = [self base64Decode:responseObject[@"x"]];
        NSString *resultY = [self base64Decode:responseObject[@"y"]];
        NSDictionary *dict2 = @{@"from":@"2",
                  @"to":@"4",
                  @"x":resultX,
                  @"y":resultY
                  };
        
        // 2、谷歌经纬度转百度经纬度
        [roManager GET:@"http://api.map.baidu.com/ag/coord/convert" parameters:dict2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"error"] integerValue]) {
                ZBLog(@"谷歌经纬度转百度经纬度失败！！！");
                return ;
            }
            NSString *rx = [self base64Decode:responseObject[@"x"]];
            NSString *ry = [self base64Decode:responseObject[@"y"]];
            CLLocationCoordinate2D resultCoor = CLLocationCoordinate2DMake([ry floatValue], [rx floatValue]);
            NSLog(@"转换后------------%f", [rx floatValue]);
            // 给block赋值
            if (_locationBlock) {
                _locationBlock(resultCoor);
            }
            
            [self getAddressWithCoordinate:resultCoor];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];    
    // 停止定位
    [self.lm stopUpdatingLocation];
}

- (void)getLocationCoordinate:(locationBlock)locaiontBlock
{
    _locationBlock = locaiontBlock;
    [self startLocation];
}

- (void)getLocationCoordinate:(locationBlock)locaiontBlock address:(addressBlock)addressBlock
{
    _locationBlock = locaiontBlock;
    _addressBlock = addressBlock;
    [self startLocation];
}

- (void)getLocationCoordinate:(locationBlock)locaiontBlock detailAddress:(detailAddressBlock)detailAddressBlock
{
    _locationBlock = locaiontBlock;
    _detailAddressBlock = detailAddressBlock;
    [self startLocation];
}

#pragma mark - base64解密
- (NSString *)base64Decode:(NSString *)str
{
    // 1、加密字符串转二进制数据
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // 2、二进制数据转字符串
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 经纬度转地址
- (void)getAddressWithCoordinate:(CLLocationCoordinate2D)coor
{
    if (coor.latitude == 0 || coor.longitude == 0){
        ZBLog(@"经纬度为空");
        return;
    }
    
    NSString *baiduMap_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"baiduMap_key"];
    
    NSDictionary * parmeters = @{@"key":baiduMap_key,
                                 @"output":@"json",
                                 @"location":[NSString stringWithFormat:@"%f,%f",coor.latitude,coor.longitude]
                                 };
    // http://api.map.baidu.com/geocoder?output=json&location=23.134074,113.379866&key=37492c0ee6f924cb5e934fa08c6b1676
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.map.baidu.com/geocoder" parameters:parmeters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (![responseObject[@"status"] isEqualToString:@"OK"]) {
            ZBLog(@"获取地址失败");
            return;
        }
        NSDictionary *result = responseObject[@"result"];
        ZBLocation *loca = [ZBLocation locationWithDict:result];
        
        ZBLog(@"address----------%@", loca);
        if (_addressBlock) {
            _addressBlock(loca.formatted_address);
        }
        
        if (_detailAddressBlock) {
            _detailAddressBlock(loca);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZBLog(@"%@", error);
    }];
}

@end