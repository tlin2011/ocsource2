//
//  MyTableViewMessageCell.h
//  DaGangCheng
//
//  Created by huaxo on 15-7-22.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipLabel.h"

@class MyTableViewMessageCell;

@protocol MyTableViewMessageCellDelegate <NSObject>

@optional
- (void)myTableViewMessageCell:(MyTableViewMessageCell *)cell clickedMyDynamicButton:(UIButton *)button;
- (void)myTableViewMessageCell:(MyTableViewMessageCell *)cell clickedMyTalkButton:(UIButton *)button;

@end

@interface MyTableViewMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *myDynamicIco;
@property (nonatomic, strong) UILabel *myDynamicLabel;
@property (nonatomic, strong) UIButton *myDynamicButton;
@property (nonatomic, strong) TipLabel *myDynamicTipLabel;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIImageView *myTalkIco;
@property (nonatomic, strong) UILabel *myTalkLabel;
@property (nonatomic, strong) UIButton *myTalkButton;
@property (nonatomic, strong) TipLabel *myTalkTipLabel;

@property (nonatomic,   weak) id<MyTableViewMessageCellDelegate>delegate;

- (void)updateUI;
+ (CGFloat)heightWithCell;
@end
