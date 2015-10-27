//
//  NSDictionary+json.h
//  DaGangCheng
//
//  Created by huaxo on 15-5-13.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (json)

/**
 *  字典转json字符串（系统原生）
 *
 *  @return json字符串
 */
- (NSString*)JsonString;

@end
