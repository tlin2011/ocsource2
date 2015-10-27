//
//  ZBRichTextView.h
//  ZBRichTextViewDemo
//
//  Created by fuqiang on 2/26/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBRichTextRun.h"
#import "ZBRichTextRunURL.h"
#import "ZBRichTextRunEmoji.h"
#import "ZBRichTextRunTelephone.h"

@class ZBRichTextView;

typedef NS_OPTIONS(NSUInteger, ZBRichTextRunTypeList)
{
    ZBRichTextRunNoneType  = 0,
    ZBRichTextRunURLType   = 1 << 0,
    ZBRichTextRunEmojiType = 1 << 1,
    ZBRichTextRunTelephoneType = 1 << 2,
};

@protocol ZBRichTextViewDelegate<NSObject>

@optional
- (void)richTextView:(ZBRichTextView *)view touchBeginRun:(ZBRichTextRun *)run;
- (void)richTextView:(ZBRichTextView *)view touchEndRun:(ZBRichTextRun *)run;
- (void)richTextView:(ZBRichTextView *)view touchCanceledRun:(ZBRichTextRun *)run;
//fred
- (void)richTextView:(ZBRichTextView *)view modifyAttributedText:(NSMutableAttributedString *)attributedText;
@end

@interface ZBRichTextView : UIView

@property(nonatomic,weak) id<ZBRichTextViewDelegate> delegage;

@property (nonatomic,copy  ) NSString              *text;       // default is nil
@property (nonatomic,copy  ) NSMutableAttributedString *attributedText;
@property (nonatomic,strong) UIFont                *font;       // default is nil (system font 17 plain)
@property (nonatomic,strong) UIColor               *textColor;  // default is nil (text draws black)
@property (nonatomic       ) ZBRichTextRunTypeList runTypeList;
@property (nonatomic)        CGFloat               lineSpace;

+ (NSMutableAttributedString *)createAttributedStringWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

+ (NSArray *)createTextRunsWithAttString:(NSMutableAttributedString *)attString runTypeList:(ZBRichTextRunTypeList)typeList;

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font AttString:(NSMutableAttributedString *)attString;

+ (CGRect)boundingRectWithSize:(CGSize)size font:(UIFont *)font string:(NSString *)string lineSpace:(CGFloat )lineSpace;

@end
