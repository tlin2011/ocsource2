//
//  CSPortalParser.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPortalParser : NSObject
+(NSString*)getPostIdFromCSStr:(NSString*)cs;
+(NSString*)getIdByCSKey:(NSString*)cs key:(NSString*)key;
@end
