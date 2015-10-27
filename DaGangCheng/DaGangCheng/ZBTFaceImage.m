//
//  ZBTFaceImage.m
//  DaGangCheng
//
//  Created by huaxo on 15-1-9.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBTFaceImage.h"

@implementation ZBTFaceImage

////表情转文字
//+ (NSString *)faceToWord:(NSString *)string runsArray:(NSMutableArray **)runArray {
//    NSError *error;
//    NSString *regulaStr =
//}

//文字转表情
+ (NSString *)wordToFace:(NSString *)string {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    return [self wordToFace:string runsArray:&array];
}

//文字转表情，如果传入数组将返回所有匹配
+ (NSString *)wordToFace:(NSString *)string runsArray:(NSMutableArray **)runArray {
    if (!string) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"(\\[\\S{1,8}?\\])";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //放到匹配数组中
    NSMutableArray* matArrs = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString *substringForMatch = [string substringWithRange:match.range];
        [matArrs addObject:substringForMatch];
    }
    
    for (int i=0; i<[matArrs count]; i++) {
        NSString *faceText = matArrs[i];
        if (!faceText) {
            NSLog(@"faceText:%@,string:%@",faceText,string);
            continue;
        }
        
        NSString *faceId = [self faceIdByFaceText:faceText];
        if (faceId) {
            //替换
            string = [string stringByReplacingOccurrencesOfString:faceText withString:faceId];
            //记录
            [*runArray addObject:faceId];
        }
    }
    //NSLog(@"%@",string);
    return [string copy];
}

+ (NSString *)faceIdByFaceText:(NSString *)faceText {
    //表情对照
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
    //获取此路径下的我们需要的数据
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filepath];
    //NSLog(@"rootdic count %@ , %@",rootDic.allKeys,rootDic);
    NSString *faceId = nil;
    for (NSString *key in rootDic.allKeys) {
        NSString *text = [rootDic valueForKey:key];
        if ([text isEqualToString:faceText]) {
            faceId = key;
        }
    }
    return faceId;
}

+ (NSString *)faceTextByFaceId:(NSString *)faceId {
    if (!faceId) {
        return nil;
    }
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
    
    //获取此路径下的我们需要的数据
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filepath];
    //NSLog(@"rootdic count %@ , %@",rootDic.allKeys,rootDic);
    NSString *faceText = [rootDic valueForKey:faceId];
    return faceText;
}

//过滤ios自带emoji键盘
+(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{// 不让输入表情
    if ([textView isFirstResponder]) {
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
    }
    return YES;
}

//过滤ios自带emoji  https://gist.github.com/cihancimen/4146056
+ (NSString *)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    __block NSMutableString *mString = [NSMutableString string];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         returnValue = NO;
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
         if (!returnValue) {
             [mString appendString:substring];
         }
     }];
    return [mString copy];
}
@end
