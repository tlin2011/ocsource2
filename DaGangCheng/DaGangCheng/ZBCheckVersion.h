//
//  ZBCheckVersion.h
//  DaGangCheng
//
//  Created by huaxo on 15-2-3.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CustomBlock)(NSDictionary * customDict);
@interface ZBCheckVersion : NSObject

+ (void)netRequestAppstoreVersionPassBlock:(CustomBlock)sender;

@end
