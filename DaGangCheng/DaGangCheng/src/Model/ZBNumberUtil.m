//
//  ZBNumberUtil.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-19.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBNumberUtil.h"

@implementation ZBNumberUtil

+ (NSString *)shortStringByString:(NSString *)string {
    NSInteger integer = [string integerValue];
    return [self shortStringByInteger:integer];
}

+ (NSString *)shortStringByNumber:(NSNumber *)number {
    NSInteger integer = [number integerValue];
    return [self shortStringByInteger:integer];
}

+ (NSString *)shortStringByInteger:(NSInteger)integer {
    
    NSString *resultStr = nil;
    
    if (integer < 10000) {
        
        resultStr = [NSString stringWithFormat:@"%ld",(long)integer];
        
    }
    else if (integer < 10 * 10000) {
        
        CGFloat f = integer * 1.0 / 10000;
        resultStr = [NSString stringWithFormat:@"%.1f万",f];
        
    }
    else if (integer < 100 * 10000) {
        
        CGFloat f = integer * 1.0 / 10000;
        resultStr = [NSString stringWithFormat:@"%.0f万",f];
        
    }
    else if (integer < 1000 * 10000) {
        
        CGFloat f = integer * 1.0 / 10000;
        resultStr = [NSString stringWithFormat:@"%.0f万",f];
        
    }
    else if (integer < 10000 * 10000) {
        
        CGFloat f = integer * 1.0 / (10000 * 10000);
        resultStr = [NSString stringWithFormat:@"%.1f亿",f];
        
    }
    else if (integer < 10 * 10000 * 10000) {
        
        CGFloat f = integer * 1.0 / (10000 * 10000);
        resultStr = [NSString stringWithFormat:@"%.1f亿",f];
        
    }
    else {
        
        CGFloat f = integer * 1.0 / (10000 * 10000);
        resultStr = [NSString stringWithFormat:@"%.0f亿",f];
        
    }
    
    return resultStr;
}
@end
