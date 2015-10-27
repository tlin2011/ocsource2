//
//  ZBCoreTextGetSize.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBCoreText.h"
#import "ZBRichTextView.h"

@interface ZBCoreTextGetSize : NSObject

/**
 *  返回带高度的正则匹配数组。
 */
//+ (NSArray *)regularMatchArrayHadHeightFromRegularMatchArray:(NSArray *)rmArray;
+ (NSArray *)regularMatchArrayHadHeightFromRegularMatchArray:(NSArray *)rmArray imageWHs:(NSDictionary *)imageWHs;
+ (NSArray *)regularMatchArrayHadHeightFromRegularMatchArray:(NSArray *)rmArray imageWHs:(NSDictionary *)imageWHs font:(UIFont *)font lineSpace:(CGFloat)lineSpace width:(CGFloat)width;

/**
 *  返回字符串Size，根据ZBCoreText 。
 */
+ (CGSize)coreTextSizeFromCoreText:(ZBCoreText *)coreText imageWHs:(NSDictionary *)imageWHs font:(UIFont *)font lineSpace:(CGFloat)lineSpace width:(CGFloat)width;

/**
 *  将后台返回的 "img_wh" 转换成 ZBCoreTextView 可用的 NSDictionary
 */
+ (NSDictionary *)coreTextImageHWsFromServerImageWHs:(NSDictionary *)imageWHs;
@end
