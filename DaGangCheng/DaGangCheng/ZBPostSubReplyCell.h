//
//  ZBPostSubReplyCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBSubReply.h"
#import "ZBRichTextView.h"
#import "ZBReply.h"

#define ZBPostReplyCellContentLeft 62

@class ZBPostSubReplyCell;

@protocol ZBPostSubReplyCellDelegate <NSObject>

@optional
- (void)postSubReplyCell:(ZBPostSubReplyCell *)cell touchBeginRun:(ZBRichTextRun *)run;
- (void)postSubReplyCell:(ZBPostSubReplyCell *)cell touchCanceledRun:(ZBRichTextRun *)run;
- (void)postSubReplyCell:(ZBPostSubReplyCell *)cell touchEndRun:(ZBRichTextRun *)run;

@end

@interface ZBPostSubReplyCell : UITableViewCell <ZBRichTextViewDelegate>

@property (weak, nonatomic) id<ZBPostSubReplyCellDelegate>delegate;

@property (nonatomic, weak) ZBRichTextView *textView;

@property (nonatomic, weak) UIImageView *bottomLine;

@property (nonatomic, strong) ZBSubReply *subReply;

+ (CGFloat)heightFromSubReply:(ZBSubReply *)subReply;
@end
