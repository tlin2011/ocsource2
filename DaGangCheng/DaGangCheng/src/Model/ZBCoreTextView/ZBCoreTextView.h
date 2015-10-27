//
//  ZBCoreTextView.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-16.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCoreTextRegularMatch.h"
#import "ZBCoreTextGetSize.h"
#import "ZBCoreTextGetView.h"

@class ZBCoreTextView;
@protocol ZBCoreTextViewDelegate <NSObject>

@optional
- (void)coreTextView:(ZBCoreTextView *)view textTouchBeginRun:(ZBRichTextRun *)run;
- (void)coreTextView:(ZBCoreTextView *)view textTouchEndRun:(ZBRichTextRun *)run;
- (void)coreTextView:(ZBCoreTextView *)view textTouchCanceledRun:(ZBRichTextRun *)run;
@required
- (void)coreTextViewShouldRefresh:(ZBCoreTextView *)coreTextView;
- (void)coreTextView:(ZBCoreTextView *)View clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID;
//- (UIView *)coreTextView:(ZBCoreTextView *)coreTextView getImageViewWithRect:(CGRect)rect;
//- (UIView *)coreTextView:(ZBCoreTextView *)coreTextView getVoiceViewWithRect:(CGRect)rect;
//- (UIView *)coreTextView:(ZBCoreTextView *)coreTextView getSuperCSViewWithRect:(CGRect)rect;

@end

@interface ZBCoreTextView : UIView<ZBCoreTextGetViewDelegate>

@property (strong, nonatomic) NSArray *regularMatchArray;  //正则匹配的数组
@property (weak, nonatomic) id<ZBCoreTextViewDelegate>delegate;

/**
 *  返回ZBCoreTextView高度，通过传人正则匹配数组。
 */
+ (CGFloat)heightFromRegularMatchArray:(NSArray *)rmArray;
@end
