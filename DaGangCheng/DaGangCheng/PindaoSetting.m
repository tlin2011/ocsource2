//
//  PindaoSetting.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-7.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoSetting.h"

@implementation PindaoSetting

+ (NSString *)pindaoSettingTitleByValue:(NSInteger)value {
    NSString *title = @"";
    if (value & 0x01) {
        title = [title stringByAppendingString:@"匿名"];
        title = [title stringByAppendingString:@","];
    }
    if (value & 0x02) {
        title = [title stringByAppendingString:@"图片"];
        title = [title stringByAppendingString:@","];
    }
    if (value & 0x04) {
        title = [title stringByAppendingString:@"语音"];
        title = [title stringByAppendingString:@","];
    }
    if (value & 0x08) {
        title = [title stringByAppendingString:@"管理员"];
        title = [title stringByAppendingString:@","];
    }
    if (value & 0x10) {
        title = [title stringByAppendingString:@"保护"];
        title = [title stringByAppendingString:@","];
    }
    
    title = title.length>=1?[title substringToIndex:title.length-1] : title;
    return title;
}

@end
