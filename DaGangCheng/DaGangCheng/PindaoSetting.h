//
//  PindaoSetting.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-7.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PindaoSetting : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) int value;

+ (NSString *)pindaoSettingTitleByValue:(NSInteger)value;
@end
