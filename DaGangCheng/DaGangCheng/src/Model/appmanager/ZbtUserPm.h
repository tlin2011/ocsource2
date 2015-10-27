//
//  NSUserPm.h
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZbtUserPm : NSObject

@property(nonatomic,assign) BOOL ret;

@property(nonatomic,strong) NSString *msg;

@property(nonatomic,strong) NSString *uid;

@property(nonatomic,strong) NSString *pm;

@property(nonatomic,strong) NSArray *kind_ids;

@end
