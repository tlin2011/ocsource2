//
//  ZBCoreTextView.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-16.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBCoreTextView.h"

@interface ZBCoreTextView ()

@property (assign, nonatomic) CGFloat indexHeight;         //计算view.frame.origin.y


@property (strong, nonatomic) ZBCoreTextGetView *createView;
@end

@implementation ZBCoreTextView

- (ZBCoreTextGetView *)createView {
    if (!_createView) {
        _createView = [[ZBCoreTextGetView alloc] init];
        _createView.delegate = self;
    }
    return _createView;
}

- (void)setRegularMatchArray:(NSArray *)regularMatchArray {
    _regularMatchArray = regularMatchArray;
    
    @synchronized(self) {
        for (int i=0; i<self.subviews.count; i++) {
            UIView *v = self.subviews[i];
            
            for (int i=0; i<v.subviews.count; i++) {
                UIView *subV = v.subviews[i];
                [subV removeFromSuperview];
                subV = nil;
            }
            
            [v removeFromSuperview];
            v = nil;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
//    for (int i=0; i<self.subviews.count; i++) {
//        //[view removeFromSuperview];
//        UIView *v = self.subviews[i];
//        NSLog(@"%d.viewframe=%@",i,NSStringFromCGRect(v.frame));
//    }
    
    self.indexHeight = 0.0;
    
    for (ZBCoreText *coreText in self.regularMatchArray) {
        
        CGRect rect = coreText.rect;
        rect.origin.y = self.indexHeight;
        coreText.rect = rect;
        self.indexHeight += coreText.rect.size.height;
        
        UIView *view = nil;
        
        for (UIView *v in self.subviews) {
            if (v.tag == coreText.tag) {
                
                view = v;
                
                NSString *vFrameStr = NSStringFromCGRect(v.frame);
                NSString *rectStr = NSStringFromCGRect(coreText.rect);
                
                if (![vFrameStr isEqualToString:rectStr]) {

                    view.frame = coreText.rect;
                    [view layoutSubviews];
                    
                }
                break;
            }
        }
        
        if (!view) {
            
            if (coreText.kind == ZBCoreTextKindText) {
                
                view = [[self createView] createTextViewFromCoreText:coreText];
                view.tag = coreText.tag;
                
            } else if (coreText.kind == ZBCoreTextKindImage) {
                
                view = [[self createView] createImageViewFromCoreText:coreText];
                view.tag = coreText.tag;
                
            } else if (coreText.kind == ZBCoreTextKindVoice) {
                
                view = [[self createView] createVoiceViewFromCoreText:coreText];
                view.tag = coreText.tag;
                
            } else if (coreText.kind == ZBCoreTextKindSuperCS) {
                
                view = [[self createView] createSuperCSViewFromCoreText:coreText];
                view.tag = coreText.tag;
            }
        }

        [self addSubview:view];
        
        
    }
}

/**
 *  返回ZBCoreTextView高度，通过传人正则匹配数组。
 */
+ (CGFloat)heightFromRegularMatchArray:(NSArray *)rmArray {
    
    CGFloat totalHeight = 0.0;
    
    for (ZBCoreText *coreText in rmArray) {
        
        totalHeight += coreText.rect.size.height;
        
    }
    return totalHeight;
}

#pragma mark -- ZBCoreTextGetViewDelegate
- (void)coreTextGetViewShouldRefresh:(ZBCoreTextGetView *)coreTextGetView {
    if ([self.delegate respondsToSelector:@selector(coreTextViewShouldRefresh:)]) {
        [self.delegate coreTextViewShouldRefresh:self];
    }
}
- (void)coreTextGetView:(ZBCoreTextGetView *)getView clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID {
    if ([self.delegate respondsToSelector:@selector(coreTextView:clickedImageView:imageID:)]) {
        [self.delegate coreTextView:self clickedImageView:imageView imageID:imageID];
    }
}
- (void)coreTextGetView:(ZBCoreTextGetView *)getView textTouchBeginRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(coreTextView:textTouchBeginRun:)]) {
        [self.delegate coreTextView:self textTouchBeginRun:run];
    }
}
- (void)coreTextGetView:(ZBCoreTextGetView *)getView textTouchEndRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(coreTextView:textTouchEndRun:)]) {
        [self.delegate coreTextView:self textTouchEndRun:run];
    }
}
- (void)coreTextGetView:(ZBCoreTextGetView *)getView textTouchCanceledRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(coreTextView:textTouchCanceledRun:)]) {
        [self.delegate coreTextView:self textTouchCanceledRun:run];
    }
}
@end
