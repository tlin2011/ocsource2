//
//  ZBPostReplyCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCoreTextView.h"
#import "ZBReply.h"

#define ZBPostReplyCellContentLeft 62
#define ZBPostReplyCellContentWidth (DeviceWidth - 62 - 10)

@class ZBPostReplyCell;
@protocol ZBPostReplyCellDelegate <NSObject>

@optional
- (void)postReplyCell:(ZBPostReplyCell *)replyCell textTouchBeginRun:(ZBRichTextRun *)run;
- (void)postReplyCell:(ZBPostReplyCell *)replyCell textTouchEndRun:(ZBRichTextRun *)run;
- (void)postReplyCell:(ZBPostReplyCell *)replyCell textTouchCanceledRun:(ZBRichTextRun *)run;
@required
- (void)postReplyCellShouldRefresh:(ZBPostReplyCell *)replyCell;
- (void)postReplyCell:(ZBPostReplyCell *)replyCell clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID;

- (void)postReplyCell:(ZBPostReplyCell *)replyCell clickedReplyManagerButton:(UIButton *)managerButton row:(NSInteger)row;
- (void)postReplyCell:(ZBPostReplyCell *)replyCell clickedPraiseButton:(UIButton *)praiseButton Row:(NSInteger)row;
- (void)postReplyCell:(ZBPostReplyCell *)View clickedHeadPortraitFromUid:(long)uid imageID:(long)imageID;
@end

@interface ZBPostReplyCell : UITableViewCell<ZBCoreTextViewDelegate>

@property (strong, nonatomic) ZBReply *reply;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak,   nonatomic) id<ZBPostReplyCellDelegate>delegate;

@property (weak, nonatomic) UIButton *repleyManager;
@property (weak, nonatomic) UIImageView *praiseLine;
@property (weak, nonatomic) UIButton *praiseBtn;

@property (weak, nonatomic) UIButton *txView;
@property (weak, nonatomic) UIImageView *txViewBg;

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UIImageView *bottomLine;
@property (weak, nonatomic) UIImageView *topLine;

@property (weak, nonatomic) ZBCoreTextView *contentTextView;

+ (CGFloat)heightFromReply:(ZBReply *)reply;
- (void)updateUI;
@end
