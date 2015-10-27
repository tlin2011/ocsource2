//
//  GDLocalizable.h
//  DaGangCheng
//
//  Created by huaxo on 15-7-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//


#import <Foundation/Foundation.h>

// ----- 多语言设置
#define CHINESE @"zh-Hans"
#define ENGLISH @"en"
#define TIBETAN @"bo-CN"
#define GDLocalizedString(key) [[GDLocalizable bundle] localizedStringForKey:(key) value:@"" table:nil]


@interface GDLocalizable : NSObject

+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(void)initUserLanguageToChinese;//初始化语言为中文

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

@end
