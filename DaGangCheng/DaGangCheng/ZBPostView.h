//
//  ZBPostView.h
//  DaGangCheng
//
//  Created by huaxo on 15-6-24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBCoreTextView.h"
#import "ZBPostListButton.h"
#import "ZBNumberUtil.h"
#import "Post.h"
#import "ZBTiebaPostCell.h"

@class ZBPostView;

@protocol ZBPostViewDelegate <NSObject>

@optional
- (void)postView:(ZBPostView *)view textTouchBeginRun:(ZBRichTextRun *)run;
- (void)postView:(ZBPostView *)view textTouchEndRun:(ZBRichTextRun *)run;
- (void)postView:(ZBPostView *)view textTouchCanceledRun:(ZBRichTextRun *)run;
@required
- (void)postViewShouldRefresh:(ZBPostView *)postView;
- (void)postView:(ZBPostView *)View clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID;
- (void)postView:(ZBPostView *)View clickedHeadPortraitFromUid:(NSString *)uid imageID:(NSInteger)imageID;
- (void)postView:(ZBPostView *)View clickedPindaoName:(NSString *)pindaoName pindaoID:(NSString *)pindaoID;
@end

@interface ZBPostView : UIView <ZBCoreTextViewDelegate>

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSArray *regularMatchArray;

@property (nonatomic, weak) id<ZBPostViewDelegate>delegate;
@property (nonatomic, weak) UITableView *tableView;

@property (weak, nonatomic) UIButton *txView;  //头像
@property (weak, nonatomic) ZBPostListButton *browseBtn;

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UILabel *subjectLabel;
@property (weak, nonatomic) ZBCoreTextView *contentTextView;

@property (weak, nonatomic) UILabel *fromPindao;
@property (weak, nonatomic) UIButton *fromPindaoName;
@property (weak, nonatomic) UIImageView *signImage;
@property (weak, nonatomic) UIButton *bossIco; //楼主ico

@property (weak, nonatomic) UILabel *loctionAddr;  //地址
@property (weak, nonatomic) UIImageView *loctionIco;  //地址ico

@property (weak, nonatomic) UIImageView *bottomLine;

- (void)updateData;
+ (CGFloat)heightFromRegularMatchArray:(NSArray *)rmArray post:(Post *)post;
@end
