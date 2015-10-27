//
//  ZBCoreTextGetView.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-17.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCoreTextGetView.h"

@implementation ZBCoreTextGetView

/**
 *  创建文本控件
 */
- (UIView *)createTextViewFromCoreText:(ZBCoreText *)coreText {
    
    return [self createTextViewFromCoreText:coreText font:[UIFont systemFontOfSize:17.0f] lineSpace:6.0f];
}
- (UIView *)createTextViewFromCoreText:(ZBCoreText *)coreText font:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    
    ZBRichTextView *textView = [[ZBRichTextView alloc] initWithFrame:coreText.rect];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = UIColorFromRGB(0x32373e);
    textView.text = coreText.string;
    textView.lineSpace = lineSpace;
    textView.font = font;
    textView.delegage = self;
    
    return textView;
}

/**
 *  创建图片控件
 */
- (UIView *)createImageViewFromCoreText:(ZBCoreText *)coreText {
    
    UIView *view = [[UIView alloc] initWithFrame:coreText.rect];
    
    NSString *imageID = [coreText.string substringWithRange:NSMakeRange(5, coreText.string.length - 6)];
    NSURL *url = [NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[imageID integerValue] w:coreText.rect.size.width*1.2 h:coreText.rect.size.height*1.2]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, coreText.rect.size.width, coreText.rect.size.height-2*4)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_bg.png"]];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
    [imageView addGestureRecognizer:tap];
    imageView.clipsToBounds = YES;
    
    imageView.tag = [imageID integerValue];
    
    [view addSubview:imageView];
    
    return view;
}

/**
 *  创建语音控件
 */
- (UIView *)createVoiceViewFromCoreText:(ZBCoreText *)coreText {
    
    NSArray* param = [coreText.string componentsSeparatedByString:@":"];
    NSInteger audioId = param.count>=3?[param[1] integerValue]:0;
    NSInteger audioLen = param.count>=3?[param[2] integerValue]:0;
    
    ZBAudioPlayView *audioPlayView = [[ZBAudioPlayView alloc] initWithFrame:coreText.rect];
    audioPlayView.audioID = audioId;
    audioPlayView.audioLen = audioLen;
    
    return audioPlayView;
}

/**
 *  创建超链控件
 */
- (UIView *)createSuperCSViewFromCoreText:(ZBCoreText *)coreText {
    
    ZBSuperCSView *csView = [[ZBSuperCSView alloc] initWithFrame:coreText.rect];
    csView.coreText = coreText;
    csView.delegate = self;
    return csView;
}


- (void)imageViewClicked:(UIGestureRecognizer *)sender {
    UIImageView *v = (UIImageView *)sender.view;
    if (!v) return;
    
    if ([self.delegate respondsToSelector:@selector(coreTextGetView:clickedImageView:imageID:)]) {
        [self.delegate coreTextGetView:self clickedImageView:v imageID:[NSString stringWithFormat:@"%ld",(long)v.tag]];
    }
    
}

#pragma mark -- ZBSuperCSViewDelegate
- (void)supCSViewShouldRefresh:(ZBSuperCSView *)csView {
    if ([self.delegate respondsToSelector:@selector(coreTextGetViewShouldRefresh:)]) {
        [self.delegate coreTextGetViewShouldRefresh:self];
    }
}

#pragma mark -- ZBRichTextViewDelegate
- (void)richTextView:(ZBRichTextView *)view touchBeginRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(coreTextGetView:textTouchBeginRun:)]) {
        [self.delegate coreTextGetView:self textTouchBeginRun:run];
    }
}
- (void)richTextView:(ZBRichTextView *)view touchEndRun:(ZBRichTextRun *)run{
    if ([self.delegate respondsToSelector:@selector(coreTextGetView:textTouchEndRun:)]) {
        [self.delegate coreTextGetView:self textTouchEndRun:run];
    }
}
- (void)richTextView:(ZBRichTextView *)view touchCanceledRun:(ZBRichTextRun *)run{
    if ([self.delegate respondsToSelector:@selector(coreTextGetView:textTouchCanceledRun:)]) {
        [self.delegate coreTextGetView:self textTouchCanceledRun:run];
    }
}

@end
