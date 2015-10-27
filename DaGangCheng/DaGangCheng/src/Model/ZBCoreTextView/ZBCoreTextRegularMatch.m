//
//  ZBCoreTextRegularMatch.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-16.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCoreTextRegularMatch.h"

@implementation ZBCoreTextRegularMatch

+ (NSArray *)arrayFromString:(NSString *)string {
    if (!string || [string isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    //正则表达式
    NSError *error;
    NSString *regulaStr = @"(\\[img:[0-9]{1,15}\\])|(\\[yy:[0-9]{1,15}:[0-9]{1,15}\\])|(http://cs.opencom.cn/[a-zA-Z0-9]{1,15})";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSRange lastRang = NSMakeRange(0, 0);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSInteger coreTextTag = 0;
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSRange currentRang = match.range;
        
        NSRange range1 = NSMakeRange(-1, -1);
        
        /*
         *加上首部的字符串和匹配字符串之间的字符串
         */
        NSRange range =  NSMakeRange(lastRang.location + lastRang.length, currentRang.location - (lastRang.location + lastRang.length));
        
        if (range.length>0) {
            NSString* substringForMatch = [string substringWithRange:range];
            
            ZBCoreText *coreText = [[ZBCoreText alloc] init];
            coreText.string = substringForMatch;
            coreText.kind = ZBCoreTextKindText;
            coreText.tag = coreTextTag;
            coreTextTag ++;
            
            [array addObject:coreText];
        }
        
        /*
         *加上匹配的字符串
         */
        NSString* substringForMatch = [string substringWithRange:currentRang];
        
        ZBCoreText *coreText = [[ZBCoreText alloc] init];
        coreText.string = substringForMatch;
        coreText.kind = [self coreTextKindFromString:coreText.string];
        coreText.tag = coreTextTag;
        coreTextTag ++;
        
        [array addObject:coreText];
        
        lastRang = currentRang;
    }
    /*
     *加上尾部的字符串
     */
    NSRange range =  NSMakeRange(lastRang.location + lastRang.length, string.length - (lastRang.location + lastRang.length));
    
    if (range.length>0) {
        NSString* substringForMatch = [string substringWithRange:range];
        
        ZBCoreText *coreText = [[ZBCoreText alloc] init];
        coreText.string = substringForMatch;
        coreText.kind = ZBCoreTextKindText;
        coreText.tag = coreTextTag;
        coreTextTag ++;
        
        [array addObject:coreText];
    }
    
    //NSLog(@"arr: %@",array);
    
    return array;
}

+ (ZBCoreTextKind)coreTextKindFromString:(NSString *)string {
    if (!string || [string isKindOfClass:[NSNull class]]) {
#warning todo -- if string is nil
        return ZBCoreTextKindText;
    }
    
    NSArray *array = @[@"^\\[img:[0-9]{1,15}\\]$", @"^\\[yy:[0-9]{1,15}:[0-9]{1,15}\\]$", @"^http://cs.opencom.cn/[a-zA-Z0-9]{1,15}$"];
    NSArray *array2 = @[@(ZBCoreTextKindImage), @(ZBCoreTextKindVoice), @(ZBCoreTextKindSuperCS)];
    
    //@"(\\[img:[0-9]{1,15}\\])|(\\[yy:[0-9]{1,15}:[0-9]{1,15}\\])|(http://cs.opencom.cn/[a-zA-Z0-9]{1,15})";
    
    for (int i=0; i<array.count; i++) {
        if ([self isExistRegularMatchFromString:string regularString:array[i]]) {
            return [(NSNumber *)array2[i] integerValue];
        }
    }

    return ZBCoreTextKindText;
}
/**
 *  判断字符串中是否存在正则匹配
 */
+ (BOOL)isExistRegularMatchFromString:(NSString *)string regularString:(NSString *)regularString {
    if (!string || [string isKindOfClass:[NSNull class]]) {
#warning todo -- if string is nil
        return NO;
    }
    
    if (!regularString || [regularString isKindOfClass:[NSNull class]]) {
#warning todo -- if string is nil
        return NO;
    }
    
    //正则表达式
    NSError *error;
    NSString *regulaStr = regularString;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    if (arrayOfAllMatches && arrayOfAllMatches.count>0) {
        return YES;
    }
    
    return NO;
}

@end
