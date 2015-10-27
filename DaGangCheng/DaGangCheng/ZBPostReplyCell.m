//
//  ZBPostReplyCell.m
//  DaGangCheng
//
//  Created by huaxo on 15-6-30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "ZBPostReplyCell.h"

@implementation ZBPostReplyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    //点赞按钮
    
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    self.praiseBtn = praiseBtn;
    [self.praiseBtn setImage:[UIImage imageNamed:@"点赞_查看话题.png"] forState:UIControlStateNormal];
    [self.praiseBtn setImage:[UIImage imageNamed:@"点赞_查看话题_h.png"] forState:UIControlStateHighlighted];
    [self.praiseBtn setImage:[UIImage imageNamed:@"已赞_查看话题.png"] forState:UIControlStateSelected];
    
    [self.praiseBtn setTitleColor:UIColorFromRGB(0x98999a) forState:UIControlStateNormal];
    [self.praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    self.clipsToBounds = YES;
    [self.praiseBtn addTarget:self action:@selector(clickedPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.praiseBtn.selected = NO;
    
    [self addSubview:self.praiseBtn];
    
    //点赞和更多操作之间的线
    UIImageView *praiseLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.praiseLine = praiseLine;
    self.praiseLine.backgroundColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.praiseLine];
    
    //更多操作按钮
    UIButton *repleyManager = [[UIButton alloc] initWithFrame:CGRectZero];
    self.repleyManager = repleyManager;
    [self addSubview:self.repleyManager];
    
    //头像背景
    UIImageView *txViewBg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.txViewBg = txViewBg;
    self.txViewBg.image = [UIImage imageNamed:@"head_bg.png"];
    [self addSubview:self.txViewBg];
    
    //头像
    UIButton *txView = [[UIButton alloc] initWithFrame:CGRectZero];
    self.txView = txView;
    self.txView.layer.cornerRadius = 20;
    self.txView.layer.masksToBounds = YES;
    [self addSubview:self.txView];

    
    //昵称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    self.nameLabel.textColor = UIColorFromRGB(0x3668b2);
    [self addSubview:self.nameLabel];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel = timeLabel;
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = UIColorFromRGB(0x98999a);
    [self addSubview:self.timeLabel];
    
    //评论
    ZBCoreTextView *contentTextView = [[ZBCoreTextView alloc] initWithFrame:CGRectZero];
    self.contentTextView = contentTextView;
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.delegate = self;
    [self addSubview:self.contentTextView];
    
    //顶部线
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.topLine = topLine;
    self.topLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.topLine];
    
    //底部线
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bottomLine = bottomLine;
    self.bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.bottomLine];
}

- (void)updateUI {

    //点赞
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",self.reply.praiseNumber] forState:UIControlStateNormal];
    [self.praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
    self.praiseBtn.selected = self.reply.isPraised;
    //分割线
    
    //回复操作按钮
    [self.repleyManager setImage:[UIImage imageNamed:@"更多操作_评论_查看话题.png"] forState:UIControlStateNormal];
    [self.repleyManager setImage:[UIImage imageNamed:@"更多操作_评论_查看话题_h.png"] forState:UIControlStateHighlighted];
    [self.repleyManager addTarget:self action:@selector(clickedLayer:) forControlEvents:UIControlEventTouchUpInside];
    //头像
    [self.txView sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.reply.userImageID w:60]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
    [self.txView addTarget:self action:@selector(clickedHeadPortrait:) forControlEvents:UIControlEventTouchUpInside];
    //昵称
    self.nameLabel.text = self.reply.userName;
    
    //时间
    NSString *timeStr = [TimeUtil getFriendlyTime:[NSNumber numberWithLong:self.reply.createTime]];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld%@  %@",self.reply.layerNumber,GDLocalizedString(@"楼"),timeStr];
    
    //评论
    self.contentTextView.regularMatchArray = self.reply.regularMatchArray;
    for (int i=0; i<[self.contentTextView.subviews count]; i++){
        [(UIView *)self.contentTextView.subviews[i] removeFromSuperview];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //点赞
    self.praiseBtn.frame = CGRectMake(self.bounds.size.width - 90, 0, 56, 45);

    //分割线
    self.praiseLine.frame = CGRectMake(self.bounds.size.width - 35, 13, 1, 19);
    
    //回复操作按钮
    self.repleyManager.frame = CGRectMake(self.bounds.size.width-34, 0, 34, 45);

    //头像背景
    self.txViewBg.frame = CGRectMake(8, 8, 44, 44);
    
    //头像
    self.txView.frame = CGRectMake(10, 10, 40, 40);
    
    //昵称
    self.nameLabel.frame = CGRectMake(62, 16, 100, 15);
    
    //时间
    self.timeLabel.frame = CGRectMake(62, 38, 100, 12);
    
    //评论
    CGFloat contentTextViewHeight = [ZBCoreTextView heightFromRegularMatchArray:self.reply.regularMatchArray];
    self.contentTextView.frame = CGRectMake(ZBPostReplyCellContentLeft, 60, ZBPostReplyCellContentWidth, contentTextViewHeight);
    [self.contentTextView layoutSubviews];
    

    
    //底部线
    self.bottomLine.frame = CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5);
    
    //顶部线
    self.topLine.frame = CGRectMake(0, 0, frame.size.width, 0.5);
    
}

+ (CGFloat)heightFromReply:(ZBReply *)reply {
    CGFloat height = 0.0f;
    height += 50 + 20;
    height += [ZBCoreTextView heightFromRegularMatchArray:reply.regularMatchArray];

    return height;
}

- (void)clickedPraiseBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(postReplyCell:clickedPraiseButton:Row:)]) {
        [self.delegate postReplyCell:self clickedPraiseButton:sender Row:self.indexPath.row];
    }

}

- (void)clickedLayer:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(postReplyCell:clickedReplyManagerButton:row:)]) {
        [self.delegate postReplyCell:self clickedReplyManagerButton:sender row:self.indexPath.row];
    }
    
}

- (void)clickedHeadPortrait:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(postReplyCell:clickedHeadPortraitFromUid:imageID:)]) {
        [self.delegate postReplyCell:self clickedHeadPortraitFromUid:self.reply.uid imageID:self.reply.userImageID];
    }
}

#pragma mark -- ZBCoreTextViewDelegate
- (void)coreTextView:(ZBCoreTextView *)view textTouchBeginRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postReplyCell:textTouchBeginRun:)]) {
        [self.delegate postReplyCell:self textTouchBeginRun:run];
    }
}
- (void)coreTextView:(ZBCoreTextView *)view textTouchEndRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postReplyCell:textTouchEndRun:)]) {
        [self.delegate postReplyCell:self textTouchEndRun:run];
    }
}
- (void)coreTextView:(ZBCoreTextView *)view textTouchCanceledRun:(ZBRichTextRun *)run {
    if ([self.delegate respondsToSelector:@selector(postReplyCell:textTouchCanceledRun:)]) {
        [self.delegate postReplyCell:self textTouchCanceledRun:run];
    }
}
- (void)coreTextViewShouldRefresh:(ZBCoreTextView *)coreTextView {
    if ([self.delegate respondsToSelector:@selector(postReplyCellShouldRefresh:)]) {
        [self.delegate postReplyCellShouldRefresh:self];
    }
}
- (void)coreTextView:(ZBCoreTextView *)View clickedImageView:(UIImageView *)imageView imageID:(NSString *)imageID {
    if ([self.delegate respondsToSelector:@selector(postReplyCell:clickedImageView:imageID:)]) {
        [self.delegate postReplyCell:self clickedImageView:imageView imageID:imageID];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
