//
//  MyMsgLeftCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyMsgLeftCell.h"

@implementation MyMsgLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    //头像
    UIButton *headButton = [[UIButton alloc] initWithFrame:CGRectZero];

    self.headButton = headButton;
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 5;
    [self addSubview:self.headButton];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel = timeLabel;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLabel];
    
    //消息框
    UIImageView *msgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.msgView = msgView;
    UIImage *image = [UIImage imageNamed:@"chat_left_bg.png"];
    image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:31];
    self.msgView.image = image;
    [self addSubview:self.msgView];
    
    //评论
    ZBCoreTextView *contentTextView = [[ZBCoreTextView alloc] initWithFrame:CGRectZero];
    self.contentTextView = contentTextView;
    self.contentTextView.delegate = self;
    [self addSubview:self.contentTextView];
    
}

- (void)updateUI {
    
    //头像
    [self.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:self.chat.userImageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];

    //时间
    self.timeLabel.text = self.chat.combinationCreateTime;
    
    //评论
    self.contentTextView.regularMatchArray = self.chat.regularMatchArray;
    for (int i=0; i<[self.contentTextView.subviews count]; i++){
        [(UIView *)self.contentTextView.subviews[i] removeFromSuperview];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if ([self isMemberOfClass:[MyMsgLeftCell class]]) {
    
        //头像
        self.headButton.frame = CGRectMake(11, 4, 35, 35);
        
        //时间
        self.timeLabel.frame = CGRectMake(56, 2, 160, 20);
        
        //评论
        CGFloat contentTextViewHeight = [ZBCoreTextView heightFromRegularMatchArray:self.chat.regularMatchArray];
        self.contentTextView.frame = CGRectMake(66, 30, self.chat.rect.size.width, contentTextViewHeight);
        [self.contentTextView layoutSubviews];
        
        //消息框
        self.msgView.frame = CGRectMake(50, 20, self.chat.rect.size.width+35, contentTextViewHeight+22);
    }
    
}

+ (CGFloat)heightFromChat:(ZBChat *)chat {
    CGFloat height = [ZBCoreTextView heightFromRegularMatchArray:chat.regularMatchArray];
    height += 40;
    
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
