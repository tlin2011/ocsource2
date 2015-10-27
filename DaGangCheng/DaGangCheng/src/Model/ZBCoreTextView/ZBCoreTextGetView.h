//
//  ZBCoreTextGetView.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBCoreText.h"
#import "ApiUrl.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "ZBAudioPlayView.h"
#import "ZBSuperCSView.h"
#import "ZBRichTextView.h"


@class ZBCoreTextGetView;

@protocol ZBCoreTextGetViewDelegate <NSObject>
@optional
- (void)coreTextGetView:(ZBCoreTextGetView *)getView textTouchBeginRun:(ZBRichTextRun *)run;
- (void)coreTextGetView:(ZBCoreTextGetView *)getView textTouchEndRun:(ZBRichTextRun *)run;
- (void)coreTextGetView:(ZBCoreTextGetView *)getView textTouchCanceledRun:(ZBRichTextRun *)run;

@required
- (void)coreTextGetViewShouldRefresh:(ZBCoreTextGetView *)coreTextGetView;
- (void)coreTextGetView:(ZBCoreTextGetView *)getView clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID;
@end

@interface ZBCoreTextGetView : NSObject<ZBSuperCSViewDelegate,ZBRichTextViewDelegate>

@property (weak,  nonatomic) id<ZBCoreTextGetViewDelegate>delegate;

/**
 *  创建文本控件
 */
- (UIView *)createTextViewFromCoreText:(ZBCoreText *)coreText;
- (UIView *)createTextViewFromCoreText:(ZBCoreText *)coreText font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

/**
 *  创建图片控件
 */
- (UIView *)createImageViewFromCoreText:(ZBCoreText *)coreText;

/**
 *  创建语音控件
 */
- (UIView *)createVoiceViewFromCoreText:(ZBCoreText *)coreText;

/**
 *  创建超链控件
 */
- (UIView *)createSuperCSViewFromCoreText:(ZBCoreText *)coreText;

@end
