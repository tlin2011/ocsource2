//
//  NetRequestAll.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-25.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CustomBlock)(NSDictionary * customDict);
@interface NetRequestAll : NSObject

//请求app配置
+ (void)requestAppSetting:(CustomBlock)sender;
@end
