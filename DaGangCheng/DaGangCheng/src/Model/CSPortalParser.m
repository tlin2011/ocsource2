//
//  CSPortalParser.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "CSPortalParser.h"

@implementation CSPortalParser

+(NSString*)getPostIdFromCSStr:(NSString*)cs
{
    NSLog(@"cs-str:%@",cs);
    NSString *parten = @"(话说\\.[0-9]{1,10})";
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:cs options:NSMatchingReportCompletion range:NSMakeRange(0, [cs length])];
    
    if (match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            NSRange range = [matc range];
            NSLog(@"match::%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[cs substringWithRange:range]);
            range.location+=[(@"话说.") length];
            range.length  -=[(@"话说.") length];
            NSLog(@"cs-post-id:%@",[cs substringWithRange:range]);
            return [cs substringWithRange:range];
        }
    }else{
        NSLog(@"match-num:0");
    }
    return nil;
}

+(NSString*)getIdByCSKey:(NSString*)cs key:(NSString*)key
{
    NSString *parten = [NSString stringWithFormat:@"(%@\\.[0-9]{1,10})",key];
    NSError* error = NULL;
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:cs options:NSMatchingReportCompletion range:NSMakeRange(0, [cs length])];
    
    if (match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            NSRange range = [matc range];
            NSLog(@"match::%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[cs substringWithRange:range]);
            range.location+=([key length]+1);
            range.length  -=([key length]+1);
            NSLog(@"cs-post-id:%@",[cs substringWithRange:range]);
            return [cs substringWithRange:range];
        }
    }else{
        NSLog(@"match-num:0");
    }
    return nil;
}
@end
