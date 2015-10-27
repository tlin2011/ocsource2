//
//  MyRightMsgCell.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyMsgRightCell.h"

@implementation MyMsgRightCell

- (void)initSubviews {
    [super initSubviews];
    
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImage *image = [UIImage imageNamed:@"chat_right_bg.png"];
    image = [image stretchableImageWithLeftCapWidth:40 topCapHeight:31];
    self.msgView.image = image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    //头像
    self.headButton.frame = CGRectMake(frame.size.width-11-35, 4, 35, 35);
    
    //时间
    self.timeLabel.frame = CGRectMake(frame.size.width-56-160, 2, 160, 20);
    
    //评论
    CGFloat contentTextViewHeight = [ZBCoreTextView heightFromRegularMatchArray:self.chat.regularMatchArray];
    self.contentTextView.frame = CGRectMake(frame.size.width-30-self.chat.rect.size.width-35, 30, self.chat.rect.size.width, contentTextViewHeight);
    [self.contentTextView layoutSubviews];
    
    //消息框
    self.msgView.frame = CGRectMake(frame.size.width-50-self.chat.rect.size.width-35, 20, self.chat.rect.size.width+35, contentTextViewHeight+22);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
