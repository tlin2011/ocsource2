//
//  ZBRichTextRunTelephone.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBRichTextRunDelegate.h"

@interface ZBRichTextRunTelephone : ZBRichTextRun

/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return ZBRichTextRunURL对象数组
 */
+ (NSArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString;

@end
