//
//  ZBRichTextRunEmoji.m
//  ZBRichTextViewDemo
//
//  Created by fuqiang on 2/28/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import "ZBRichTextRunEmoji.h"

@implementation ZBRichTextRunEmoji

/**
 *  返回表情数组
 */
+ (NSArray *) emojiStringArray
{
    return [NSArray arrayWithObjects:@"[smile]",@"[cry]",@"[hei]",nil];
}

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return ZBRichTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    
    NSString *string = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    
    NSError *error = nil;
    NSString *regulaStr = @"(\\[f[0-1]{1}[0-9]{1}[0-9]{1}\\])";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error == nil) {
        
        NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        
        NSInteger subLen = 0;
        
        for (NSTextCheckingResult *match in arrayOfAllMatches) {
            
            NSString *emojiStr = [string substringWithRange:NSMakeRange(match.range.location-subLen, match.range.length)];
            
            {
                //[attributedString replaceCharactersInRange:match.range withString:@" "];

                ZBRichTextRunEmoji *run = [[ZBRichTextRunEmoji alloc] init];
                run.range    = NSMakeRange(match.range.location-subLen, 1);
                run.text     = emojiStr;
                run.drawSelf = YES;
                [run decorateToAttributedString:attributedString range:run.range];
                
                [attributedString replaceCharactersInRange:NSMakeRange(match.range.location-subLen, match.range.length) withString:@" "];
                
                subLen += match.range.length - 1;  //削减的元素长度
                
                [array addObject:run];
            }
            
        }
    }
    
    return array;
    
//    NSString *markL       = @"[";
//    NSString *markR       = @"]";
//    NSString *string      = attributedString.string;
//    NSMutableArray *array = [NSMutableArray array];
//    NSMutableArray *stack = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < string.length; i++)
//    {
//        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
//        
//        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
//        {
//            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
//            {
//                [stack removeAllObjects];
//            }
//            
//            [stack addObject:s];
//            
//            if ([s isEqualToString:markR] || (i == string.length - 1))
//            {
//                NSMutableString *emojiStr = [[NSMutableString alloc] init];
//                for (NSString *c in stack)
//                {
//                    [emojiStr appendString:c];
//                }
//                
//                if ([[ZBRichTextRunEmoji emojiStringArray] containsObject:emojiStr])
//                {
//                    NSRange range = NSMakeRange(i + 1 - emojiStr.length, emojiStr.length);
//                    
//                    [attributedString replaceCharactersInRange:range withString:@" "];
//                    
//                    ZBRichTextRunEmoji *run = [[ZBRichTextRunEmoji alloc] init];
//                    run.range    = NSMakeRange(i + 1 - emojiStr.length, 1);
//                    run.text     = emojiStr;
//                    run.drawSelf = YES;
//                    [run decorateToAttributedString:attributedString range:run.range];
//                    
//                    [array addObject:run];
//                }
//                
//                [stack removeAllObjects];
//            }
//        }
//    }
//    
//    return array;
}

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
    CGRect neRect = rect;
    neRect.origin.y -= neRect.size.width * 0.25;
    neRect.size.height = neRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSString* imgStr = [self.text substringWithRange:NSMakeRange(1, [self.text length]-2)];
    
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",imgStr];
    
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, neRect, image.CGImage);
    }
}

- (void)dealloc {

}

@end
