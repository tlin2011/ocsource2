//
//  ArchiverAndUnarchiver.h
//  DaGangCheng
//
//  Created by huaxo on 14-3-4.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiverAndUnarchiver : NSObject

//归档
-(void)archiverPath:(NSString*)path andData:(id)responseObject andForKey:(NSString *)key;



//反归档

@end
