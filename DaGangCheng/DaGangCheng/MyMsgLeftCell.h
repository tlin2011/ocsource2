//
//  MyMsgLeftCell.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

#import "ZBCoreTextView.h"
#import "ZBChat.h"

@interface MyMsgLeftCell : UITableViewCell

@property (strong, nonatomic) ZBChat *chat;

@property (weak, nonatomic) UIButton *headButton;

@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UIImageView *msgView;

@property (weak, nonatomic) ZBCoreTextView *contentTextView;

//cell height
+ (CGFloat)heightFromChat:(ZBChat *)chat;

- (void)initSubviews;
- (void)updateUI;
@end
