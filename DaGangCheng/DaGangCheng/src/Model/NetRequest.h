//
//  NetRequest.h
//  DaGangCheng
//
//  Created by huaxo on 14-3-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiUrl.h"
#import "UIDevice+IdentifierAddition.h"
#import "SQLDataBase.h"
#import "AFNetWorking.h"
#import "HuaxoUtil.h"

typedef void(^CustomBlock)(NSDictionary * customDict);

@interface NetRequest : NSObject

//异步请求
-(void)urlStr:(NSString*)urlStr parameters:(NSDictionary*)parameters passBlock:(CustomBlock)sender;
+ (void)urlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)requestUdidSession;
+(void)requestUdidSessionCompletion:(void (^)(BOOL finished))completion;
+ (void)requestUdidInfo;
+ (void)requestUdidInfoCompletion:(void (^)(BOOL finished))completion;

+ (void)requestAddrWithLat:(float)lat lng:(float)lng passBlock:(CustomBlock)sender;


//财富系统相关


@end
