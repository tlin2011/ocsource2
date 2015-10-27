//
//  ZBRichTextRunEmoji.h
//  ZBRichTextViewDemo
//
//  Created by fuqiang on 2/28/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import "ZBRichTextRunDelegate.h"

@interface ZBRichTextRunEmoji : ZBRichTextRunDelegate

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return ZBRichTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end
