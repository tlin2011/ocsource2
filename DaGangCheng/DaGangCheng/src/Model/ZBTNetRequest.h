//
//  ZBTNetRequest.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBTNetRequest : NSObject

@property(nonatomic,copy) NSString * baseUrl;
@property(nonatomic,copy) NSDictionary * prepareDict;



-(instancetype)initWithBaseUrl:(NSString *)baseStr prepareDict:(NSDictionary *)prepareDict;

- (void)postJSONWithUrlStr:(NSString *)urlUrl parameters:(id)parameters  success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;



+ (void)postJSONWithBaseUrl:(NSString *)baseStr urlStr:(NSString *)urlStr parameters:(id)parameters  success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

@end
