//
//  ZBPostSubReplyView.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPostSubReplyCell.h"

@implementation ZBPostSubReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    UIImageView *bottomLine  = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bottomLine = bottomLine;
    self.bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.bottomLine];
    
    ZBRichTextView *textView = [[ZBRichTextView alloc] initWithFrame:CGRectZero];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = UIColorFromRGB(0x32373e);
    textView.lineSpace = 4.0f;
    textView.font = [UIFont systemFontOfSize:14];
    textView.delegage = self;
    self.textView = textView;
    [self addSubview:self.textView];
}

- (void)updateUI {
    //self.textView.text = self.subReply.content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    self.bottomLine.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
    
    
    
    //CGRectMake(8, 37, self.frame.size.width-8*2, 28)
    self.textView.text = self.subReply.combinationContent;
    self.textView.frame = CGRectMake(ZBPostReplyCellContentLeft, 3, self.subReply.rect.size.width, self.subReply.rect.size.height);
    
}

+ (CGFloat)heightFromSubReply:(ZBSubReply *)subReply {
    return (subReply.rect.size.height + 6);
}

#pragma mark -- ZBRichTextViewDelegate
- (void)richTextView:(ZBRichTextView *)view modifyAttributedText:(NSMutableAttributedString *)attributedText {
    
    NSRange userNameRange = NSMakeRange(0, self.subReply.userName.length);
    [attributedText addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)UIColorFromRGB(0x3668b2).CGColor range:userNameRange];
    
    NSRange createTimeRange = NSMakeRange(attributedText.length-self.subReply.combinationCreateTime.length, self.subReply.combinationCreateTime.length);
    [attributedText addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)UIColorFromRGB(0x98999a).CGColor range:createTimeRange];
    
}
- (void)richTextView:(ZBRichTextView *)view touchBeginRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postSubReplyCell:touchBeginRun:)]) {
        [self.delegate postSubReplyCell:self touchBeginRun:run];
    }
}
- (void)richTextView:(ZBRichTextView *)view touchCanceledRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postSubReplyCell:touchCanceledRun:)]) {
        [self.delegate postSubReplyCell:self touchCanceledRun:run];
    }
}
- (void)richTextView:(ZBRichTextView *)view touchEndRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postSubReplyCell:touchEndRun:)]) {
        [self.delegate postSubReplyCell:self touchEndRun:run];
    }
}

@end
